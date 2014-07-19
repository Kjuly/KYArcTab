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

@property (nonatomic, strong) KYArcTab * tabBar;
@property (nonatomic, copy)   NSArray  * tabBarItems;
@property (nonatomic, assign) CGRect     viewFrame;

/*! Designated initializer.
 *
 * \param title The title
 * \param tabBarSize Size of tab bar
 * \param tabBarBackgroundColor Background color of tab bar
 * \param itemSize Size of items on tab bar
 * \param arrow Arrow on the tab bar
 *
 * \returns An KYArcTabViewController instance
 */
- (instancetype)initWithTitle:(NSString *)title
                   tabBarSize:(CGSize)tabBarSize
        tabBarBackgroundColor:(UIColor *)tabBarBackgroundColor
                     itemSize:(CGSize)itemSize
                        arrow:(UIImage *)arrow;

/*! Setup message, override it to do customize jobs. */
- (void)setup;

/*! Toggle tab bar when receive the right notification. */
- (void)toggleTabBar:(NSNotification *)notification;

@end
