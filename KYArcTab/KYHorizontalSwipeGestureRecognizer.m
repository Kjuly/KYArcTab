//
//  KYHorizontalSwipeGestureRecognizer.m
//  KYArcTabDemo
//
//  Created by Yamazaki Mitsuyoshi on 11/15/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import "KYHorizontalSwipeGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface KYHorizontalSwipeGestureRecognizer () {
	CGPoint _startPoint;
	NSDate *_startTime;
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
	[super reset];
	
	self.state = UIGestureRecognizerStatePossible;
	_startPoint = CGPointZero;
	_startTime = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	if (touches.count != 1) {
		self.state = UIGestureRecognizerStateFailed;
		return;
	}
	
	_startPoint = [touches.anyObject locationInView:self.view];
	_startTime = [NSDate date];	
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

	NSTimeInterval maximumDuration = 1.0f;
	
	if ([[NSDate date] timeIntervalSinceDate:_startTime] > maximumDuration) {
		self.state = UIGestureRecognizerStateFailed;
		return;
	}
	
	CGPoint currentPoint = [touches.anyObject locationInView:self.view];
	
	CGFloat distantX = currentPoint.x - _startPoint.x;
	CGFloat distantY = currentPoint.y - _startPoint.y;
	CGFloat maximumTilt = 1.6f;
	
	if (fabs(distantX) / fabs(distantY) < maximumTilt) {
		self.state = UIGestureRecognizerStateFailed;
		return;
	}
	
	CGFloat minimumDistant = 50.0f;
	
	if (distantX > minimumDistant) {
		_direction = KYHorizontalSwipeGestureRecognizerDirectionRight;
	}
	else if (distantX < -minimumDistant) {
		_direction = KYHorizontalSwipeGestureRecognizerDirectionLeft;
	}
	else {
		self.state = UIGestureRecognizerStateFailed;
		return;
	}
	
	self.state = UIGestureRecognizerStateRecognized;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	self.state = UIGestureRecognizerStateCancelled;
}

@end
