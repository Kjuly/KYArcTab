//
//  KYHorizontalSwipeGestureRecognizer.h
//  KYArcTabDemo
//
//  Created by Yamazaki Mitsuyoshi on 11/15/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	KYHorizontalSwipeGestureRecognizerDirectionNone,
	KYHorizontalSwipeGestureRecognizerDirectionLeft,
	KYHorizontalSwipeGestureRecognizerDirectionRight,
}KYHorizontalSwipeGestureRecognizerDirection;

@interface KYHorizontalSwipeGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) KYHorizontalSwipeGestureRecognizerDirection direction;

@end
