//
//  LoadingView.m
//  VideoPlayer
//
//  Created by 陈阳阳 on 16/6/13.
//  Copyright © 2016年 yangkun. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()
{
    UIImageView *_imageCircleView;
}
@end

@implementation LoadingView

- (void)show
{
    [self startAnimation];
}

- (void)hide
{
    [self stopAnimation];
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    _imageCircleView = [[UIImageView alloc]initWithFrame:CGRectMake((self.mj_w - AutoSize(78)) *0.5, AutoSize(32), AutoSize(78), AutoSize(78))];
    _imageCircleView.image = [UIImage imageNamed:@"loading_logo_rotate_"];
    _imageCircleView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageCircleView];
    UIImageView *imageLogoView = [[UIImageView alloc]initWithFrame:_imageCircleView.frame];
    imageLogoView.image = [UIImage imageNamed:@"loading_logo_"];
    imageLogoView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageLogoView];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (_imageCircleView.mj_maxY + AutoSize(12)), self.mj_w, self.mj_h - _imageCircleView.mj_maxY - AutoSize(12))];
    textLabel.text = @"加载中";
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
}

- (void)startAnimation {
    
    [self setNeedsDisplay];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:-M_PI * 2.0f];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 500;
    [_imageCircleView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0f];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 500;
    
    [_imageCircleView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation {
    
    [_imageCircleView.layer removeAnimationForKey:@"rotationAnimation"];
    [_imageCircleView.layer removeAnimationForKey:@"rotationAnimation"];
}
-(void)setFrame:(CGRect)frame
{
    frame = CGRectMake((kScreenWidth - AutoSize(162))*0.5, (kScreenHeight - AutoSize(162))*0.5, AutoSize(162), AutoSize(162));
    [super setFrame:frame];
}
-(void)setBounds:(CGRect)bounds
{
    bounds.size = CGSizeMake(AutoSize(162), AutoSize(162));
    [super setBounds:bounds];
}
@end
