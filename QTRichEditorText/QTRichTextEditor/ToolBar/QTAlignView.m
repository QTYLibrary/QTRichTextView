//
//  QTAlignView.m
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "QTAlignView.h"
#import "UIImage+Common.h"
#import "UIColor+expanded.h"

@interface QTAlignView()

/**
 左对齐按钮
 */
@property (nonatomic, strong) UIButton *leftAlignBtn;
/**
 居中对齐按钮
 */
@property (nonatomic, strong) UIButton *centerAlignBtn;
/**
 右对齐按钮
 */
@property (nonatomic, strong) UIButton *rightAlignBtn;
/**
 是否初始化完成
 */
@property (nonatomic, assign) BOOL isInited;

@end

@implementation QTAlignView

#pragma mark - 父类方法
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createViews];
        self.isInited = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self updateViewsFrame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViewsFrame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isInited) {
        [self updateViewsFrame];
    }
}

#pragma mark - 按钮点击事件
- (void)onButtonClick:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(alignView:buttonClick:)]) {
        [self.delegate alignView:self buttonClick:sender];
    }
}

#pragma mark - 初始化视图
- (void)createViews {
    _leftAlignBtn = [self createButtonWithTag:400 andImage:[UIImage imageNamed:@"LeftAlign"]];
    _centerAlignBtn = [self createButtonWithTag:401 andImage:[UIImage imageNamed:@"CenterAlignment"]];
    _rightAlignBtn = [self createButtonWithTag:402 andImage:[UIImage imageNamed:@"RightAlign"]];
    
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 1;
    self.layer.cornerRadius = 5;
    
    [self addSubview:self.leftAlignBtn];
    [self addSubview:self.centerAlignBtn];
    [self addSubview:self.rightAlignBtn];
}

- (void)updateViewsFrame {
    self.leftAlignBtn.frame = CGRectMake(0, 0, ALIGN_ITEM_WIDTH, ALIGN_ITEM_HEIGHT);
    self.centerAlignBtn.frame = CGRectMake(ALIGN_ITEM_WIDTH, 0, ALIGN_ITEM_WIDTH, ALIGN_ITEM_HEIGHT);
    self.rightAlignBtn.frame = CGRectMake(ALIGN_ITEM_WIDTH * 2, 0, ALIGN_ITEM_WIDTH, ALIGN_ITEM_HEIGHT);
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.leftAlignBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.frame = self.leftAlignBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.leftAlignBtn.layer.mask = maskLayer1;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.rightAlignBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc]init];
    maskLayer2.frame = self.rightAlignBtn.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.rightAlignBtn.layer.mask = maskLayer2;
}

- (UIButton *)createButtonWithTag:(NSInteger)tag andImage:(UIImage *)image {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255/255.0 green:120/255.0 blue:7/255.0 alpha:1.0]] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
