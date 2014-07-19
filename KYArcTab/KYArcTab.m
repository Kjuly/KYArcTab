//
//  KYArcTab.m
//  KYArcTab
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KYArcTab.h"

@interface KYArcTab () {
 @private
  UIView      * menuArea_;
  UIImageView * arrow_;
  
  CGFloat triangleHypotenuse_;
  CGPoint newPositionForArrow_;
  CGFloat currArcForArrow_;
}

@property (nonatomic, strong) UIView      * menuArea;
@property (nonatomic, strong) UIImageView * arrow;

// Button actions except for the |-touchDownAction:|
/*! Action of touch up inside tab bar item. */
- (void)_touchUpInsideAction:(UIButton *)button;
/*! Action of other touches on tab bar item. */
- (void)_otherTouchesAction:(UIButton*)button;

/*! Only selected the pressed item, and highlight it. */
- (void)_dimAllButtonsExcept:(UIButton *)selectedButton;
/*! Set buttons' layout for different number of the button count. */
- (void)_setFrameForButtonsBasedOnItemCount;
/*! Set frame for button with special tag. */
- (void)_setButtonWithTag:(NSInteger)buttonTag origin:(CGPoint)origin;

// Animation Control methods
//- (void)pauseLayer:(CALayer *)layer;
//- (void)resumeLayer:(CALayer *)layer;

/*! Update arrow's position. */
- (void)_moveArrowToNewPosition;

@end


static CGSize tabBarSize_, itemSize_;


@implementation KYArcTab

@synthesize delegate          = delegate_,
            buttons           = buttons_,
            previousItemIndex = previousItemIndex_;
@synthesize menuArea = menuArea_,
            arrow    = arrow_;

// Designated initializer
- (instancetype)initWithFrame:(CGRect)frame
                   tabBarSize:(CGSize)tabBarSize
              backgroundColor:(UIColor *)backgroundColor
                     itemSize:(CGSize)itemSize
                    itemCount:(NSUInteger)itemCount
                        arrow:(UIImage *)arrow
                          tag:(NSInteger)tag
                     delegate:(id <KYArcTabDelegate>)delegate
{
  if (self = [self initWithFrame:frame]) {
    // Background color
    if (backgroundColor) [self setBackgroundColor:backgroundColor];
    
    tabBarSize_ = tabBarSize;
    itemSize_   = itemSize;
    delegate_   = delegate;
    
    // The tag allows callers with multiple controls to distinguish between them
    [self setTag:tag];
    
    CGFloat menuAreaHeight = tabBarSize_.height - itemSize_.height * .5f - 8.f;
    menuArea_ = [UIView alloc];
    (void)[menuArea_ initWithFrame:(CGRect){{0.f, tabBarSize_.height - menuAreaHeight}, tabBarSize_}];
    [self addSubview:menuArea_];
    
    // Initalize the array to store buttons
    // And iterate through each item
    buttons_ = [[NSMutableArray alloc] initWithCapacity:itemCount];
    for (NSUInteger i = 0; i < itemCount; ++i) {
      UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
      [button setImage:[delegate_ iconFor:i] forState:UIControlStateNormal];
      
      // Register for touch events
      [button addTarget:self action:@selector(touchDownAction:)      forControlEvents:UIControlEventTouchDown];
      [button addTarget:self action:@selector(_touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
      [button addTarget:self action:@selector(_otherTouchesAction:)  forControlEvents:UIControlEventTouchUpOutside];
      [button addTarget:self action:@selector(_otherTouchesAction:)  forControlEvents:UIControlEventTouchDragOutside];
      [button addTarget:self action:@selector(_otherTouchesAction:)  forControlEvents:UIControlEventTouchDragInside];
      
      // Add the button to |buttons_| array
      [buttons_ addObject:button];
      [self.menuArea addSubview:button];
    }
    
    // Calculate |triangleHypotenuse_|
    CGFloat tabAreaHalfHeight = tabBarSize_.height * .5f;
    CGFloat tabAreaHalfWidth  = tabBarSize_.width  * .5f;
    triangleHypotenuse_       = (pow(tabAreaHalfHeight, 2) + pow(tabAreaHalfWidth, 2)) / tabBarSize_.height;
    
    // Set frame for button, based on |itemCount|
    [self _setFrameForButtonsBasedOnItemCount];
    
    // Top Circle Arrow
    arrow_ = [[UIImageView alloc] initWithImage:arrow];
    UIButton * button = [buttons_ firstObject];
    [arrow_ setFrame:button.frame];
    [self.menuArea addSubview:arrow_];
    
    CGFloat radius         = triangleHypotenuse_;
    CGFloat centerOriginY  = triangleHypotenuse_;
    newPositionForArrow_   = CGPointMake(button.frame.origin.x + itemSize_.width  * .5f,
                                         button.frame.origin.y + itemSize_.height * .5f);
    currArcForArrow_       = M_PI + asinf((centerOriginY - newPositionForArrow_.y) / radius);
    self.previousItemIndex = 0;
    button = nil;
  }
  return self;
}

// Secondary initializer
- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self setFrame:frame];
    [self setOpaque:NO];
  }
  return self;
}

#pragma mark - Public Method

// Action of touch down on tab bar item
- (void)touchDownAction:(UIButton *)button
{
  [self _dimAllButtonsExcept:button];
  [self _moveArrowToNewPosition];
  
  NSInteger newSelectedItemIndex = [buttons_ indexOfObject:button];
  if ([delegate_ respondsToSelector:@selector(touchDownAtItemAtIndex:withPreviousItemIndex:)]) {
    [delegate_ touchDownAtItemAtIndex:newSelectedItemIndex
                withPreviousItemIndex:self.previousItemIndex];
  }
  self.previousItemIndex = newSelectedItemIndex;
}

// Action for selected item
- (void)selectItemAtIndex:(NSInteger)index
{
  UIButton * button = buttons_[index];
  [self _dimAllButtonsExcept:button];
}

/*/ TODO:
//   This message is for device's rotation management
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
  CGFloat itemWidth = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)  ? self.window.frame.size.height : self.window.frame.size.width) / buttons_.count;
  // horizontalOffset tracks the x value
  CGFloat horizontalOffset = 0;
  
  // Iterate through each button
  for (UIButton * button in buttons_) {
    // Set the button's x offset
    button.frame = (CGRect){{horizontalOffset, 0.f}, button.frame.size};
    horizontalOffset += itemWidth;
  }
  
  // Move the arrow to the new button location
  UIButton * selectedButton = (UIButton *)[self viewWithTag:kKYNArcTabSelectedItemTag];
  [self dimAllButtonsExcept:selectedButton];
}*/

#pragma mark - Private Methods of Button Actions

// Action of touch up inside tab bar item
- (void)_touchUpInsideAction:(UIButton *)button
{
  [self _dimAllButtonsExcept:button];
  
  if ([delegate_ respondsToSelector:@selector(touchUpInsideItemAtIndex:)]) {
    [delegate_ touchUpInsideItemAtIndex:[buttons_ indexOfObject:button]];
  }
}

// Action of other touches on tab bar item
- (void)_otherTouchesAction:(UIButton*)button
{
  [self _dimAllButtonsExcept:button];
}

#pragma mark - Private Methods

// Only selected the pressed item, and highlight it
- (void)_dimAllButtonsExcept:(UIButton *)selectedButton
{
  for (UIButton * button in buttons_) {
    if (button == selectedButton) {
      [button setSelected:YES];
      [button setHighlighted:button.selected ? NO : YES];
      [button setTag:kKYNArcTabSelectedItemTag];
      
      // Generate new postion for |arrow_|
      CGPoint newPosition = button.frame.origin;
      newPosition.x += itemSize_.width  * .5f;
      newPosition.y += itemSize_.height * .5f;
      newPositionForArrow_ = newPosition;
    }
    else {
      [button setSelected:NO];
      [button setHighlighted:NO];
      [button setTag:0];
    }
  }
}

// Set buttons' layout for different number of the button count
//
//    /------------ |tabAreaHalfWidth|
//    |
//    |  |
//    v  | <------- |tabBarHalfHeight|
// ---a-------- <-- bottom of window (equal to |kKYViewHeight|)
// \     |
//  c <------------ |triangleHypotenuse|: distance to Ball Center
//   \   |b: <----- |fixValue|
//    \ ß|
//     \/|
//      \|
//
//   |degree|    = |ß|
//   |triangleA| = |fixValue| + <distance from POINT pos Y to bottom of window>
//   |triangleB| = |distance from POINT pos X to center line|
//
- (void)_setFrameForButtonsBasedOnItemCount
{
  CGFloat tabAreaHalfHeight = tabBarSize_.height * .5f;
  CGFloat tabAreaHalfWidth  = tabBarSize_.width  * .5f;
  CGFloat buttonRadius      = itemSize_.width    * .5f;
  CGFloat fixValue          = triangleHypotenuse_ - tabAreaHalfHeight;
  
  switch ([self.buttons count]) {
    case 2: {
      CGFloat degree    = 12.f * M_PI / 180.f; // = 45 * M_PI / 180
      CGFloat triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
      CGFloat triangleB = triangleHypotenuse_ * sinf(degree);
      [self _setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self _setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      break;
    }
      
    case 3: {
      CGFloat degree    = M_PI / 10.f; // 18.f * M_PI / 180.f
      CGFloat triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
      CGFloat triangleB = triangleHypotenuse_ * sinf(degree);
      [self _setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self _setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth - buttonRadius,
                                                  tabAreaHalfHeight - triangleHypotenuse_ + fixValue - buttonRadius)];
      [self _setButtonWithTag:2 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      break;
    }
      
    case 4:
    default: {
      CGFloat degree    = M_PI / 9.f; // 20.f * M_PI / 180.f
      CGFloat triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
      CGFloat triangleB = triangleHypotenuse_ * sinf(degree);
      [self _setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self _setButtonWithTag:3 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      
      degree    = M_PI / 20.f; // 9.f * M_PI / 180.f
      triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
      triangleB = triangleHypotenuse_ * sinf(degree);
      [self _setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self _setButtonWithTag:2 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      break;
    }
      
    case 5: {
      CGFloat degree    = M_PI / 10.f; // 20.f * M_PI / 180.f
      CGFloat triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
      CGFloat triangleB = triangleHypotenuse_ * sinf(degree);
      
      [self _setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                   tabAreaHalfHeight - triangleA - buttonRadius)];
      [self _setButtonWithTag:4 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                   tabAreaHalfHeight - triangleA - buttonRadius)];
      
      degree    = M_PI / 20.f; // 9.f * M_PI / 180.f
      triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
      triangleB = triangleHypotenuse_ * sinf(degree);
      [self _setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                   tabAreaHalfHeight - triangleA - buttonRadius)];
      [self _setButtonWithTag:3 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                   tabAreaHalfHeight - triangleA - buttonRadius)];
      [self _setButtonWithTag:2 origin:CGPointMake(tabAreaHalfWidth - buttonRadius,
                                                   tabAreaHalfHeight - triangleHypotenuse_ + fixValue - buttonRadius)];
      break;
    }
  }
}

// Set frame for button with special tag
- (void)_setButtonWithTag:(NSInteger)buttonTag
                   origin:(CGPoint)origin
{
  UIButton * button = (self.buttons)[buttonTag];
  [button setFrame:(CGRect){origin, itemSize_}];
}

#pragma mark - Animation Control Methods

/*-(void)pauseLayer:(CALayer *)layer {
  CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
  layer.speed = 0.f;
  layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer *)layer {
  CFTimeInterval pausedTime = [layer timeOffset];
  layer.speed = 1.f;
  layer.timeOffset = 0.f;
  layer.beginTime = 0.f;
  CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
  layer.beginTime = timeSincePause;
}*/

// Update arrow's position
- (void)_moveArrowToNewPosition
{
  CGFloat tabAreaHalfHeight  = tabBarSize_.height * .5f;
  CGFloat tabAreaHalfWidth   = tabBarSize_.width  * .5f;
  CGFloat triangleHypotenuse = (pow(tabAreaHalfHeight, 2) + pow(tabAreaHalfWidth, 2)) / tabBarSize_.height;
  
  // Values for |path|
  CGFloat radius            = triangleHypotenuse;
  CGFloat centerOriginX     = tabBarSize_.width * .5f;
  CGFloat centerOriginY     = triangleHypotenuse;
  CGFloat itemCenterOriginX = newPositionForArrow_.x;
  CGFloat itemCenterOriginY = newPositionForArrow_.y;
  CGFloat arc      = asinf((centerOriginY - itemCenterOriginY) / radius);
  CGFloat newAngle = itemCenterOriginX < centerOriginX ? M_PI + arc : M_PI * 2 - arc;
  
  // Animation for arrow's movement
  CAKeyframeAnimation * arrowMovementAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  // Path for the movement
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddArc(path, NULL,
               centerOriginX, centerOriginY,                           // center point
               radius,                                                 // radius
               currArcForArrow_, newAngle,                             // new angle for the new point
               (itemCenterOriginX < CGRectGetMinX(self.arrow.frame))); // clock wise or not
  arrowMovementAnimation.path = path;
#ifdef KY_ARCTAB_DEBUG_GRAPHICS
  CAShapeLayer * pathTrack = [CAShapeLayer layer];
  pathTrack.path = path;
	pathTrack.strokeColor = [UIColor blackColor].CGColor;
	pathTrack.fillColor = [UIColor clearColor].CGColor;
	pathTrack.lineWidth = 10.0;
	[self.layer addSublayer:pathTrack];
#endif
  CGPathRelease(path);
  
  // Update the value of current arc for arrow
  currArcForArrow_ = newAngle;
  
  arrowMovementAnimation.delegate = self;
  arrowMovementAnimation.duration = .3f;
  arrowMovementAnimation.repeatCount = 1;
  //arrowMovementAnimation.cumulative = YES;
  //arrowMovementAnimation.additive = YES;
  arrowMovementAnimation.calculationMode = kCAAnimationPaced;
  arrowMovementAnimation.fillMode = kCAFillModeForwards;
  arrowMovementAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  arrowMovementAnimation.removedOnCompletion = NO;
  [self.arrow.layer addAnimation:arrowMovementAnimation forKey:@"arrowMovement"];
}

#pragma mark - CAAnimation delegate

// Called when the animation completes its active duration
//   or is removed from the object it is attached to.
- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag
{
  // Update the layer's position so that the layer doesn't snap back when the animation completes
  [self.arrow.layer setPosition:newPositionForArrow_];
}

@end
