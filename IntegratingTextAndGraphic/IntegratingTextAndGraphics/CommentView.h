//
//  CommentView.h
//  wecast
//
//  Created by Content on 17/2/28.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIImageView *commentIcon;
@property (nonatomic,strong) UIButton *commentNum;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,copy) void (^send_callback) (NSString *text);

@property (nonatomic,copy) void (^tap_callback) (UITextField *textField);
@property(nonatomic,copy) void(^shareBtnClickBlock)();
@end
