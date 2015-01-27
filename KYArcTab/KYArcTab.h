//
//  KYArcTab.h
//  KYArcTab
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KYArcTabItem.h"

@class KYArcTab;

@protocol KYArcTabDelegate <NSObject>
@required
- (void)tabBar:(KYArcTab *)tabBar didSelectItem:(KYArcTabItem *)item;

@optional
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
         withPreviousItemIndex:(NSUInteger)previousItemIndex;
- (void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
@end

@interface KYArcTab : UIView

@property (nonatomic, weak) id <KYArcTabDelegate> delegate;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, weak) KYArcTabItem *selectedItem;
@property (nonatomic) NSInteger selectedIndex;


@property (nonatomic, assign) NSInteger                   previousItemIndex;

- (void)setItems:(NSArray *)items animated:(BOOL)animated;

@end

@interface KYArcTabArrowView : UIView

@end
