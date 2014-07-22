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
@property (strong, nonatomic) UILabel *rightArrow;
@property (strong, nonatomic) UILabel *leftArrow;
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
    self.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    self.layer.borderWidth = 0.5;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;

    _titleView = [[UILabel alloc] init];
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    _titleView.frame = CGRectMake(10, 10, 270, 80);
    [self addSubview:_titleView];

    _rightArrow = [[UILabel alloc] init];
    _rightArrow.frame = CGRectMake(280, 0, 20, 100);
    _rightArrow.text = @"◀︎";
    _rightArrow.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1];
    [self addSubview:_rightArrow];


    _leftArrow = [[UILabel alloc] init];
    _leftArrow.frame = CGRectMake(-20, 0, 20, 100);
    _leftArrow.text = @"▶︎";
    _leftArrow.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1];
    _leftArrow.textAlignment = NSTextAlignmentRight;
    [self addSubview:_leftArrow];
  }
  return self;
}

- (void)viewDidPan:(UIPanGestureRecognizer *)sender {
  CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:[self superview]];
  if (sender.state == UIGestureRecognizerStateBegan) {
    [self.superview bringSubviewToFront:self];
    self.firstX = self.frame.origin.x;
    self.firstY = self.frame.origin.y;
  }
  self.frame = CGRectMake(self.firstX + translatedPoint.x, self.firstY + translatedPoint.y, self.frame.size.width, self.frame.size.height);
  if (sender.state == UIGestureRecognizerStateEnded) {
    [self.delegate videoFileView:self draggedFromPosition:CGPointMake(self.firstX, self.firstY) toPosition:self.frame.origin];
  }
}
- (void)setTitle:(NSString *)title; {
  self.titleView.text = title;
}

- (void)setEditable:(BOOL)editable {
  if (editable) {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:13 options:0 animations:^{
      self.rightArrow.frame = CGRectMake(self.frame.size.width - 20, 0, 20, 100);
      self.leftArrow.frame = CGRectMake(0, 0, 20, 100);
    } completion:nil];
  } else {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:13 options:0 animations:^{
      self.rightArrow.frame = CGRectMake(self.frame.size.width, 0, 20, 100);
      self.leftArrow.frame = CGRectMake(-20, 0, 20, 100);

    } completion:nil];
  }
}

@end
