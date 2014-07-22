//
//  VideoFileView.m
//  prototype
//
//  Created by Maxim Rabiciuc on 7/22/14.
//  Copyright (c) 2014 Maxim Rabiciuc. All rights reserved.
//

#import "VideoFileView.h"

@interface VideoFileView ()
@property (assign, nonatomic) CGFloat firstX;
@property (assign, nonatomic) CGFloat firstY;
@property (strong, nonatomic) UILabel *titleView;
@end

@implementation VideoFileView

- (instancetype)init {
  if (self = [super init]) {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    self.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1];
    self.layer.cornerRadius = 3.0;
  }
  return self;
}

- (void)viewDidPan:(UIPanGestureRecognizer *)sender {
  CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:[self superview]];
  if (sender.state == UIGestureRecognizerStateBegan) {
    self.firstX = self.frame.origin.x;
    self.firstY = self.frame.origin.y;
  }
  self.frame = CGRectMake(self.firstX + translatedPoint.x, self.firstY + translatedPoint.y, self.frame.size.width, self.frame.size.height);
  if (sender.state == UIGestureRecognizerStateEnded) {
    [self.delegate videoFileView:self draggedFromPosition:CGPointMake(self.firstX, self.firstY) toPosition:self.frame.origin];
  }
}

@end
