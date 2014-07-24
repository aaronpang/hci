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
@property (strong, nonatomic) UILabel *lengthView;
@property (strong, nonatomic) UILabel *timestampView;
@end

@implementation VideoFileView

- (instancetype)init {
  if (self = [super init]) {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1];
    self.layer.cornerRadius = 3.0;
    self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    self.layer.borderWidth = 0.5;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;

    _titleView = [[UILabel alloc] init];
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    _titleView.frame = CGRectMake(10, 10, 270, 80);
    _titleView.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self addSubview:_titleView];

    _timestampView = [[UILabel alloc] init];
    _timestampView.frame = CGRectMake(40, 10, 200, 15);
    _timestampView.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//    _timestampView.text = @"Position: 1.15s";
    _timestampView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    _timestampView.alpha = 0;
    [self addSubview:_timestampView];

    _lengthView = [[UILabel alloc] init];
    _lengthView.frame = CGRectMake(40, 75, 200, 15);
    _lengthView.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//    _lengthView.text = @"Length: 2.0s";
    _lengthView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    _lengthView.textAlignment = NSTextAlignmentRight;
    _lengthView.alpha = 0;
    [self addSubview:_lengthView];

    _rightArrow = [[UILabel alloc] init];
    _rightArrow.frame = CGRectMake(260, 0, 20, 100);
    _rightArrow.text = @"◀︎";
    _rightArrow.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:120.0/255.0 blue:150.0/255.0 alpha:1];
    _rightArrow.userInteractionEnabled = YES;
    _rightArrow.textAlignment = NSTextAlignmentCenter;
    _rightArrow.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [self addSubview:_rightArrow];

    _leftArrow = [[UILabel alloc] init];
    _leftArrow.frame = CGRectMake(-20, 0, 20, 100);
    _leftArrow.text = @"▶︎";
    _leftArrow.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:120.0/255.0 blue:150.0/255.0 alpha:1];
    _leftArrow.userInteractionEnabled = YES;
    _leftArrow.textAlignment = NSTextAlignmentCenter;
    _leftArrow.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [self addSubview:_leftArrow];




    UIPanGestureRecognizer *rightGrow = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightGrow:)];
    rightGrow.delegate = self;
    [_rightArrow addGestureRecognizer:rightGrow];

    UIPanGestureRecognizer *leftGrow = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftGrow:)];
    leftGrow.delegate = self;
    [_leftArrow addGestureRecognizer:leftGrow];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    pan.delegate = self;
    [pan requireGestureRecognizerToFail:rightGrow];
    [pan requireGestureRecognizerToFail:leftGrow];
    [self addGestureRecognizer:pan];
    self.editable = NO;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
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

- (void)viewDidTap:(UITapGestureRecognizer *)sender {
  [self.superview bringSubviewToFront:self];
}

- (void)setTitle:(NSString *)title; {
  self.titleView.text = title;
}

- (void)rightGrow:(UIPanGestureRecognizer *)sender {
  CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:[self superview]];
  if (sender.state == UIGestureRecognizerStateBegan) {
    [self.superview bringSubviewToFront:self];
    self.firstX = self.frame.size.width;
    self.rightArrow.textColor = [UIColor whiteColor];
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    self.rightArrow.textColor = [UIColor blackColor];
  }
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.firstX + translatedPoint.x, self.frame.size.height);
}

- (void)leftGrow:(UIPanGestureRecognizer *)sender {
  CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:[self superview]];
  if (sender.state == UIGestureRecognizerStateBegan) {
    [self.superview bringSubviewToFront:self];
    self.firstX = self.frame.size.width;
    self.firstY = self.frame.origin.x;
    self.leftArrow.textColor = [UIColor whiteColor];
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    self.leftArrow.textColor = [UIColor blackColor];
  }
  self.frame = CGRectMake(self.firstY + translatedPoint.x, self.frame.origin.y, self.firstX - translatedPoint.x, self.frame.size.height);
}

- (void)setFrame:(CGRect)frame {
  CGRect actualFrame = CGRectMake(frame.origin.x, frame.origin.y, MAX(62,frame.size.width), MAX(0, frame.size.height));
  [super setFrame:actualFrame];
  self.rightArrow.frame = CGRectMake(actualFrame.size.width - (self.editable ? 30 : 0), 0, 30, actualFrame.size.height);
  self.leftArrow.frame = CGRectMake(self.editable ? 0 : -30, 0, 30, actualFrame.size.height);
  self.titleView.frame = CGRectMake(40, 10, actualFrame.size.width - 80, actualFrame.size.height - 20);
  self.lengthView.frame = CGRectMake(40, 75, actualFrame.size.width - 80, 15);
  self.timestampView.frame = CGRectMake(40, 10, actualFrame.size.width - 80, 15);
  self.lengthView.text = [NSString stringWithFormat:@"Length: %.2fs", MAX(actualFrame.size.width/140.0,0)];
  self.timestampView.text = [NSString stringWithFormat:@"Position: %.2fs", MAX(0,(actualFrame.origin.x - 300)/140.0)];

}

- (void)setEditable:(BOOL)editable {
  _editable = editable;
  if (editable) {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:13 options:0 animations:^{
      self.rightArrow.frame = CGRectMake(self.frame.size.width - 30, 0, 30, 100);
      self.leftArrow.frame = CGRectMake(0, 0, 30, 100);
      self.timestampView.alpha = 1;
      self.lengthView.alpha = 1;
      self.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:90.0/255.0 blue:120.0/255.0 alpha:1];
    } completion:nil];
  } else {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:13 options:0 animations:^{
      self.rightArrow.frame = CGRectMake(self.frame.size.width, 0, 30, 100);
      self.leftArrow.frame = CGRectMake(-30, 0, 30, 100);
      self.timestampView.alpha = 0;
      self.lengthView.alpha = 0;
      self.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1];;
    } completion:nil];
  }
}

@end
