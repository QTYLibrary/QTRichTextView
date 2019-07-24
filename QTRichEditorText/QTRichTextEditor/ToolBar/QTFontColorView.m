//
//  QTFontColorView.m
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "QTFontColorView.h"
#import "UIImage+Common.h"
#import "UIColor+expanded.h"

@interface QTFontColorView()

/**
 黑色按钮
 */
@property (nonatomic, strong) UIButton *blackBtn;
/**
 灰色按钮
 */
@property (nonatomic, strong) UIButton *grayBtn;
/**
 红色按钮
 */
@property (nonatomic, strong) UIButton *redBtn;
/**
 橙色按钮
 */
@property (nonatomic, strong) UIButton *orangeBtn;
/**
 绿色按钮
 */
@property (nonatomic, strong) UIButton *greenBtn;
/**
 蓝色按钮
 */
@property (nonatomic, strong) UIButton *blueBtn;
/**
 紫色按钮
 */
@property (nonatomic, strong) UIButton *purpleBtn;
/**
 是否初始化完成
 */
@property (nonatomic, assign) BOOL isInited;

@end

@implementation QTFontColorView

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

#pragma mark - 其他方法
- (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);

    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f,
                             image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);

    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
- (void)resetAllItemStatu {
    self.blackBtn.selected = NO;
    self.grayBtn.selected = NO;
    self.redBtn.selected = NO;
    self.orangeBtn.selected = NO;
    self.greenBtn.selected = NO;
    self.blueBtn.selected = NO;
    self.purpleBtn.selected = NO;
}

#pragma mark - 按钮点击事件
- (void)onButtonClick:(UIButton *)sender {
    if (!sender.isSelected) {
        [self resetAllItemStatu];
        [sender setSelected:YES];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(fontColorView:buttonClick:)]) {
        [self.delegate fontColorView:self buttonClick:sender];
    }
}

#pragma mark - 初始化视图
- (void)createViews {
    _blackBtn = [self createButtonWithTag:500 andImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0x2c2c2c] withFrame:CGRectMake(0, 0, 16, 16)]];
    _grayBtn = [self createButtonWithTag:501 andImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0x999999] withFrame:CGRectMake(0, 0, 16, 16)]];
    _redBtn = [self createButtonWithTag:501 andImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0xFA5555] withFrame:CGRectMake(0, 0, 16, 16)]];
    _orangeBtn = [self createButtonWithTag:501 andImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0xFF7807] withFrame:CGRectMake(0, 0, 16, 16)]];
    _greenBtn = [self createButtonWithTag:501 andImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0x65CD0D] withFrame:CGRectMake(0, 0, 16, 16)]];
    _blueBtn = [self createButtonWithTag:501 andImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0x3797F7] withFrame:CGRectMake(0, 0, 16, 16)]];
    _purpleBtn = [self createButtonWithTag:501 andImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0x5856D6] withFrame:CGRectMake(0, 0, 16, 16)]];
    
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 1;
    self.layer.cornerRadius = 5;
    
    [self addSubview:self.blackBtn];
    [self addSubview:self.grayBtn];
    [self addSubview:self.redBtn];
    [self addSubview:self.orangeBtn];
    [self addSubview:self.greenBtn];
    [self addSubview:self.blueBtn];
    [self addSubview:self.purpleBtn];
}

- (void)updateViewsFrame {
    self.blackBtn.frame = CGRectMake(0, 0, FONT_COLOR_ITEM_WIDTH, FONT_COLOR_ITEM_HEIGHT);
    self.grayBtn.frame = CGRectMake(FONT_COLOR_ITEM_WIDTH, 0, FONT_COLOR_ITEM_WIDTH, FONT_COLOR_ITEM_HEIGHT);
    self.redBtn.frame = CGRectMake(FONT_COLOR_ITEM_WIDTH * 2, 0, FONT_COLOR_ITEM_WIDTH, FONT_COLOR_ITEM_HEIGHT);
    self.orangeBtn.frame = CGRectMake(FONT_COLOR_ITEM_WIDTH * 3, 0, FONT_COLOR_ITEM_WIDTH, FONT_COLOR_ITEM_HEIGHT);
    self.greenBtn.frame = CGRectMake(FONT_COLOR_ITEM_WIDTH * 4, 0, FONT_COLOR_ITEM_WIDTH, FONT_COLOR_ITEM_HEIGHT);
    self.blueBtn.frame = CGRectMake(FONT_COLOR_ITEM_WIDTH * 5, 0, FONT_COLOR_ITEM_WIDTH, FONT_COLOR_ITEM_HEIGHT);
    self.purpleBtn.frame = CGRectMake(FONT_COLOR_ITEM_WIDTH * 6, 0, FONT_COLOR_ITEM_WIDTH, FONT_COLOR_ITEM_HEIGHT);
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.blackBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.frame = self.blackBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.blackBtn.layer.mask = maskLayer1;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.purpleBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc]init];
    maskLayer2.frame = self.purpleBtn.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.purpleBtn.layer.mask = maskLayer2;
}

- (UIButton *)createButtonWithTag:(NSInteger)tag andImage:(UIImage *)image {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setImage:[self circleImage:image withParam:0] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0xcccccc]] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
