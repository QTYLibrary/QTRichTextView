//
//  QTFontSizeView.m
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "QTFontSizeView.h"
#import "UIImage+Common.h"
#import "UIColor+expanded.h"

@interface QTFontSizeView()

/**
 小号字体按钮
 */
@property (nonatomic, strong) UIButton *smallSizeBtn;
/**
 普通字体按钮
 */
@property (nonatomic, strong) UIButton *normalSizeBtn;
/**
 大号字体按钮
 */
@property (nonatomic, strong) UIButton *bigSizeBtn;
/**
 是否初始化完成
 */
@property (nonatomic, assign) BOOL isInited;

/**
 是否是小号字体
 */
@property (nonatomic, assign) BOOL isSmallSize;
/**
 是否是正常字体
 */
@property (nonatomic, assign) BOOL isNormalSize;
/**
 是否是大号字体
 */
@property (nonatomic, assign) BOOL isBigSize;

@end

@implementation QTFontSizeView

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

#pragma mark - 类方法
- (void)updateItemsStatu:(NSString *)statu {
    if (!statu) {
        return;
    }
    NSArray *status = [statu componentsSeparatedByString:@","];
    self.isSmallSize = [status containsObject:@"fontSize:2"];
    self.isBigSize = [status containsObject:@"fontSize:4"];
    self.isNormalSize = [status containsObject:@"fontSize:3"] || (!self.isSmallSize && !self.isBigSize);
    
    [self updateAllItemStatu];
}

#pragma mark - 其他方法
- (void)updateAllItemStatu {
    [self updateSmallSizeStatu];
    [self updateNormalSizeStatu];
    [self updateBigSizeStatu];
}

- (void)updateSmallSizeStatu {
    self.smallSizeBtn.selected = self.isSmallSize;
    if (self.isSmallSize) {
        [self.smallSizeBtn setImage:[UIImage imageNamed:@"SmallFontSize"] forState:UIControlStateSelected];
        [self.smallSizeBtn setTintColor:[UIColor whiteColor]];
    } else {
        [self.smallSizeBtn setImage:[[UIImage imageNamed:@"SmallFontSize"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [self.smallSizeBtn setTintColor:[UIColor clearColor]];
    }
}

- (void)updateNormalSizeStatu {
    self.normalSizeBtn.selected = self.isNormalSize;
    if (self.isNormalSize) {
        [self.normalSizeBtn setImage:[UIImage imageNamed:@"MediumFontSize"] forState:UIControlStateSelected];
        [self.normalSizeBtn setTintColor:[UIColor whiteColor]];
    } else {
        [self.normalSizeBtn setImage:[[UIImage imageNamed:@"MediumFontSize"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [self.normalSizeBtn setTintColor:[UIColor clearColor]];
    }
}

- (void)updateBigSizeStatu {
    self.bigSizeBtn.selected = self.isBigSize;
    if (self.isBigSize) {
        [self.bigSizeBtn setImage:[UIImage imageNamed:@"BigFontSize"] forState:UIControlStateSelected];
        [self.bigSizeBtn setTintColor:[UIColor whiteColor]];
    } else {
        [self.bigSizeBtn setImage:[[UIImage imageNamed:@"BigFontSize"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [self.bigSizeBtn setTintColor:[UIColor clearColor]];
    }
}

- (void)resetOtherStatu:(UIButton *)sender {
    if (sender != self.smallSizeBtn) {
        self.smallSizeBtn.selected = NO;
    }
    if (sender != self.normalSizeBtn) {
        self.normalSizeBtn.selected = NO;
    }
    if (sender != self.bigSizeBtn) {
        self.bigSizeBtn.selected = NO;
    }
}

#pragma mark - 按钮点击事件
- (void)onButtonClick:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    [self resetOtherStatu:sender];
    [sender setSelected:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontSizeView:buttonClick:)]) {
        [self.delegate fontSizeView:self buttonClick:sender];
    }
}

#pragma mark - 初始化视图
- (void)createViews {
    _smallSizeBtn = [self createButtonWithTag:300 andImage:[UIImage imageNamed:@"SmallFontSize"]];
    _normalSizeBtn = [self createButtonWithTag:301 andImage:[UIImage imageNamed:@"MediumFontSize"]];
    _bigSizeBtn = [self createButtonWithTag:302 andImage:[UIImage imageNamed:@"BigFontSize"]];
    
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 1;
    self.layer.cornerRadius = 5;
    
    [self addSubview:self.smallSizeBtn];
    [self addSubview:self.normalSizeBtn];
    [self addSubview:self.bigSizeBtn];
}

- (void)updateViewsFrame {
    self.smallSizeBtn.frame = CGRectMake(0, 0, FONT_SIZE_ITEM_WIDTH, FONT_SIZE_ITEM_HEIGHT);
    self.normalSizeBtn.frame = CGRectMake(FONT_SIZE_ITEM_WIDTH, 0, FONT_SIZE_ITEM_WIDTH, FONT_SIZE_ITEM_HEIGHT);
    self.bigSizeBtn.frame = CGRectMake(FONT_SIZE_ITEM_WIDTH * 2, 0, FONT_SIZE_ITEM_WIDTH, FONT_SIZE_ITEM_HEIGHT);
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.smallSizeBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.frame = self.smallSizeBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.smallSizeBtn.layer.mask = maskLayer1;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.bigSizeBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc]init];
    maskLayer2.frame = self.bigSizeBtn.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.bigSizeBtn.layer.mask = maskLayer2;
}

- (UIButton *)createButtonWithTag:(NSInteger)tag andImage:(UIImage *)image {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = tag;
    [btn setTintColor:[UIColor clearColor]];
    [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithRed:255/255.0 green:120/255.0 blue:7/255.0 alpha:1.0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [btn setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithRGBHex:0xcccccc]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[[UIImage imageWithColor:[UIColor clearColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
