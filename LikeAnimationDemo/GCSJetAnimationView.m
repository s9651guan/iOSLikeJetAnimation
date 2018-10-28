//
//  GCSLikeAnimationView.m
//  LikeAnimationDemo
//
//  Created by 宋冠辰 on 2018/10/27.
//  Copyright © 2018年 GCS. All rights reserved.
//

#import "GCSJetAnimationView.h"

@interface GCSJetAnimationView ()

@property (nonatomic, strong) CAEmitterLayer *emitterLayer;

@property (nonatomic, copy) NSArray *nameList;//CAEmitterCell.name数组

@property (nonatomic, copy) GCSBlock startBlock;
@property (nonatomic, copy) GCSBlock endBlock;

@end

@implementation GCSJetAnimationView

- (CAEmitterLayer *)emitterLayer {
    if (!_emitterLayer) {
        _emitterLayer = [CAEmitterLayer layer];
        //给定范围
        _emitterLayer.frame = self.bounds;
        //发射模式
        _emitterLayer.emitterMode = kCAEmitterLayerPoints;//sgctodo:有啥用
        //发射尺寸
        _emitterLayer.emitterSize = CGSizeMake(30, 30);//sgctodo:有啥用
        //发射形状
        _emitterLayer.emitterShape = kCAEmitterLayerCircle;//sgctodo:有啥用
    }
    return _emitterLayer;
}

- (CAEmitterCell *)createEmitterCellWithImage:(UIImage *)image name:(NSString *)name {
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.name = name;
    //粒子产生率(/秒）
    cell.birthRate = 1.f;
    //粒子生命周期
    cell.lifetime = 2.f;
    //粒子生命周期改变范围
    cell.lifetimeRange = 2.f;
    //发射角度
    cell.emissionLongitude = 3*M_PI/2;
    //发射角度范围
    cell.emissionRange = M_PI;
    //粒子发射速度
    cell.velocity = 400.f;
    //粒子速度改变范围
    cell.velocityRange = 5.f;
    //y轴加速度
    cell.yAcceleration = 300.f;
    //粒子缩放比例
    cell.scale = 0.3;
    //粒子旋转速度
    cell.spin = M_PI * 2;
    //粒子旋转速度改变范围
    cell.spinRange = M_PI * 2;
    //粒子透明度范围
    cell.alphaRange = 1;
    //粒子透明度变化速度
    cell.alphaSpeed = -1.0;
    //粒子图片
    cell.contents = (__bridge id _Nullable)(image.CGImage);
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.layer addSublayer:self.emitterLayer];
}

- (void)startJetAnimaWithBeginFrame:(CGRect)beginFrame completionHandler:(GCSBlock)completionHandler {
    //发射点
    self.emitterLayer.emitterPosition = beginFrame.origin;

    [self startJetAnima];

    //完成回调
    if (completionHandler) {
        completionHandler();
    }
}

- (void)endJetAnimaWithCompletionHandler:(GCSBlock)completionHandler {
    
    [self changeEmitterCellBirthRate:0];

    //生命周期后执行回调
    self.endBlock = completionHandler;
    [self performSelector:@selector(endCallBack) withObject:nil afterDelay:1.5];
}

- (void)endCallBack {
    self.nameList = nil;
    //完成回调
    if (self.endBlock) {
        self.endBlock();
    }
}

- (void)startJetAnima {
    if (self.nameList) {
        return;
    }
    
    [self setupEmitterCells];
    [self changeEmitterCellBirthRate:5];
}

- (void)setupEmitterCells {
    //创建CAEmitterCell
    NSMutableArray *cellList = [NSMutableArray array];
    NSMutableArray *nameList = [NSMutableArray array];
    
    while (nameList.count < 10) {
        NSInteger num = arc4random() % 100;//随机取0-99
        NSString *imageName = [NSString stringWithFormat:@"emoji_%ld", (long)num];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image && ![nameList containsObject:imageName]) {
            CAEmitterCell *cell = [self createEmitterCellWithImage:image name:imageName];
            [cellList addObject:cell];
            [nameList addObject:imageName];
        }
    }
    
    //关联CAEmitterLayer与CAEmitterCell
    self.emitterLayer.emitterCells = cellList;
    self.nameList = nameList;
}

- (void)changeEmitterCellBirthRate:(NSInteger)birthRate {
    //修改粒子生成速度
    for (NSString *name in self.nameList) {
        NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.birthRate", name];
        [self.emitterLayer setValue:@(birthRate) forKeyPath:keyPath];
    }
}

@end
