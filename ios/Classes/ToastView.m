//
//  ToastView.m
//  speech_xf
//
//  Created by jia shi on 2023/5/19.
//

#import <Foundation/Foundation.h>

#import "ToastView.h"

@implementation ToastView

+ (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGFloat screenWidth = CGRectGetWidth(window.bounds);
    CGFloat screenHeight = CGRectGetHeight(window.bounds);
    
    // Toast View 的宽度和高度
    CGFloat toastWidth = 200.0;
    CGFloat toastHeight = 40.0;
    
    // Toast View 的位置
    CGFloat toastX = (screenWidth - toastWidth) / 2;
    CGFloat toastY = (screenHeight - toastHeight) / 2;
    
    // 创建 Toast View
    UIView *toastView = [[UIView alloc] initWithFrame:CGRectMake(toastX, toastY, toastWidth, toastHeight)];
    toastView.backgroundColor = [UIColor blackColor];
    toastView.alpha = 0.8;
    toastView.layer.cornerRadius = 5.0;
    
    // 创建 Toast Label
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:toastView.bounds];
    toastLabel.text = message;
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    [toastView addSubview:toastLabel];
    
    // 添加 Toast View 到窗口
    [window addSubview:toastView];
    
    // 动画显示 Toast View
    [UIView animateWithDuration:0.3 animations:^{
        toastView.alpha = 1.0;
    } completion:^(BOOL finished) {
        // 延迟一定时间后隐藏 Toast View
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                toastView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [toastView removeFromSuperview];
            }];
        });
    }];
}

@end

