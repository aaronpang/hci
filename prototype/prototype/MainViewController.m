//
//  MainViewController.m
//  prototype
//
//  Created by Maxim Rabiciuc on 7/22/14.
//  Copyright (c) 2014 Maxim Rabiciuc. All rights reserved.
//

#import "MainViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoFileView.h"

@implementation MainViewController {
    UIView *_leftPanelView;
    UIView *_videoPreviewView;
    UIView *_timelineView;
    MPMoviePlayerController *_myPlayer;
    NSMutableArray *_importClips;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    CGFloat screenHeight = screenRect.size.width;
    [self.view setBackgroundColor:[UIColor redColor]];
    
    // Add the three views
    _leftPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, screenHeight)];
    _leftPanelView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_leftPanelView];
    
    _timelineView = [[UIView alloc] initWithFrame:CGRectMake(_leftPanelView.frame.size.width, screenHeight / 2, screenWidth - _leftPanelView.frame.size.width, screenHeight / 2)];
    _timelineView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_timelineView];
    
    _videoPreviewView = [[UIView alloc] initWithFrame:CGRectMake(_leftPanelView.frame.size.width, 0, screenWidth - _leftPanelView.frame.size.width, screenHeight / 2)];
    _videoPreviewView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_videoPreviewView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testVideo" ofType:@"mp4"];
    // Add the video player
    _myPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    _myPlayer.shouldAutoplay = NO;
    _myPlayer.repeatMode = MPMovieRepeatModeOne;
    _myPlayer.movieSourceType = MPMovieSourceTypeFile;
    _myPlayer.controlStyle = MPMovieControlStyleNone;
    _myPlayer.scalingMode = MPMovieScalingModeFill;
    [_myPlayer prepareToPlay];
    _myPlayer.view.frame = CGRectMake(100, 50, _videoPreviewView.frame.size.width - 200, _videoPreviewView.frame.size.height - 100);
    [_videoPreviewView addSubview:_myPlayer.view];
    [_myPlayer play];
    _importClips = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        VideoFileView *videoFileView = [[VideoFileView alloc] init];
        videoFileView.frame = CGRectMake(10, 40 + 110*i, 280, 100);
        [videoFileView setTitle:[NSString stringWithFormat:@"Sample Video Clip %d", i+1]];
        videoFileView.delegate = self;
        [_importClips addObject:videoFileView];
        [self.view addSubview:videoFileView];

    }
}

- (void)videoFileView:(VideoFileView *)view draggedFromPosition:(CGPoint)start toPosition:(CGPoint)end {
  if (view.frame.origin.x > 300 && view.frame.origin.y > _timelineView.frame.origin.y) {
    [_importClips removeObject:view];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:13 options:0 animations:^{
      int y = 40;
      for (VideoFileView *v in _importClips) {
        v.frame = CGRectMake(10, y, 280, 100);
        y += 110;
      }
    } completion:nil];
    [view setEditable:YES];
  } else {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:13 options:0 animations:^{
      view.frame = CGRectMake(start.x, start.y, 280, 100);
    } completion:nil];
  }
}

@end
