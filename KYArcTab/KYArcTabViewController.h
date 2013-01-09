//
//  KYArcTabViewController.h
//  KYArcTab
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KYArcTab.h"

@interface KYArcTabViewController : UIViewController <KYArcTabDelegate> {
  KYArcTab * tabBar_;
  NSArray  * tabBarItems_;
  CGRect     viewFrame_;
}

@property (nonatomic, retain) KYArcTab * tabBar;
@property (nonatomic, copy)   NSArray  * tabBarItems;
@property (nonatomic, assign) CGRect     viewFrame;

// Designated initializer
- (id)  initWithTitle:(NSString *)title                // title
           tabBarSize:(CGSize)tabBarSize               // size of tab bar
tabBarBackgroundColor:(UIColor *)tabBarBackgroundColor // background color of tab bar
             itemSize:(CGSize)itemSize                 // size of items on tab bar
                arrow:(UIImage *)arrow;                // arrow on the tab bar
// Setup message, override it to do customize jobs
- (void)setup;
// Toggle tab bar when receive the right notification
- (void)toggleTabBar:(NSNotification *)notification;

@end
