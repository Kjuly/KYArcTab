//
//  KYArcTab.m
//  KYArcTab
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KYArcTab.h"
#import <QuartzCore/QuartzCore.h>

@interface KYArcTab () {
 @private
//  UIView      * menuArea_;
//  UIImageView * arrow_;
//  
  CGFloat triangleHypotenuse_;
  CGPoint newPositionForArrow_;
  CGFloat currArcForArrow_;
}

@property (nonatomic, strong) UIView *menuArea;
@property (nonatomic, strong) KYArcTabArrowView *arrow;
@property (nonatomic, strong) NSArray *buttons;

//// Button actions except for the |-touchDownAction:|
///*! Action of touch up inside tab bar item. */
//- (void)_touchUpInsideAction:(UIButton *)button;
///*! Action of other touches on tab bar item. */
//- (void)_otherTouchesAction:(UIButton*)button;

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

- (void)initializeBackgroundColor;

@end


@implementation KYArcTab

@synthesize items = _items;
@synthesize selectedIndex = _selectedIndex;
@dynamic selectedItem;

#pragma mark - Accessor
- (void)setItems:(NSArray *)items {
	[self setItems:items animated:NO];
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated {
	
	[self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
	NSMutableArray *newButtons = [NSMutableArray arrayWithCapacity:items.count];
	
	for (KYArcTabItem *tabItem in items) {
				
		UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		[aButton setImage:tabItem.image forState:UIControlStateNormal];
//		[aButton setImage:tabItem.image forState:UIControlStateHighlighted];	// TODO:		
		[aButton addTarget:self action:@selector(touchDownAction:)      forControlEvents:UIControlEventTouchDown];

		[newButtons addObject:aButton];
		[self.menuArea addSubview:aButton];
	}
	
	self.buttons = newButtons.copy;
	[self _setFrameForButtonsBasedOnItemCount];
	
	_items = items.copy;
	
	
	if (self.buttons.count == 0) {
		return;
	}
	
	// Top Circle Arrow
	UIButton * button = [self.buttons objectAtIndex:0];
	self.arrow = [[KYArcTabArrowView alloc] initWithFrame:button.frame];//[[UIImageView alloc] initWithImage:[UIImage imageNamed:kKYITabBarArrow]];
//	[self.arrow setFrame:button.frame];
	[self.menuArea addSubview:self.arrow];
	
	CGFloat itemSize = 44.0f;
	CGFloat radius         = triangleHypotenuse_;
	CGFloat centerOriginY  = triangleHypotenuse_;
	newPositionForArrow_   = CGPointMake(button.frame.origin.x + itemSize  * .5f,
										 button.frame.origin.y + itemSize * .5f);
	currArcForArrow_       = M_PI + asinf((centerOriginY - newPositionForArrow_.y) / radius);
	
	_selectedIndex = 0;
}

- (void)setSelectedItem:(KYArcTabItem *)selectedItem {
	
	if ([self.items containsObject:selectedItem] == NO) {
		return;
	}
	
	self.selectedIndex = [self.items indexOfObject:selectedItem];
}

- (KYArcTabItem *)selectedItem {
	return (self.items.count != 0) ? self.items[self.selectedIndex] : nil;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
	
	[self touchDownAction:self.buttons[selectedIndex]];
	
	_selectedIndex = selectedIndex;
}

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
		
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		self.opaque = NO;
		
		CGFloat itemSize = 44.0f;
		CGFloat menuAreaHeight = frame.size.height - itemSize * 0.5f - 8.0f;
		CGRect menuFrame = frame;
		menuFrame.origin = CGPointZero;
		menuFrame.origin.y = frame.size.height - menuAreaHeight;
		
		self.menuArea = [[UIView alloc] initWithFrame:menuFrame];
		
		[self addSubview:self.menuArea];
		
		
		// Calculate |triangleHypotenuse_|
		CGFloat tabAreaHalfHeight = self.frame.size.height * .5f;
		CGFloat tabAreaHalfWidth  = self.frame.size.width  * .5f;
		triangleHypotenuse_       = (pow(tabAreaHalfHeight, 2) + pow(tabAreaHalfWidth, 2)) / self.frame.size.height;
		
		self.previousItemIndex = 0;
		_selectedIndex = 0;
		
		[self initializeBackgroundColor];
	}
	return self;
}

#pragma mark - Initialize
- (void)initializeBackgroundColor {

// TODO:
	
	self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat height = self.frame.size.height;
	CGFloat width = self.frame.size.width;
	CGFloat radius = height + ((width * width) / (4 * height));
		
// FixMe:
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0, height);
	CGContextAddArc(context, width / 2.0f, radius + 2, radius, 0, 2 * M_PI, 1);
	CGContextClosePath(context);
	
	CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.1f alpha:1.0f].CGColor);
	CGContextFillPath(context);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0, height);
	CGContextAddArc(context, width / 2.0f, radius + 2, radius, 0, 2 * M_PI, 1);
	CGContextClosePath(context);

	CGContextSetLineWidth(context, 4.0f);
	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextStrokePath(context);
}

#pragma mark - Legacy

#pragma mark - Public Method

// Action of touch down on tab bar item
- (void)touchDownAction:(UIButton *)button
{
  [self _dimAllButtonsExcept:button];
  [self _moveArrowToNewPosition];
  
  NSInteger newSelectedItemIndex = [self.buttons indexOfObject:button];
  if ([self.delegate respondsToSelector:@selector(touchDownAtItemAtIndex:withPreviousItemIndex:)])
    [self.delegate touchDownAtItemAtIndex:newSelectedItemIndex withPreviousItemIndex:self.previousItemIndex];
  self.previousItemIndex = newSelectedItemIndex;
	_selectedIndex = newSelectedItemIndex;
}

// Action for selected item
- (void)selectItemAtIndex:(NSInteger)index
{
  UIButton * button = [self.buttons objectAtIndex:index];
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

//#pragma mark - Private Methods of Button Actions
//
//// Action of touch up inside tab bar item
//- (void)_touchUpInsideAction:(UIButton *)button
//{
//  [self _dimAllButtonsExcept:button];
//  	
//  if ([self.delegate respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
//    [self.delegate touchUpInsideItemAtIndex:[self.buttons indexOfObject:button]];
//}
//
//// Action of other touches on tab bar item
//- (void)_otherTouchesAction:(UIButton*)button
//{
//  [self _dimAllButtonsExcept:button];
//}

#pragma mark - Private Methods

// Only selected the pressed item, and highlight it
- (void)_dimAllButtonsExcept:(UIButton *)selectedButton
{
  for (UIButton * button in self.buttons) {
    if (button == selectedButton) {
      [button setSelected:YES];
      [button setHighlighted:button.selected ? NO : YES];
//      [button setTag:kKYNArcTabSelectedItemTag];
      
		CGFloat itemSize = 44.0f;
		
      // Generate new postion for |arrow_|
      CGPoint newPosition = button.frame.origin;
      newPosition.x += itemSize  * .5f;
      newPosition.y += itemSize * .5f;
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
	CGFloat itemSize = 44.0f;
  CGFloat tabAreaHalfHeight = self.frame.size.height * .5f;
  CGFloat tabAreaHalfWidth  = self.frame.size.width  * .5f;
  CGFloat buttonRadius      = itemSize    * .5f;
  CGFloat fixValue          = triangleHypotenuse_ - tabAreaHalfHeight;
  
  switch ([self.buttons count]) {
    case 2: {
      CGFloat degree    = 12.f * M_PI / 180.f; // = 15 * M_PI / 180
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
      
	  case 4: {
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
		  
	  case 5:
	  default: {
		  
		  [self _setButtonWithTag:2 origin:CGPointMake(tabAreaHalfWidth - buttonRadius,
													   tabAreaHalfHeight - triangleHypotenuse_ + fixValue - buttonRadius)];
		  
		  CGFloat degree    = M_PI / 8.0; //
		  CGFloat triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
		  CGFloat triangleB = triangleHypotenuse_ * sinf(degree);
		  [self _setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
													   tabAreaHalfHeight - triangleA - buttonRadius)];
		  [self _setButtonWithTag:4 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
													   tabAreaHalfHeight - triangleA - buttonRadius)];
		  
		  degree    = M_PI / 16; //
		  triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
		  triangleB = triangleHypotenuse_ * sinf(degree);
		  [self _setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
													   tabAreaHalfHeight - triangleA - buttonRadius)];
		  [self _setButtonWithTag:3 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
													   tabAreaHalfHeight - triangleA - buttonRadius)];
		  
		  break;
	  }

  }
}

// Set frame for button with special tag
- (void)_setButtonWithTag:(NSInteger)buttonTag
                   origin:(CGPoint)origin
{
	CGFloat itemSize = 44.0f;

  UIButton * button = [self.buttons objectAtIndex:buttonTag];
	[button setFrame:(CGRect){origin, {itemSize, itemSize}}];
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
  CGFloat tabAreaHalfHeight  = self.frame.size.height * .5f;
  CGFloat tabAreaHalfWidth   = self.frame.size.width  * .5f;
  CGFloat triangleHypotenuse = (pow(tabAreaHalfHeight, 2) + pow(tabAreaHalfWidth, 2)) / self.frame.size.height;
  
  // Values for |path|
  CGFloat radius            = triangleHypotenuse;
  CGFloat centerOriginX     = self.frame.size.width * .5f;
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

@implementation KYArcTabArrowView

- (id)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat lineWidth = 4.0f;
	
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.91f green:0.53f blue:0.07f alpha:1.0f].CGColor);
	
	CGRect drawRect = self.bounds;
	drawRect.origin.x += lineWidth / 2.0f;
	drawRect.origin.y += lineWidth / 2.0f;
	drawRect.size.width -= lineWidth;
	drawRect.size.height -= lineWidth;
	
	CGContextStrokeEllipseInRect(context, drawRect);
}

@end
