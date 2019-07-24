//
//  QTFontStyleView.m
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "QTFontStyleView.h"
#import "UIImage+Common.h"
#import "UIColor+expanded.h"

@interface QTFontStyleView()

/**
 粗体按钮
 */
@property (nonatomic, strong) UIButton *boldBtn;
/**
 斜体按钮
 */
@property (nonatomic, strong) UIButton *italicBtn;
/**
 下划线按钮
 */
@property (nonatomic, strong) UIButton *underLineBtn;
/**
 是否初始化完成
 */
@property (nonatomic, assign) BOOL isInited;

@end

@implementation QTFontStyleView

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
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontStyleView:buttonClick:)]) {
        [self.delegate fontStyleView:self buttonClick:sender];
    }
}

#pragma mark - 初始化视图
- (void)createViews {
    _boldBtn = [self createButtonWithTag:200 andImage:[UIImage imageNamed:@"Blod"]];
    _italicBtn = [self createButtonWithTag:201 andImage:[UIImage imageNamed:@"Italic"]];;
    _underLineBtn = [self createButtonWithTag:202 andImage:[UIImage imageNamed:@"UnderLine"]];
    
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 1;
    self.layer.cornerRadius = 5;
    
    [self addSubview:self.boldBtn];
    [self addSubview:self.italicBtn];
    [self addSubview:self.underLineBtn];
}

- (void)updateViewsFrame {
    self.boldBtn.frame = CGRectMake(0, 0, FONT_STYLE_ITEM_WIDTH, FONT_STYLE_ITEM_HEIGHT);
    self.italicBtn.frame = CGRectMake(FONT_STYLE_ITEM_WIDTH, 0, FONT_STYLE_ITEM_WIDTH, FONT_STYLE_ITEM_HEIGHT);
    self.underLineBtn.frame = CGRectMake(FONT_STYLE_ITEM_WIDTH * 2, 0, FONT_STYLE_ITEM_WIDTH, FONT_STYLE_ITEM_HEIGHT);
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.boldBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.frame = self.boldBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.boldBtn.layer.mask = maskLayer1;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.underLineBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc]init];
    maskLayer2.frame = self.underLineBtn.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.underLineBtn.layer.mask = maskLayer2;
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
