//
//  KYArcTabViewController.m
//  KYArcTab
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KYArcTabViewController.h"

@interface KYArcTabViewController () {
 @private
  BOOL    isTabBarHide_;    // mark for tab bar's visiablity
  BOOL    isSwiping_;       // doing swiping
  CGFloat swipeStartPoint_; // Value of the starting touch point's x location
}

/*! Get the delta angle between previous item & current item.
 *
 * \param itemIndex The index for target item
 * \param previousItemIndex The index for previous selected item
 *
 * \returns Delta angel value
 */
- (CGFloat)_angleForRatationWithItemIndex:(NSUInteger)itemIndex
                        previousItemIndex:(NSUInteger)previousItemIndex;

@end


static CGSize tabBarSize_; // size of tab bar


@implementation KYArcTabViewController

@synthesize tabBar      = tabBar_,
            tabBarItems = tabBarItems_,
            viewFrame   = viewFrame_;

- (void)dealloc
{
  // Remove notification observer
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Designated initializer
- (instancetype)initWithTitle:(NSString *)title
                   tabBarSize:(CGSize)tabBarSize
        tabBarBackgroundColor:(UIColor *)tabBarBackgroundColor
                     itemSize:(CGSize)itemSize
                        arrow:(UIImage *)arrow
{
  if (self = [self init]) {
    // Set title if |title| is not nil
    if (title) [self setTitle:title];
    
    // Tab bar size
    tabBarSize_ = tabBarSize;
    
    // Custom setup jobs
    [self setup];
    
    // Create a custom tab bar passing in the number of items
    CGRect tabBarFrame = (CGRect){{(kKYArcTabViewWidth - tabBarSize_.width) * .5f,
        CGRectGetHeight(self.viewFrame)}, tabBarSize_};
    // Generate tab bar
    tabBar_ = [[KYArcTab alloc] initWithFrame:tabBarFrame
                                   tabBarSize:tabBarSize
                              backgroundColor:tabBarBackgroundColor
                                     itemSize:itemSize
                                    itemCount:self.tabBarItems.count
                                        arrow:arrow
                                          tag:0
                                     delegate:self];
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  UIView * view = [[UIView alloc] initWithFrame:self.viewFrame];
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Add tab bar
  [self.view addSubview:tabBar_];
  
  // Select the first tab
  [tabBar_ selectItemAtIndex:0];
  [self touchDownAtItemAtIndex:0 withPreviousItemIndex:0];
  
  isTabBarHide_ = YES;
  
  // Place the layout for view's layer
  for (int i = 0; i < [self.tabBarItems count]; ++i) {
    UIView * view = [(self.tabBarItems)[i][@"viewController"] view];
    [view.layer setAnchorPoint:CGPointMake(.5f, 1.f)];
    [view.layer setPosition:CGPointMake(view.frame.size.width * .5f, kKYArcTabViewHeight)];
  }
  
  // Notification for togglling tab bar
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(toggleTabBar:)
                                               name:kKYNArcTabToggleTabBar
                                             object:nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.tabBar = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // If |tabBar_| is hidden, show it
  if (isTabBarHide_) [self performSelector:@selector(toggleTabBar:)
                                withObject:nil
                                afterDelay:.6f];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Touch Actions

// Tells the receiver when one or more fingers touch down in a view or window.
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
  if ([touches count] != 1) return;
  
  UIView * currentView = [self.view viewWithTag:kKYNArcTabSelectedViewControllerTag];
  swipeStartPoint_ = [[touches anyObject] locationInView:currentView].x;
  currentView = nil;
  isSwiping_ = YES;
}

// Tells the receiver when one or more fingers associated
//   with an event move within a view or window.
- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
  if (! isSwiping_ || [touches count] != 1) return;
}

// Tells the receiver when one or more fingers are raised from a view or window.
- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
  if (! isSwiping_) return;
  
  UIView * currentView  = [self.view viewWithTag:kKYNArcTabSelectedViewControllerTag];
  CGFloat swipeDistance = [[touches anyObject] locationInView:currentView].x - swipeStartPoint_;
  currentView = nil;
  NSInteger previousItemIndex = self.tabBar.previousItemIndex;
  
  // Swipe to left
  if (previousItemIndex > 0 && swipeDistance > 50.f) {
    UIButton * button = (self.tabBar.buttons)[previousItemIndex - 1];
    [self.tabBar touchDownAction:button];
    button = nil;
  }
  // Swipe to right
  else if (previousItemIndex < [self.tabBarItems count] - 1 && swipeDistance < -50.f) {
    UIButton * button = (self.tabBar.buttons)[previousItemIndex + 1];
    [self.tabBar touchDownAction:button];
    button = nil;
  }
  isSwiping_ = NO;
}

#pragma mark - KYArcTab Delegate

// Icon for the tab bar item offered
- (UIImage *)iconFor:(NSUInteger)itemIndex
{
  return [UIImage imageNamed:(self.tabBarItems)[itemIndex][@"image"]];
}

// Toggle views beween touched item & previous item
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
         withPreviousItemIndex:(NSUInteger)previousItemIndex
{
  // if |angle > 0|, rotate to left
  CGFloat angle = [self _angleForRatationWithItemIndex:itemIndex
                                     previousItemIndex:previousItemIndex];
  
  // Remove the current view controller's view
  UIView * currentView = [self.view viewWithTag:kKYNArcTabSelectedViewControllerTag];
  if (itemIndex != previousItemIndex) {
    [UIView animateWithDuration:.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       currentView.transform = CGAffineTransformRotate(currentView.transform, angle);
                       [currentView setAlpha:0.f];
                     }
                     completion:^(BOOL finished) {
                       [currentView removeFromSuperview];
                     }];
  } else [currentView removeFromSuperview];
  
  
  // Get the right view controller
  UIViewController * viewController =
    (self.tabBarItems)[itemIndex][@"viewController"];
  [viewController.view setTag:kKYNArcTabSelectedViewControllerTag];
  // Toggle views only if the touched item is not the same as the previous item
  if (itemIndex != previousItemIndex) {
    CGAffineTransform transform = CGAffineTransformIdentity;
    viewController.view.transform = CGAffineTransformRotate(transform, -angle);
    [viewController.view setAlpha:0.f];
    [UIView animateWithDuration:.3f
                          delay:.3f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       [viewController.view setAlpha:1.f];
                       viewController.view.transform =
                         CGAffineTransformRotate(viewController.view.transform, angle);
                     }
                     completion:nil];
  }
  
  // Add the new view controller's view
  if ([viewController respondsToSelector:@selector(viewWillAppear:)]) {
    [viewController viewWillAppear:NO];
  }
  
  [self.view insertSubview:viewController.view belowSubview:self.tabBar];
  
  if ([viewController respondsToSelector:@selector(viewDidAppear:)]) {
    [viewController viewDidAppear:NO];
  }
}

#pragma mark - Private Methods

// Return angle (in redians) for rotation
- (CGFloat)_angleForRatationWithItemIndex:(NSUInteger)itemIndex
                        previousItemIndex:(NSUInteger)previousItemIndex
{
  CGFloat degree = (8 + (4 - [self.tabBarItems count]) * 2);
  /*switch ([self.tabBarItems count]) {
    case 2:
      degree = 12;
      break;
      
    case 3:
      degree = 10;
      break;
      
    case 4:
    default:
      degree = 8;
      break;
  }*/
  return degree * (NSInteger)(previousItemIndex - itemIndex) * M_PI / 180.f;
}

#pragma mark - Public Methods

// Setup message, override it to do customize jobs
- (void)setup {}

// Toggle tab bar when receive the right notification
- (void)toggleTabBar:(NSNotification *)notification
{
  CGRect tabBarFrame = self.tabBar.frame;
  if (isTabBarHide_) tabBarFrame.origin.y = CGRectGetHeight(self.viewFrame) - tabBarSize_.height;
  else               tabBarFrame.origin.y = CGRectGetHeight(self.viewFrame);
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{ [self.tabBar setFrame:tabBarFrame]; }
                   completion:^(BOOL finished) { isTabBarHide_ = ! isTabBarHide_; }];
}

@end
