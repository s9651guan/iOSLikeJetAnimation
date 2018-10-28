//
//  GCSJetView.m
//  LikeAnimationDemo
//
//  Created by 宋冠辰 on 2018/10/27.
//  Copyright © 2018年 GCS. All rights reserved.
//

#import "GCSJetWindow.h"
#import "GCSJetAnimationView.h"
#import "GCSJetLabelView.h"
#import "GCSFeedBackManager.h"


@interface GCSJetWindow ()

@property (nonatomic, assign) CGRect beginFrame;//发射坐标

@property (nonatomic, strong) GCSJetAnimationView *animaView;//喷射动画
@property (nonatomic, strong) GCSJetLabelView *countLabel;//计数标签

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL isSelected;

@end

@implementation GCSJetWindow

+ (GCSJetWindow *)showJetAnimationWithBeginFrame:(CGRect)beginFrame {
    GCSJetWindow *window = [[GCSJetWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.beginFrame = beginFrame;
    return window;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UILongPressGestureRecognizer *pan = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(press:)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        
        [self addGestureRecognizer:pan];
        [self addGestureRecognizer:tap];
        
        [self setupViews];
        
        self.alpha = 1.f;
        self.windowLevel = UIWindowLevelStatusBar + 100;
        [self.window makeKeyAndVisible];
        self.hidden = NO;
    }
    return self;
}

- (void)setupViews {
    self.animaView = [[GCSJetAnimationView alloc]initWithFrame:self.bounds];
    [self addSubview:self.animaView];
    
    self.countLabel = [[GCSJetLabelView alloc]initWithFrame:self.bounds];
    [self addSubview:self.countLabel];
    
    self.count = 0;
}

- (void)press:(UIGestureRecognizer *)gesture {
    UIGestureRecognizerState state = gesture.state;
    if (state == UIGestureRecognizerStateBegan) {
        self.isSelected = YES;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate date] interval:0.3 target:self selector:@selector(countDidChanged) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        NSLog(@"长按开始，创建计时器");
    } else if (state == UIGestureRecognizerStateEnded) {
        NSLog(@"长按结束");
        self.isSelected = NO;
        [self dismiss];
        
    }
}

- (void)tap:(UIGestureRecognizer *)gesture {
//    [self show];
}

- (void)countDidChanged {
    if ([self checkShouldDismissWindow]) {
        return;
    }
    NSLog(@"计时器 + 1 count == %lu", _count);
    self.count += 1;
    [self.countLabel setHidden:NO];
    [self.countLabel updateViewWithBeginFrame:self.beginFrame count:self.count];
    
    [self.animaView startJetAnimaWithBeginFrame:self.beginFrame completionHandler:nil];
    
    [[GCSFeedBackManager sharedInstance]triggerImpactFeedBack];
}

- (BOOL)checkShouldDismissWindow {
    if (!self.isSelected) {
        return YES;
    }
    return NO;
}

- (void)show {
    //缩放动画
    [self countDidChanged];
}

- (void)dismiss {
    //缩放动画
    
    GCS_WS(ws);
    NSLog(@"dismiss,停止喷射");
    [self.animaView endJetAnimaWithCompletionHandler:^{
        if (ws.isSelected) {
            return ;
        }
        
        [ws.countLabel setHidden:YES];
        if (ws.timer) {
            [ws.timer invalidate];
            ws.timer = nil;
        }
    }];
    
}

@end
