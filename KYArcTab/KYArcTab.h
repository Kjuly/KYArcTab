//
//  KYArcTab.h
//  KYArcTab
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

// For debuging graphics
//#define KY_ARCTAB_DEBUG_GRAPHICS 1

// View Basic
#define kKYArcTabViewHeight CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#define kKYArcTabViewWidth  CGRectGetWidth([UIScreen mainScreen].applicationFrame)

// Notification Name
// Notification for toggling tab bar
#define kKYNArcTabToggleTabBar @"KYNArcTabToggleTabBar"

// Tag Constants
#define kKYNArcTabArrowTag                  1021
#define kKYNArcTabSelectedItemTag           1022
#define kKYNArcTabSelectedViewControllerTag 1023


@protocol KYArcTabDelegate

- (UIImage *)iconFor:(NSUInteger)itemIndex;

@optional
- (void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
         withPreviousItemIndex:(NSUInteger)previousItemIndex;

@end


@interface KYArcTab : UIView {
  NSObject <KYArcTabDelegate> * delegate_;
  NSMutableArray              * buttons_;
  NSInteger                     previousItemIndex_;
}

@property (nonatomic, assign) NSObject <KYArcTabDelegate> * delegate;
@property (nonatomic, retain) NSMutableArray              * buttons;
@property (nonatomic, assign) NSInteger                     previousItemIndex;

// Designated initializer
- (id)initWithFrame:(CGRect)frame              // frame of tab bar
         tabBarSize:(CGSize)tabBarSize         // size of tab bar
    backgroundColor:(UIColor *)backgroundColor // background color of tab bar
           itemSize:(CGSize)itemSize           // size of items on tab bar
          itemCount:(NSUInteger)itemCount      // number of items on tab bar
              arrow:(UIImage *)arrow           // arrow on the tab bar
                tag:(NSInteger)tag             // tag for the tab bar
           delegate:(NSObject <KYArcTabDelegate> *)delegate;
// Action of touch down on tab bar item
- (void)touchDownAction:(UIButton *)button;
// Action for selected item
- (void)selectItemAtIndex:(NSInteger)index;
// TODO:
//   This message is for device's rotation management
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//                                duration:(NSTimeInterval)duration;

@end
