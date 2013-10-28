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

@end

@interface KYArcTabViewController : UIViewController <KYArcTabDelegate>

@property (nonatomic, weak) id <KYArcTabViewControllerDelegate> delegate;
@property (nonatomic, readonly) KYArcTab *tabBar;
@property (nonatomic, copy)   NSArray  *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, copy) NSArray *customizableViewControllers;
@property (nonatomic, readonly) UINavigationController *moreNavigationController;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
