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
    UILabel *_videoFilesLabel;
    UILabel *_timelineLabel;
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
    _timelineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_timelineView];
    
    _timelineLabel = [[UILabel alloc] init];
    _timelineLabel.text = @"Timeline";
    _timelineLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:25];
    _timelineLabel.frame = (CGRect) {.origin = {10, 5}};
    _timelineLabel.textColor = [UIColor whiteColor];
    _timelineLabel.textAlignment = NSTextAlignmentLeft;
    [_timelineLabel sizeToFit];
    [_timelineView addSubview:_timelineLabel];
    
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
    _myPlayer.view.frame = CGRectMake(100, 50, _videoPreviewView.frame.size.width - 200, _videoPreviewView.frame.size.height - 100);
    [_videoPreviewView addSubview:_myPlayer.view];

    VideoFileView *videoFileView = [[VideoFileView alloc] init];
    videoFileView.frame = CGRectMake(10, 10, 100, 100);
    [self.view addSubview:videoFileView];
    
    _videoFilesLabel = [[UILabel alloc] init];
    _videoFilesLabel.text = @"Video Files";
    _videoFilesLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:25];
    _videoFilesLabel.frame = (CGRect) {.origin = {10, 5}};
    _videoFilesLabel.textColor = [UIColor whiteColor];
    _videoFilesLabel.textAlignment = NSTextAlignmentLeft;
    [_videoFilesLabel sizeToFit];
    [_leftPanelView addSubview:_videoFilesLabel];
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
