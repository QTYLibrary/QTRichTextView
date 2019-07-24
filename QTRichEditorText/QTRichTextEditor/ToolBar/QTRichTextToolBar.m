//
//  QTRichTextToolBar.m
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "QTRichTextToolBar.h"
#import "UIImage+Common.h"
#import "UIColor+expanded.h"

#define kLineMinHeight (1.0/ [UIScreen mainScreen].scale)
#define ITEM_WIDTH 24
#define ITEM_HEIGHT 24
#define LEFT_MARGIN 18
#define RIGHT_MARGIN 18

@interface QTRichTextToolBar()

/**
 顶部分隔线
 */
@property (nonatomic, strong) UIView *topSeparationLineView;
/**
 隐藏键盘按钮
 */
@property (nonatomic, strong) UIButton *hideKeyboardBtn;
/**
 撤销按钮
 */
@property (nonatomic, strong) UIButton *undoBtn;
/**
 重做按钮
 */
@property (nonatomic, strong) UIButton *redoBtn;
/**
 是否初始化完成
 */
@property (nonatomic, assign) BOOL isInited;

@end

@implementation QTRichTextToolBar

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
    
}

- (void)resetItemsStatu {
    self.hideKeyboardBtn.selected = NO;
    self.styleBtn.selected = NO;
    self.sizeBtn.selected = NO;
    self.alignBtn.selected = NO;
    self.colorBtn.selected = NO;
    self.undoBtn.selected = NO;
    self.redoBtn.selected = NO;
}

- (void)resetOtherItemsStatu:(UIButton *)sender {
    if (sender != self.hideKeyboardBtn) {
        self.hideKeyboardBtn.selected = NO;
    }
    if (sender != self.styleBtn) {
        self.styleBtn.selected = NO;
    }
    if (sender != self.sizeBtn) {
        self.sizeBtn.selected = NO;
    }
    if (sender != self.alignBtn) {
        self.alignBtn.selected = NO;
    }
    if (sender != self.colorBtn) {
        self.colorBtn.selected = NO;
    }
    if (sender != self.undoBtn) {
        self.undoBtn.selected = NO;
    }
    if (sender != self.redoBtn) {
        self.redoBtn.selected = NO;
    }
}

#pragma mark - 按钮点击后的处理方法
- (void)onButtonClick:(UIButton *)sender {
    [self resetOtherItemsStatu:sender];
    BOOL selected = sender.selected;
    [sender setSelected:!selected];
    NSLog(@"onButtonClick=>last: %d, now: %d", selected, sender.selected);
    if (sender.tag == 101 || sender.tag == 102 || sender.tag == 103) {
        if (sender.selected) {
            [sender setTintColor:[UIColor whiteColor]];
        } else {
            [sender setTintColor:[UIColor clearColor]];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolBar:buttonClick:)]) {
        [self.delegate toolBar:self buttonClick:sender];
    }
}

#pragma mark - 初始化视图
- (void)createViews {
    self.backgroundColor = [UIColor whiteColor];
    _topSeparationLineView = [[UIView alloc] init];
    _hideKeyboardBtn = [self createNormalButtonWithTag:100 andImage:[[UIImage imageNamed:@"HideKeyboard"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _styleBtn = [self createSelectedItemButtonWithTag:101 andImage:[UIImage imageNamed:@"FontStyle"]];
    _sizeBtn = [self createSelectedItemButtonWithTag:102 andImage:[UIImage imageNamed:@"FontSize"]];
    _alignBtn = [self createSelectedItemButtonWithTag:103 andImage:[UIImage imageNamed:@"Align"]];
    _colorBtn = [self createSelectedItemButtonWithTag:104 andImage:[[UIImage imageNamed:@"FontColor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _undoBtn = [self createNormalButtonWithTag:105 andImage:[[UIImage imageNamed:@"Undo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _redoBtn = [self createNormalButtonWithTag:106 andImage:[[UIImage imageNamed:@"Redo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.topSeparationLineView.backgroundColor = [UIColor colorWithRGBHex:0xcccccc];
    
    [self addSubview:self.topSeparationLineView];
    [self addSubview:self.hideKeyboardBtn];
    [self addSubview:self.styleBtn];
    [self addSubview:self.sizeBtn];
    [self addSubview:self.alignBtn];
    [self addSubview:self.colorBtn];
    [self addSubview:self.undoBtn];
    [self addSubview:self.redoBtn];
}

- (void)updateViewsFrame {
    CGFloat itemMargin = (self.frame.size.width - (LEFT_MARGIN + RIGHT_MARGIN) - ITEM_WIDTH * 7) / 6;
    CGFloat y = (self.frame.size.height - ITEM_HEIGHT) * 0.5;
    self.topSeparationLineView.frame = CGRectMake(0, 0, self.frame.size.width, kLineMinHeight);
    self.hideKeyboardBtn.frame = CGRectMake(LEFT_MARGIN, y, ITEM_WIDTH, ITEM_HEIGHT);
    self.styleBtn.frame = CGRectMake(CGRectGetMaxX(self.hideKeyboardBtn.frame) + itemMargin, y, ITEM_WIDTH, ITEM_HEIGHT);
    self.sizeBtn.frame = CGRectMake(CGRectGetMaxX(self.styleBtn.frame) + itemMargin, y, ITEM_WIDTH, ITEM_HEIGHT);
    self.alignBtn.frame = CGRectMake(CGRectGetMaxX(self.sizeBtn.frame) + itemMargin, y, ITEM_WIDTH, ITEM_HEIGHT);
    self.colorBtn.frame = CGRectMake(CGRectGetMaxX(self.alignBtn.frame) + itemMargin, y, ITEM_WIDTH, ITEM_HEIGHT);
    self.undoBtn.frame = CGRectMake(CGRectGetMaxX(self.colorBtn.frame) + itemMargin, y, ITEM_WIDTH, ITEM_HEIGHT);
    self.redoBtn.frame = CGRectMake(CGRectGetMaxX(self.undoBtn.frame) + itemMargin, y, ITEM_WIDTH, ITEM_HEIGHT);
}

- (UIButton *)createSelectedItemButtonWithTag:(NSInteger)tag andImage:(UIImage *)image {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn setImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255/255.0 green:120/255.0 blue:7/255.0 alpha:1.0]] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *)createNormalButtonWithTag:(NSInteger)tag andImage:(UIImage *)image {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
