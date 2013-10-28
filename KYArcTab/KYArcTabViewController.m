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


@implementation KYArcTabViewController

@synthesize tabBar = _tabBar;
@synthesize selectedIndex = _selectedIndex;
@synthesize viewControllers = _viewControllers;
@dynamic selectedViewController;

#pragma mark - Accessor
- (void)setViewControllers:(NSArray *)viewControllers {
	
	for (UIViewController *controller in viewControllers) {
		[controller.view removeFromSuperview];
		[controller removeFromParentViewController];
		[controller willMoveToParentViewController:self];
		
		controller.view.frame = self.view.frame;	//TODO: sub arcTab height
		
		// Place the layout for view's layer
		controller.view.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
		controller.view.layer.position = CGPointMake(self.view.frame.size.width * 0.5f, self.view.frame.size.height);	// was kKYArcTabViewHeight

		[self addChildViewController:controller];
		[controller didMoveToParentViewController:self];
	}
	
	_viewControllers = viewControllers.copy;
	
// TODO: Inherit the previous selected view
	
	self.selectedIndex = 0;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
	
	if ([self.viewControllers containsObject:selectedViewController] == NO) {
		return;
	}
	
	self.selectedIndex = [self.viewControllers indexOfObject:selectedViewController];
}

- (UIViewController *)selectedViewController {
	return self.viewControllers[self.selectedIndex];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
	
#warning TODO
	[self.tabBar selectItemAtIndex:selectedIndex];
	[self touchDownAtItemAtIndex:selectedIndex withPreviousItemIndex:0];
	
	_selectedIndex = selectedIndex;
}

- (NSArray *)customizableViewControllers {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (UINavigationController *)moreNavigationController {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGSize tabBarSize = (CGSize){kKYTabBarWdith, kKYTabBarHeight};
	CGRect tabBarFrame = (CGRect){{(kKYArcTabViewWidth - tabBarSize.width) * .5f, CGRectGetHeight((CGRect){CGPointZero, {kKYViewWidth, kKYViewHeight}})}, tabBarSize};

	_tabBar = [[KYArcTab alloc] initWithFrame:tabBarFrame
									   tabBarSize:(CGSize){kKYTabBarWdith, kKYTabBarHeight}
								  backgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kKYITabBarBackground]]
										 itemSize:(CGSize){kKYTabBarItemWidth, kKYTabBarItemHeight}
										itemCount:4//self.viewControllers.count	// for now
											arrow:[UIImage imageNamed:kKYITabBarArrow]
											  tag:0
										 delegate:self];

	[self setTabBarHidden:YES animated:NO];
	[self.view addSubview:self.tabBar];
	
	// Select the first tab
	self.selectedIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (self.tabBar.hidden == YES) {
		[self setTabBarHidden:NO animated:YES];	// animate after 0.6s delay
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
}

#pragma mark - AutoRotate
#pragma mark iOS6
- (BOOL)shouldAutorotate {
	return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

- (NSUInteger)supportedInterfaceOrientations {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return UIInterfaceOrientationMaskPortrait;
	} else {
	    return UIInterfaceOrientationMaskAll;
	}
}

#pragma mark iOS5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
	}
	else {
		return YES;
	}
}

#pragma mark - Appearance and Rotation Methods
#pragma mark iOS6
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
	return YES;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods {
	return YES;
}

#pragma mark iOS5
- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
	return YES;
}

#pragma mark - ArcTab
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
	
	CGRect tabBarFrame = self.tabBar.frame;
	tabBarFrame.origin.y = self.tabBar.hidden ? self.view.frame.size.height : self.view.frame.size.height - tabBarFrame.size.height;
	self.tabBar.frame = tabBarFrame;
	
	tabBarFrame.origin.y = hidden ? self.view.frame.size.height : self.view.frame.size.height - tabBarFrame.size.height;

	if (animated) {
		if (hidden == NO) {
			self.tabBar.hidden = NO;
		}
		
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.tabBar.frame = tabBarFrame;
		} completion:^(BOOL finished) {
			self.tabBar.hidden = hidden;
		}];
	}
	else {
		self.tabBar.frame = tabBarFrame;
		self.tabBar.hidden = hidden;
	}
}

#pragma mark - Legacy
//// Designated initializer
//- (id)  initWithTitle:(NSString *)title
//           tabBarSize:(CGSize)tabBarSize
//tabBarBackgroundColor:(UIColor *)tabBarBackgroundColor
//             itemSize:(CGSize)itemSize
//                arrow:(UIImage *)arrow
//{
//  if (self = [self init]) {
//    // Set title if |title| is not nil
//    if (title) [self setTitle:title];
//    
//    // Tab bar size
//    tabBarSize_ = tabBarSize;
//    
//    // Custom setup jobs
//    [self setup];
//    
//    // Create a custom tab bar passing in the number of items
//    CGRect tabBarFrame =
//      (CGRect){{(kKYArcTabViewWidth - tabBarSize_.width) * .5f,
//               CGRectGetHeight(self.viewFrame)}, tabBarSize_};
//    // Generate tab bar
//    tabBar_ = [[KYArcTab alloc] initWithFrame:tabBarFrame
//                                   tabBarSize:tabBarSize
//                              backgroundColor:tabBarBackgroundColor
//                                     itemSize:itemSize
//                                    itemCount:self.tabBarItems.count
//                                        arrow:arrow
//                                          tag:0
//                                     delegate:self];
//  }
//  return self;
//}

#pragma mark - View lifecycle


//// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad
//{
//  [super viewDidLoad];
//  
////  // Add tab bar
////  [self.view addSubview:tabBar_];
//  
////  // Select the first tab
////  [tabBar_ selectItemAtIndex:0];
////  [self touchDownAtItemAtIndex:0 withPreviousItemIndex:0];
//  
//  isTabBarHide_ = YES;
//  
////  // Place the layout for view's layer
////  for (int i = 0; i < [self.tabBarItems count]; ++i) {
////    UIView * view = [[[self.tabBarItems objectAtIndex:i] objectForKey:@"viewController"] view];
////    [view.layer setAnchorPoint:CGPointMake(.5f, 1.f)];
////    [view.layer setPosition:CGPointMake(view.frame.size.width * .5f, kKYArcTabViewHeight)];
////  }
////  
////  // Notification for togglling tab bar
////  [[NSNotificationCenter defaultCenter] addObserver:self
////                                           selector:@selector(toggleTabBar:)
////                                               name:kKYNArcTabToggleTabBar
////                                             object:nil];
//  
////  // Implement the completion block
////  // iOS4 will not call |viewWillAppear:| when the VC is a child of another VC
////  if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
////    [self viewWillAppear:YES];
//}

//- (void)viewDidUnload
//{
//  [super viewDidUnload];
//  self.tabBar = nil;
//}

//- (void)viewWillAppear:(BOOL)animated
//{
//  [super viewWillAppear:animated];
//  
//  // If |tabBar_| is hidden, show it
//  if (isTabBarHide_) [self performSelector:@selector(toggleTabBar:)
//                                withObject:nil
//                                afterDelay:.6f];
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//  // Return YES for supported orientations
//  return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

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
    UIButton * button = [self.tabBar.buttons objectAtIndex:previousItemIndex - 1];
    [self.tabBar touchDownAction:button];
    button = nil;
  }
  // Swipe to right
  else if (previousItemIndex < self.viewControllers.count - 1 && swipeDistance < -50.f) {
    UIButton * button = [self.tabBar.buttons objectAtIndex:previousItemIndex + 1];
    [self.tabBar touchDownAction:button];
    button = nil;
  }
  isSwiping_ = NO;
}

#pragma mark - KYArcTab Delegate

// Icon for the tab bar item offered
- (UIImage *)iconFor:(NSUInteger)itemIndex
{
	return nil;//[UIImage imageNamed:[[self.tabBarItems objectAtIndex:itemIndex] objectForKey:@"image"]];
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
  if (itemIndex != previousItemIndex)
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
  else [currentView removeFromSuperview];
  
  
  // Get the right view controller
  UIViewController * viewController = self.viewControllers[itemIndex];
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
//  if ([viewController respondsToSelector:@selector(viewWillAppear:)])
//    [viewController viewWillAppear:NO];
  
  [self.view insertSubview:viewController.view belowSubview:self.tabBar];
  
//  if ([viewController respondsToSelector:@selector(viewDidAppear:)])
//    [viewController viewDidAppear:NO];
}

#pragma mark - Private Methods

// Return angle (in redians) for rotation
- (CGFloat)_angleForRatationWithItemIndex:(NSUInteger)itemIndex
                        previousItemIndex:(NSUInteger)previousItemIndex
{
  CGFloat degree = (8 + (4 - self.viewControllers.count) * 2);
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
//- (void)toggleTabBar:(NSNotification *)notification
//{
//  CGRect tabBarFrame = self.tabBar.frame;
//	CGSize tabBarSize = (CGSize){kKYTabBarWdith, kKYTabBarHeight};
//
//  if (isTabBarHide_) tabBarFrame.origin.y = CGRectGetHeight((CGRect){CGPointZero, {kKYViewWidth, kKYViewHeight}}) - tabBarSize.height;
//  else               tabBarFrame.origin.y = CGRectGetHeight((CGRect){CGPointZero, {kKYViewWidth, kKYViewHeight}});
//  
//  [UIView animateWithDuration:.3f
//                        delay:0.f
//                      options:UIViewAnimationOptionCurveEaseInOut
//                   animations:^{ [self.tabBar setFrame:tabBarFrame]; }
//                   completion:^(BOOL finished) { isTabBarHide_ = ! isTabBarHide_; }];
//}

@end
