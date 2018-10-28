//
//  GCSFeedBackManager.m
//  LikeAnimationDemo
//
//  Created by 宋冠辰 on 2018/10/27.
//  Copyright © 2018年 GCS. All rights reserved.
//

#import "GCSFeedBackManager.h"

@interface GCSFeedBackManager ()

@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedBack;

@end

@implementation GCSFeedBackManager

- (UIImpactFeedbackGenerator *)impactFeedBack {
    if (!_impactFeedBack) {
        _impactFeedBack = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [_impactFeedBack prepare];
    }
    return _impactFeedBack;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)triggerImpactFeedBack {
    @autoreleasepool {
        if (@available(iOS 10.0, *)){
            [self.impactFeedBack impactOccurred];
        }
    }
}

@end
