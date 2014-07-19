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
// If not defined custom value for |kKYArcTabViewHeight| or |kKYArcTabViewWidth|,
//   use default application frame's bounding value.
#ifndef kKYArcTabViewHeight
  #define kKYArcTabViewHeight CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#endif
#ifndef kKYArcTabViewWidth
  #define kKYArcTabViewWidth CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#endif

// Notification Name
// Notification for toggling tab bar
#define kKYNArcTabToggleTabBar @"KYNArcTabToggleTabBar"

// Tag Constants
#define kKYNArcTabArrowTag                  1021
#define kKYNArcTabSelectedItemTag           1022
#define kKYNArcTabSelectedViewControllerTag 1023


@protocol KYArcTabDelegate;


@interface KYArcTab : UIView {
  id <KYArcTabDelegate> __weak delegate_;
  NSMutableArray             * buttons_;
  NSInteger                    previousItemIndex_;
}

@property (nonatomic, strong) NSMutableArray    * buttons;
@property (nonatomic, assign) NSInteger           previousItemIndex;
@property (nonatomic, weak) id <KYArcTabDelegate> delegate;

/*! Designated initializer for KYArcTab.
 *
 * \param frame Frame of tab bar
 * \param tabBarSize Size of tab bar
 * \param backgroundColor Background color of tab bar
 * \param itemSize Size of items on tab bar
 * \param itemCount Number of items on tab bar
 * \param arrow The circle arrow on the tab bar
 * \param tag The tag for the tab bar
 * \param delegate The delegate
 *
 * \returns An KYArcTab instance
 */
- (instancetype)initWithFrame:(CGRect)frame
                   tabBarSize:(CGSize)tabBarSize
              backgroundColor:(UIColor *)backgroundColor
                     itemSize:(CGSize)itemSize
                    itemCount:(NSUInteger)itemCount
                        arrow:(UIImage *)arrow
                          tag:(NSInteger)tag
                     delegate:(id <KYArcTabDelegate>)delegate;

/*! Action of touch down on tab bar item. */
- (void)touchDownAction:(UIButton *)button;
/*! Action for selected item. */
- (void)selectItemAtIndex:(NSInteger)index;
// TODO:
//   This message is for device's rotation management
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//                                duration:(NSTimeInterval)duration;

@end


@protocol KYArcTabDelegate <NSObject>

- (UIImage *)iconFor:(NSUInteger)itemIndex;

@optional
- (void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
         withPreviousItemIndex:(NSUInteger)previousItemIndex;

@end
