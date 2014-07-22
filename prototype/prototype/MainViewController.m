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
    UILabel *_previewLabel;
    MPMoviePlayerController *_myPlayer;
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
    
    
    // Preview
    _videoPreviewView = [[UIView alloc] initWithFrame:CGRectMake(_leftPanelView.frame.size.width, 0, screenWidth - _leftPanelView.frame.size.width, screenHeight / 2)];
    _videoPreviewView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_videoPreviewView];
    
    _previewLabel = [[UILabel alloc] init];
    _previewLabel.text = @"Preview";
    _previewLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:25];
    _previewLabel.frame = (CGRect) {.origin = {10, 5}};
    _previewLabel.textColor = [UIColor whiteColor];
    _previewLabel.textAlignment = NSTextAlignmentLeft;
    [_previewLabel sizeToFit];
    [_videoPreviewView addSubview:_previewLabel];
    
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
    VideoFileView *videoFileView = [[VideoFileView alloc] init];
    videoFileView.frame = CGRectMake(10, 10, 100, 100);
    [self.view addSubview:videoFileView];
}

- (void)videoFileView:(VideoFileView *)view draggedFromPosition:(CGPoint)start toPosition:(CGPoint)end {
  //do something
}

@end
