//
//  EnlargeImage.m
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/16.
//  Copyright © 2017年 flymanshow. All rights reserved.
//


#import "EnlargeImage.h"

static CGRect oldframe;

@implementation EnlargeImage


+(void)showImage:(UIImageView *)imgView{

    UIImage *image=imgView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;

    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    oldframe=[imgView convertRect:imgView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        
    imageView.frame=CGRectMake(0,(kScreenHeight-image.size.height*kScreenWidth/image.size.width)/2, kScreenWidth, image.size.height*kScreenWidth/image.size.width);
    backgroundView.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];

}
+(void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=oldframe;
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        [imageView removeFromSuperview];
    }];
}
@end
