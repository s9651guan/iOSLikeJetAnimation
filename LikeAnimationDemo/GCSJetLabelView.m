//
//  GCSLabelView.m
//  LikeAnimationDemo
//
//  Created by 宋冠辰 on 2018/10/27.
//  Copyright © 2018年 GCS. All rights reserved.
//

#import "GCSJetLabelView.h"
#import "POP.h"

@interface GCSJetLabelView ()

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, assign) CGPoint labelPosition;
@property (nonatomic, assign) CGPoint labelAnchor;

@end

@implementation GCSJetLabelView

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.numberOfLines = 1;
    }
    return _countLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.countLabel];
}

#pragma mark - Public

- (void)updateViewWithBeginFrame:(CGRect)beginFrame count:(NSInteger)count {
    
    NSAttributedString *aString = [self attributedStringWithCount:count];
    CGSize attSize = [aString boundingRectWithSize:CGSizeMake(GCS_SCREENW, GCS_SCREENH) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.countLabel.attributedText = aString;
    self.countLabel.frame = CGRectMake(CGRectGetMidX(beginFrame) - attSize.width,
                                       CGRectGetMinY(beginFrame) - attSize.height - 30,
                                       attSize.width + 10,
                                       attSize.height);
    [self calculateAnchor];
}

#pragma mark - Private

- (void)calculateAnchor {
    CGRect frame = self.countLabel.frame;
    CGFloat x = CGRectGetMaxX(frame);
    CGFloat y = CGRectGetMaxY(frame);
    self.labelPosition = CGPointMake(x, y);
    self.labelAnchor = CGPointMake(1, 1);
}

- (void)showScaleAnimation {
    self.countLabel.layer.position = self.labelPosition;
    self.countLabel.layer.anchorPoint = self.labelAnchor;
    
    POPSpringAnimation *anima = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anima.fromValue = [NSValue valueWithCGSize:CGSizeZero];
    anima.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    anima.springBounciness = 15;
    anima.springSpeed = 30;
    anima.beginTime = 0;
    anima.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
    };
    [self.countLabel.layer pop_addAnimation:anima forKey:nil];
}

- (NSAttributedString *)attributedStringWithCount:(NSInteger)count {
    
    if (count >= 1000 || count <= 1) {
        return nil;
    }
    if (count == 2) {
        [self showScaleAnimation];
    }
    
    NSInteger x = count % 10;//个
    NSInteger y = count % 100 / 10;//十
    NSInteger z = count % 1000 / 100;//百
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]init];
    
    if (z != 0) {
        NSString *numString = [NSString stringWithFormat:@"multi_digg_num_%lu", z];
        [aString appendAttributedString:[self attributedStringWithTopPadding:3 ImageName:numString]];
    }
    if (y != 0 || z != 0) {
        NSString *numString = [NSString stringWithFormat:@"multi_digg_num_%lu", y];
        [aString appendAttributedString:[self attributedStringWithTopPadding:6 ImageName:numString]];
    }
    if (count > 0) {
        NSString *numString = [NSString stringWithFormat:@"multi_digg_num_%lu", x];
        [aString appendAttributedString:[self attributedStringWithTopPadding:9 ImageName:numString]];
    }
    
    if (count <= 20) {
        [aString appendAttributedString:[self attributedStringWithLeftPadding:-4 ImageName:@"multi_digg_word_level_1"]];
    } else if (count <= 40) {
        [aString appendAttributedString:[self attributedStringWithLeftPadding:-4 ImageName:@"multi_digg_word_level_2"]];
    } else {
        [aString appendAttributedString:[self attributedStringWithLeftPadding:-4 ImageName:@"multi_digg_word_level_3"]];
    }
    return aString;
}

- (NSAttributedString *)attributedStringWithTopPadding:(CGFloat)paddingY ImageName:(NSString *)imageName {
    return [self attributedStringWithLeftPadding:0 topPadding:paddingY ImageName:imageName];
}

- (NSAttributedString *)attributedStringWithLeftPadding:(CGFloat)paddingX ImageName:(NSString *)imageName {
    return [self attributedStringWithLeftPadding:paddingX topPadding:0 ImageName:imageName];
}

- (NSAttributedString *)attributedStringWithLeftPadding:(CGFloat)paddingX topPadding:(CGFloat)paddingY ImageName:(NSString *)imageName {
    NSTextAttachment *att = [[NSTextAttachment alloc]init];
    UIImage *numberImage = [UIImage imageNamed:imageName];
    att.image = numberImage;
    att.bounds = CGRectMake(paddingX, paddingY, numberImage.size.width, numberImage.size.height);
    NSAttributedString *aString = [NSAttributedString attributedStringWithAttachment:att];
    return aString;
}

@end
