//
//  MainViewController.m
//  prototype
//
//  Created by Maxim Rabiciuc on 7/22/14.
//  Copyright (c) 2014 Maxim Rabiciuc. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VideoFileView.h"
#import "SplashView.h"


@interface MainViewController () <UIGestureRecognizerDelegate>

@end

@implementation MainViewController {
    UIView *_leftPanelView;
    UIView *_videoPreviewView;
    UIView *_timelineView;
    UILabel *_previewLabel;
    UILabel *_videoFilesLabel;
    UILabel *_timelineLabel;
    UIButton *_playButton;
    MPMoviePlayerController *_myPlayer;
    NSMutableArray *_importClips;
    NSMutableArray *_editClips;
    UIView *_timelineLine;
    BOOL _moveTimeline;

}

-(void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    CGFloat screenHeight = screenRect.size.width;
    [self.view setBackgroundColor:[UIColor redColor]];
    
    // Add the three views
    _leftPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, screenHeight)];
    _leftPanelView.backgroundColor = [UIColor colorWithWhite:0.27 alpha:1];
    _leftPanelView.layer.borderWidth = 0.5;
    [self.view addSubview:_leftPanelView];
    
    _timelineView = [[UIView alloc] initWithFrame:CGRectMake(_leftPanelView.frame.size.width, screenHeight / 2, screenWidth - _leftPanelView.frame.size.width, screenHeight / 2)];
    _timelineView.backgroundColor = [UIColor colorWithWhite:0.36 alpha:1];
    [self.view addSubview:_timelineView];
    
    _timelineLabel = [[UILabel alloc] init];
    _timelineLabel.text = @"Timeline";
    _timelineLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:25];
    _timelineLabel.frame = (CGRect) {.origin = {10, 5}};
    _timelineLabel.textColor = [UIColor whiteColor];
    _timelineLabel.textAlignment = NSTextAlignmentLeft;
    [_timelineLabel sizeToFit];
    [_timelineView addSubview:_timelineLabel];

    
    UIView *timelineDivider = [[UIView alloc] initWithFrame:CGRectMake(0, _timelineLabel.frame.size.height + 7, _timelineView.frame.size.width, 0.5)];
    timelineDivider.backgroundColor = [UIColor blackColor];
    [_timelineView addSubview:timelineDivider];
    
    _timelineLine = [[UIView alloc] initWithFrame:CGRectMake(300, screenHeight/2 + timelineDivider.frame.origin.y + timelineDivider.frame.size.height, 1, _timelineView.frame.size.height - (timelineDivider.frame.origin.y + timelineDivider.frame.size.height))];
    _timelineLine.backgroundColor = [UIColor yellowColor];

    UIView *darkView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, screenWidth - 300, 105)];
    darkView1.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    [_timelineView addSubview:darkView1];
    UIView *darkView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 43 + 210, screenWidth - 300, 105)];
    darkView2.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    [_timelineView addSubview:darkView2];

  [self.view addSubview:_timelineLine];


    // Preview
    _videoPreviewView = [[UIView alloc] initWithFrame:CGRectMake(_leftPanelView.frame.size.width, 0, screenWidth - _leftPanelView.frame.size.width, screenHeight / 2)];
    _videoPreviewView.backgroundColor = [UIColor blackColor];

    [self.view addSubview:_videoPreviewView];
    
    
    _playButton = [[UIButton alloc] init];
    [_playButton setTitle:@"  PLAY  " forState:UIControlStateNormal];
    [_playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setBackgroundColor:[UIColor colorWithRed:0.15 green:0.75 blue:0.35 alpha:1]];
    _playButton.layer.cornerRadius = 5.0f;
    _playButton.frame = (CGRect) {.origin = {320,5}};
    [_playButton sizeToFit];
    [_timelineView addSubview:_playButton];
    
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

    _videoFilesLabel = [[UILabel alloc] init];
    _videoFilesLabel.text = @"Video Files";
    _videoFilesLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:25];
    _videoFilesLabel.frame = (CGRect) {.origin = {10, 5}};
    _videoFilesLabel.textColor = [UIColor whiteColor];
    _videoFilesLabel.textAlignment = NSTextAlignmentLeft;
    [_videoFilesLabel sizeToFit];
    [_leftPanelView addSubview:_videoFilesLabel];
    _importClips = [NSMutableArray array];
    [self.view bringSubviewToFront:_leftPanelView];
    for (int i = 0; i < 5; i++) {
        VideoFileView *videoFileView = [[VideoFileView alloc] init];
        videoFileView.frame = CGRectMake(10, 40 + 110*i, 280, 100);
        [videoFileView setTitle:[NSString stringWithFormat:@"Sample Video Clip %d", i+1]];
        videoFileView.delegate = self;
        [_importClips addObject:videoFileView];
        [self.view addSubview:videoFileView];

    }
    _editClips = [NSMutableArray array];
    
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveTimeLineLine:)];
    [longPressRecognizer setMinimumPressDuration:0.001];
    longPressRecognizer.delegate = self;
    [_timelineView addGestureRecognizer:longPressRecognizer];

    SplashView *splash = [[SplashView alloc] initWithImage:nil];
    splash.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:splash];
}

- (void)playButtonPressed:(id)sender {
    if ([_playButton.titleLabel.text isEqualToString:@"  PLAY  "]) {
        [_myPlayer prepareToPlay];
        [_myPlayer play];
        [_playButton setTitle:@"  PAUSE  " forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playButton setBackgroundColor:[UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1]];
        [_playButton sizeToFit];
        _moveTimeline = YES;
        [self performSelector:@selector(playTimeLineLine:) withObject:nil afterDelay:0.0f];
    } else {
        [_myPlayer pause];
        [_playButton setTitle:@"  PLAY  " forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_playButton setBackgroundColor:[UIColor colorWithRed:0.15 green:0.75 blue:0.35 alpha:1]];
        [_playButton sizeToFit];
        _moveTimeline = NO;
    }
}

- (void)moveTimeLineLine:(id)sender {
    if (_moveTimeline) return;
    CGPoint tapPoint = [sender locationInView:_timelineView];
    CGPoint tapPointInView;

    if ([sender isKindOfClass:[UILongPressGestureRecognizer class]]) {
        tapPointInView = [_timelineView convertPoint:tapPoint toView:self.view];
        NSLog(@"%f", tapPointInView.x);
        _timelineLine.frame = (CGRect) {.size = _timelineLine.frame.size, .origin = {MAX(300,tapPointInView.x), _timelineLine.frame.origin.y}};
    }
    [self updatePreviewVisibility];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // Disallow recognition of tap gestures in the segmented control.
    if ((touch.view == _playButton)) {//change it to your condition
        return NO;
    }
    return YES;
}

- (void)playTimeLineLine:(id)sender {
    if (_moveTimeline) {
        _timelineLine.frame = (CGRect) {.origin = {_timelineLine.frame.origin.x + 2, _timelineLine.frame.origin.y}, .size = _timelineLine.frame.size};
        if (_timelineLine.frame.origin.x > _timelineView.frame.origin.x + _timelineView.frame.size.width) {
            _timelineLine.frame = (CGRect) {.origin = {300, _timelineLine.frame.origin.y}, .size = _timelineLine.frame.size};
        }
        [self performSelector:@selector(playTimeLineLine:) withObject:nil afterDelay:0.01f];
    }
    [self updatePreviewVisibility];
}

- (void)videoFileView:(VideoFileView *)view draggedFromPosition:(CGPoint)start toPosition:(CGPoint)end {
  if (view.frame.origin.x > 300 && view.frame.origin.y > _timelineView.frame.origin.y) {
    [_importClips removeObject:view];
      for (int i = 0; i < [_importClips count]; i++) {
        VideoFileView *v = _importClips[i];
        [UIView animateWithDuration:0.5 delay:0.05*i usingSpringWithDamping:0.8 initialSpringVelocity:13 options:0 animations:^{
          v.frame = CGRectMake(10, 40 + 110*i, 280, 100);
        } completion:nil];
      }
    [view setEditable:YES];

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:13 options:0 animations:^{
      int y = (((int)(view.frame.origin.y - _timelineView.frame.origin.y))/105) * 105;
      view.frame = CGRectMake(view.frame.origin.x, _timelineView.frame.origin.y + y + 45, view.frame.size.width, view.frame.size.height);
    } completion:nil];
    [_editClips addObject:view];

  } else if (view.frame.origin.x < 230 && ![_importClips containsObject:view]) {
    view.editable = NO;

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:13 options:0 animations:^{
      view.frame = CGRectMake(10, _importClips.count * 110 + 40, 280, 100);
    } completion:nil];
    [_importClips addObject:view];
    [_editClips removeObject:view];
  } else {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:13 options:0 animations:^{
      view.frame = CGRectMake(start.x, start.y, view.frame.size.width, view.frame.size.height);
    } completion:nil];
  }
  [self updatePreviewVisibility];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)updatePreviewVisibility {
  BOOL intersects = NO;
  for (VideoFileView *view in _editClips) {
    if (_timelineLine.frame.origin.x >= view.frame.origin.x && _timelineLine.frame.origin.x <= view.frame.origin.x
        + view.frame.size.width) {
      intersects = YES;
      break;
    }
  }
  _myPlayer.view.hidden = !intersects;
  [self.view bringSubviewToFront:_timelineLine];

}

@end
