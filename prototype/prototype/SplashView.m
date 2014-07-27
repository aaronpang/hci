//
//  SplashView.m
//  prototype
//
//  Created by Maxim Rabiciuc on 7/27/14.
//  Copyright (c) 2014 Maxim Rabiciuc. All rights reserved.
//

#import "SplashView.h"

@interface SplashView ()

@property (retain, nonatomic) UIImageView *background;
@property (retain, nonatomic) UIView *container;
@property (retain, nonatomic) UIButton *dismissButton;
@property (retain, nonatomic) UILabel *text;

@end

@implementation SplashView

- (instancetype)initWithImage:(UIImage *)image {
  if (self = [self init]) {
    _background = [[UIImageView alloc] initWithImage:image];
    _background.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [self addSubview:_background];

    _container = [[UIView alloc] init];
    _container.backgroundColor = [UIColor colorWithWhite:0.87 alpha:1];
    _container.layer.cornerRadius = 3.0;
    _container.layer.masksToBounds = YES;
    [self addSubview:_container];

    _text = [[UILabel alloc] init];
    _text.text = @"This application is designed to assist you with your learning of Blender. Each action you perform here will will generate dynamic tutorial in the Blender application running on your computer. Likewise any action performed in Blender will immediately be reflected here.\nGo ahead, give it a try!";
    _text.numberOfLines = 0;
    _text.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    [_container addSubview:_text];

    _dismissButton = [[UIButton alloc] init];
    _dismissButton.backgroundColor = [UIColor colorWithRed:0.15 green:0.75 blue:0.35 alpha:1];
    _dismissButton.layer.cornerRadius = 3.0;
    [_dismissButton setTitle:@"Okay lets get started!" forState:UIControlStateNormal];
    _dismissButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    [_dismissButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDown];
    [_dismissButton addTarget:self action:@selector(buttonCancelled) forControlEvents:UIControlEventTouchUpOutside];

    [_dismissButton addTarget:self action:@selector(buttonReleased) forControlEvents:UIControlEventTouchUpInside];
    [_container addSubview:_dismissButton];

  }
  return self;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  self.background.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  self.container.frame = CGRectMake(300, 200, self.frame.size.width - 600, self.frame.size.height - 475);
  self.text.frame = CGRectMake(20, 20, self.container.frame.size.width - 40, self.container.frame.size.height - 125);
  self.dismissButton.frame = CGRectMake(20, self.container.frame.size.height - 80, self.container.frame.size.width - 40, 60);
}

- (void)buttonPressed {
  _dismissButton.backgroundColor = [UIColor colorWithRed:0.15 green:0.45 blue:0.15 alpha:1];
}

- (void)buttonCancelled {
  _dismissButton.backgroundColor = [UIColor colorWithRed:0.15 green:0.75 blue:0.35 alpha:1];
}

- (void)buttonReleased {
  _dismissButton.backgroundColor = [UIColor colorWithRed:0.15 green:0.75 blue:0.35 alpha:1];


  [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.container.frame = CGRectMake(self.container.frame.origin.x, 800, self.container.frame.size.width, self.container.frame.size.height);
    self.background.alpha = 0;
  } completion:^(BOOL done) {
    self.hidden = YES;
  }];

}

@end
