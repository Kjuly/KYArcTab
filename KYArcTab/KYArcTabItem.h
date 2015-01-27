//
//  KYArcTabItem.h
//  KYArcTabDemo
//
//  Created by Yamazaki Mitsuyoshi on 10/28/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYArcTabItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end

@interface UIViewController (KYArcTabItem)
- (void)setArcTabItem:(KYArcTabItem *)item;
- (KYArcTabItem *)arcTabItem;
@end