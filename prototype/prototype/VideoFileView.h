//
//  VideoFileView.h
//  prototype
//
//  Created by Maxim Rabiciuc on 7/22/14.
//  Copyright (c) 2014 Maxim Rabiciuc. All rights reserved.
//

@class VideoFileView;

@protocol VideoFileViewDelegate <NSObject>

- (void)videoFileView:(VideoFileView *)view draggedFromPosition:(CGPoint)start toPosition:(CGPoint)end ;

@end
@interface VideoFileView : UIImageView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<VideoFileViewDelegate> delegate;

- (void)setTitle:(NSString *)title;
- (void)setEditable:(BOOL)editable;

@end
