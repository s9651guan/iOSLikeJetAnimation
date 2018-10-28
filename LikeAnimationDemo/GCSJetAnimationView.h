//
//  GCSLikeAnimationView.h
//  LikeAnimationDemo
//
//  Created by 宋冠辰 on 2018/10/27.
//  Copyright © 2018年 GCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCSJetAnimationView : UIView

- (void)startJetAnimaWithBeginFrame:(CGRect)beginFrame completionHandler:(GCSBlock)completionHandler;

- (void)endJetAnimaWithCompletionHandler:(GCSBlock)completionHandler;

@end

