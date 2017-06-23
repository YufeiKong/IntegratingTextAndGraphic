//
//  DisplayView.m
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/16.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import "DisplayView.h"
#import <CoreText/CoreText.h>
#import "CoreTextDataModel.h"
#import "WebViewController.h"
#import "EnlargeImage.h"

@interface DisplayView()
@end

@implementation DisplayView

- (void)setData:(CoreTextData *)data {
    if (_data != data) {
        _data = data;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.data.height);
    //下载网络图片
    for (CoreTextDataModel * imageData in self.data.imageArray) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageData.name] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [self setNeedsDisplay];
        }];
    }
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //绘制上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //翻转坐标
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    if (self.data) {
        
    CTFrameDraw(self.data.ctFrame, context);
    for (CoreTextDataModel *imageData in self.data.imageArray) {
        
    // 判断当前CTRun是否应该显示图片  把需要被图片替换的字符位置画上图片
    UIImage *scaleImage;
        //网络图片从下载缓存加载
    if ([imageData.name rangeOfString:@"http"].location != NSNotFound) {
        
    @autoreleasepool {
        
    UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:imageData.name];
    scaleImage = [UIImage imageNamed:@"news_lg_loading_"];
        
    if (image) {
        
    scaleImage = [self image:image scaleWithSize:imageData.imagePosition.size];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    }
  }
    }else{//本地图片
    scaleImage = [UIImage imageNamed:imageData.name];
    }
    if (scaleImage) {
    CGContextDrawImage(context, imageData.imagePosition, scaleImage.CGImage);
   }
  }
 }
}
- (UIImage *)image:(UIImage *)image scaleWithSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClickedEvent:)];
    [self addGestureRecognizer:tap];
        
//        self.userInteractionEnabled = YES;
//        UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [self addGestureRecognizer:touch];
//
        
    }
    return self;
}

//-(BOOL)canBecomeFirstResponder {
//    
//    return YES;
//}
//
//// 可以响应的方法
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    
//    return (action == @selector(copy:));
//}
//
////针对于响应方法的实现
//-(void)copy:(id)sender {
//    
//    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//    
//    pboard.string  = [self.data.content string];
//    
//}
//-(void)handleTap:(UIGestureRecognizer*) recognizer {
//    
//    [self becomeFirstResponder];
//    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"
//                                                      action:@selector(copy:)];
//    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
//    [[UIMenuController sharedMenuController] setTargetRect:self.bounds inView:self.superview];
//    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: NO];
//    
//    
//}
- (void)tapGestureClickedEvent:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    
    //图片
    for (CoreTextDataModel *data in self.data.imageArray) {
        //翻转坐标系imageArray中所存坐标的坐标系为CoreText坐标系
        CGRect imageRect = data.imagePosition;
        CGPoint imagePositon = imageRect.origin;
        imagePositon.y = self.bounds.size.height - imageRect.size.height - imageRect.origin.y;
        imageRect = CGRectMake(imagePositon.x, imagePositon.y, imageRect.size.width, imageRect.size.height);
        //判断点击点是否在Rect当中
        if (CGRectContainsPoint(imageRect, point)) {

        UIImage *image;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:imageRect];
        //网络加载图片
        if ([data.name rangeOfString:@"http"].location != NSNotFound) {
            
        image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:data.name];

        }else{//本地图片
            
        image = [UIImage imageNamed:data.name];
            
        }
        imgView.image = image;
        [self addSubview:imgView];
    
        if (image) {
            
        [EnlargeImage showImage:imgView];//调用图片放大方法
            
        }
        return;
    }
}
    //地址链接
    CoreTextDataModel *linkData = [CoreTextDataModel touchLinkInView:self atPoint:point data:self.data];
    if (linkData != nil) {
        
    WebViewController *web = [[WebViewController alloc]init];
    web.url = linkData.urlString;
    web.urlTitle = linkData.title;
    [[self viewController].navigationController pushViewController:web animated:NO];
    return;
    }
}
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
