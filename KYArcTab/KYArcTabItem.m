//
//  KYArcTabItem.m
//  KYArcTabDemo
//
//  Created by Yamazaki Mitsuyoshi on 10/28/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "KYArcTabItem.h"

@implementation KYArcTabItem

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
	
	self = [super init];
	if (self) {
		self.title = title;
		self.image = image;
		self.selectedImage = selectedImage;
	}
	return self;
}

@end

@implementation UIViewController (KYArcTabItem)

- (void)setArcTabItem:(KYArcTabItem *)item {
	self.tabBarItem = (id)item;
}

- (KYArcTabItem *)arcTabItem {

	if ([self.tabBarItem isKindOfClass:[KYArcTabItem class]] == NO) {
		return nil;
	}
	return (KYArcTabItem *)self.tabBarItem;
}

@end