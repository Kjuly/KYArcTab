//
//  Constants.h
//  KYArcTabDemo
//
//  Created by Kjuly on 1/8/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - View  - prefix: KY

// App View Basic
#define kKYViewHeight CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#define kKYViewWidth  CGRectGetWidth([UIScreen mainScreen].applicationFrame)

// Button Size
#define kKYButtonInMiniSize   16.f
#define kKYButtonInSmallSize  32.f
#define kKYButtonInNormalSize 64.f


#pragma mark - KYArcTab Configuration

#define kKYTabBarHeight     88.f
#define kKYTabBarWdith      kKYViewWidth
#define kKYTabBarItemHeight 44.f
#define kKYTabBarItemWidth  44.f

// Tab Bar
#define kKYITabBarBackground          @"KYITabBarBackground.png"
#define kKYITabBarArrow               @"KYITabBarArrow.png"
#define kKYITabBarItemImageNameFormat @"KYTabBarItem%.2d.png"
// Gesture
#define kKYIArcTabGestureHelp @"KYIArcTabGestureHelp.png"

@interface Constants : NSObject

@end
