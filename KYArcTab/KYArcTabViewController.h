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
  NSArray * tabBarItems_;
  CGRect    viewFrame_;
}

@property (nonatomic, copy)   NSArray * tabBarItems;
@property (nonatomic, assign) CGRect    viewFrame;

- (id)initWithTabBarSize:(CGSize)tabBarSize itemSize:(CGSize)itemSize;

- (void)toggleTabBar:(NSNotification *)notification;

@end
