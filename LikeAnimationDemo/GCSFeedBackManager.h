//
//  GCSFeedBackManager.h
//  LikeAnimationDemo
//
//  Created by 宋冠辰 on 2018/10/27.
//  Copyright © 2018年 GCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImpactFeedbackGenerator.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCSFeedBackManager : NSObject

+ (instancetype)sharedInstance;

- (void)triggerImpactFeedBack;

@end

NS_ASSUME_NONNULL_END
