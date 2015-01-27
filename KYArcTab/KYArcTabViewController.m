//
//  KYArcTabViewController.m
//  KYArcTab
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KYArcTabViewController.h"

#import "KYHorizontalSwipeGestureRecognizer.h"

@interface KYArcTabViewController () <UIGestureRecognizerDelegate> {
	
	NSMutableArray *_gestureRecognizers;
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

- (void)animateBound;

@end


@implementation KYArcTabViewController

@synthesize tabBar = _tabBar;
@synthesize selectedIndex = _selectedIndex;
@synthesize viewControllers = _viewControllers;
@synthesize swipeEnagled = _swipeEnagled;
@dynamic selectedViewController;

#pragma mark - Accessor
- (void)setViewControllers:(NSArray *)viewControllers {
	
	NSMutableArray *newItems = [NSMutableArray arrayWithCapacity:viewControllers.count];
	
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
		
		if (controller.arcTabItem) {
			[newItems addObject:controller.arcTabItem];
		}
		else {
			[newItems addObject:[[KYArcTabItem alloc] init]];
		}
	}
	
	self.tabBar.items = newItems.copy;
	_viewControllers = viewControllers.copy;
	
// TODO: Inherit the previous selected view
	
//	self.selectedIndex = 0;
	self.tabBar.selectedIndex = 0;
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

	if (selectedIndex == self.tabBar.selectedIndex) {
		return;
	}
	
	self.tabBar.selectedIndex = selectedIndex;
}

- (NSInteger)selectedIndex {
	return self.tabBar.selectedIndex;
}

- (void)setSwipeEnagled:(BOOL)swipeEnagled {
	
	if (_gestureRecognizers == nil) {
		_gestureRecognizers = [[NSMutableArray alloc] initWithCapacity:2];
	}
	
	if (swipeEnagled) {
//		UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
//		leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//		[self.view addGestureRecognizer:leftSwipeGestureRecognizer];
//		[_gestureRecognizers addObject:leftSwipeGestureRecognizer];
//		
//		UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
//		rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//		[self.view addGestureRecognizer:rightSwipeGestureRecognizer];
//		[_gestureRecognizers addObject:rightSwipeGestureRecognizer];
		
		KYHorizontalSwipeGestureRecognizer *swipeGestureRecognizer = [[KYHorizontalSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
		swipeGestureRecognizer.delegate = self;
		[self.view addGestureRecognizer:swipeGestureRecognizer];
		[_gestureRecognizers addObject:swipeGestureRecognizer];
	}
	else {
		for (UIGestureRecognizer *gestureRecognizer in _gestureRecognizers) {
			[self.view removeGestureRecognizer:gestureRecognizer];
		}
	}
	
	_swipeEnagled = swipeEnagled;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect tabBarFrame = self.view.bounds;
	tabBarFrame.size.height = 88.0f;
	tabBarFrame.origin.y = self.view.frame.size.height - tabBarFrame.size.height;
	_tabBar = [[KYArcTab alloc] initWithFrame:tabBarFrame];
	self.tabBar.delegate = self;
	
	[self.view addSubview:self.tabBar];
	[self setTabBarHidden:YES animated:NO];
	
	// Select the first tab
	// self.selectedIndex = 0; doesn't work in here
	self.tabBar.selectedIndex = 0;
//	self.selectedIndex = 0;
	
	self.swipeEnagled = NO;
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

#pragma mark - Swipe
- (void)didSwipe:(KYHorizontalSwipeGestureRecognizer *)swipeGestureRecognizer {
	
	if (swipeGestureRecognizer.direction == KYHorizontalSwipeGestureRecognizerDirectionLeft) {
		[self swipeLeft:(id)swipeGestureRecognizer];
	}
	else if (swipeGestureRecognizer.direction == KYHorizontalSwipeGestureRecognizerDirectionRight) {
		[self swipeRight:(id)swipeGestureRecognizer];
	}
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
	
	if (self.selectedIndex < self.viewControllers.count - 1) {
		self.selectedIndex++;
	}
	else {
		[self animateBound];
	}
}

- (void)swipeRight:(UISwipeGestureRecognizer *)swipeGestureRecognizer {

	if (self.selectedIndex > 0) {
		self.selectedIndex--;
	}
	else {
		[self animateBound];
	}
}

#pragma mark - Animation
- (void)animateBound {
// TODO:
	
	UIView * currentView = self.selectedViewController.view;

	CGFloat angle = (4 * M_PI / 180.f) * (self.selectedIndex == 0 ? +1 : -1);
	
	[UIView animateWithDuration:.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
						 currentView.transform = CGAffineTransformRotate(currentView.transform, angle);
                     }
                     completion:^(BOOL finished) {
						 [UIView animateKeyframesWithDuration:.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
							 currentView.transform = CGAffineTransformRotate(currentView.transform, -angle);
						 } completion:NULL];
                     }];
}

#pragma mark - KYArcTabDelegate
- (void)tabBar:(KYArcTab *)tabBar didSelectItem:(KYArcTabItem *)item {
	
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

#pragma mark - Legacy
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
	UIView * currentView = self.selectedViewController.view;//[self.view viewWithTag:kKYNArcTabSelectedViewControllerTag];
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
//  [viewController.view setTag:kKYNArcTabSelectedViewControllerTag];
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
	
	_selectedIndex = itemIndex;
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

@end

@implementation UIViewController (KYArcTabViewController)

- (KYArcTabViewController *)arcTabViewController {
	
	for (UIViewController *viewController = self.parentViewController; viewController != nil; viewController = viewController.parentViewController) {
		if ([viewController isKindOfClass:[KYArcTabViewController class]]) {
			return (KYArcTabViewController *)viewController;
		}
	}
	
	return nil;
}

@end
