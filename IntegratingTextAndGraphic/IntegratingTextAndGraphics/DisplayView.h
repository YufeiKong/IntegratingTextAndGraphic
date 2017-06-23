//
//  DisplayView.h
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/16.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"

@interface DisplayView : UIView

@property (nonatomic, strong) CoreTextData *data;
- (UIViewController*)viewController;
@end
