//
//  KYArcTabViewController.h
//  KYArcTab
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KYArcTab.h"

@protocol KYArcTabViewControllerDelegate <NSObject>
@optional
// TODO: implement it
@end

@interface KYArcTabViewController : UIViewController <KYArcTabDelegate>

@property (nonatomic, weak) id <KYArcTabViewControllerDelegate> delegate;
@property (nonatomic, readonly) KYArcTab *tabBar;
@property (nonatomic, copy)   NSArray  *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, copy) NSArray *customizableViewControllers;
@property (nonatomic, readonly) UINavigationController *moreNavigationController;

/*! A Boolean value that determines whether swiping is enabled.
 \discussion If the value of this property is YES , swiping is enabled, and if it is NO , swiping is disabled. The default is NO. 
 When swiping is enabled, UISwipeGestureRecognizer instances are added to KYArcTabViewController.view .
 */
@property (nonatomic, getter = isSwipeEnabled) BOOL swipeEnagled;

/*! Sets whether the arc tab bar is hidden.
 \param hidden Specify YES to hide the arc tab bar or NO to show it.
 \param animated Specify YES if you want to animate the change in visibility or NO if you want the arc tab bar to appear immediately.
 \discussion The default value is NO.
 */
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@interface UIViewController (KYArcTabViewController)

/*! The nearest ancestor in the view controller hierarchy that is a arc tab view controller. (read-only)
 */
- (KYArcTabViewController *)arcTabViewController;
@end