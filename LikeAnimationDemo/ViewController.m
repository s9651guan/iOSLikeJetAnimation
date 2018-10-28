//
//  ViewController.m
//  LikeAnimationDemo
//
//  Created by 宋冠辰 on 2018/10/27.
//  Copyright © 2018年 GCS. All rights reserved.
//

#import "ViewController.h"
#import "GCSJetWindow.h"

@interface ViewController ()

@property (nonatomic, strong) GCSJetWindow *window;
@property (nonatomic, strong) UIWindow *awindow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *likeImage = [UIImage imageNamed:@"comment_like_icon"];
    UIImageView *likeView = [[UIImageView alloc]initWithImage:likeImage];
    likeView.frame = CGRectMake(200, 400, likeImage.size.width, likeImage.size.height);
    [self.view addSubview:likeView];
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        self.window = [GCSJetWindow showJetAnimationWithBeginFrame:likeView.frame];
    }];
    
}

@end
