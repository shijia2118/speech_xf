//
//  ToastView.h
//  speech_xf
//
//  Created by jia shi on 2023/5/19.
//

#ifndef ToastView_h
#define ToastView_h

#import <UIKit/UIKit.h>

@interface ToastView : UIView

+ (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration;

@end



#endif /* ToastView_h */
