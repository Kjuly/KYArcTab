//
//  KYHorizontalSwipeGestureRecognizer.m
//  KYArcTabDemo
//
//  Created by Yamazaki Mitsuyoshi on 11/15/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "KYHorizontalSwipeGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

static CGFloat const _kKYHorizontalSwipeGestureRecognizerMinimumDistant = 50.0f;

@interface KYHorizontalSwipeGestureRecognizer () {
	CGPoint _startPoint;
}

@end

@implementation KYHorizontalSwipeGestureRecognizer

@synthesize direction = _direction;

#pragma mark - Lifecycle
- (id)initWithTarget:(id)target action:(SEL)action {
	
	self = [super initWithTarget:target action:action];
	if (self) {
		_direction = KYHorizontalSwipeGestureRecognizerDirectionNone;
		self.state = UIGestureRecognizerStatePossible;
//		self.cancelsTouchesInView = NO;
	}
	return self;
}

#pragma mark - UIGestureRecognizer
- (void)reset {
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	if (touches.count != 1) {
		self.state = UIGestureRecognizerStateFailed;
		return;
	}
	
	_startPoint = [touches.anyObject locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	if (touches.count != 1) {
		self.state = UIGestureRecognizerStateFailed;
		return;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	if (touches.count != 1) {
		self.state = UIGestureRecognizerStateFailed;
		return;
	}

	CGPoint currentPoint = [touches.anyObject locationInView:self.view];
	
	CGFloat distant = currentPoint.x - _startPoint.x;
	
	if (distant > _kKYHorizontalSwipeGestureRecognizerMinimumDistant) {
		_direction = KYHorizontalSwipeGestureRecognizerDirectionRight;
		self.state = UIGestureRecognizerStateRecognized;
	}
	else if (distant < -_kKYHorizontalSwipeGestureRecognizerMinimumDistant) {
		_direction = KYHorizontalSwipeGestureRecognizerDirectionLeft;
		self.state = UIGestureRecognizerStateRecognized;
	}
	else {
		self.state = UIGestureRecognizerStateFailed;
		return;
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	self.state = UIGestureRecognizerStateFailed;
}

@end
