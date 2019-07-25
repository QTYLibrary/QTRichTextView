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

/**
 是否有粗体
 */
@property (nonatomic, assign) BOOL hasBold;
/**
 是否有斜体
 */
@property (nonatomic, assign) BOOL hasItalic;
/**
 是否有下划线
 */
@property (nonatomic, assign) BOOL hasUnderLine;
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
/**
 是否是左对齐
 */
@property (nonatomic, assign) BOOL isLeftAlign;
/**
 是否是居中对齐
 */
@property (nonatomic, assign) BOOL isCenterAlign;
/**
 是否是右对齐
 */
@property (nonatomic, assign) BOOL isRightAlign;

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
    NSLog(@"updateItemsStatu=>statu: %@", statu);
    if (!statu) {
        return;
    }
    NSArray *status = [statu componentsSeparatedByString:@","];
    self.hasBold = [status containsObject:@"bold"];
    self.hasItalic = [status containsObject:@"italic"];
    self.hasUnderLine = [status containsObject:@"underline"];
    self.isSmallSize = [status containsObject:@"fontSize:2"];
    self.isNormalSize = [status containsObject:@"fontSize:3"];
    self.isBigSize = [status containsObject:@"fontSize:4"];
    self.isLeftAlign = [status containsObject:@"justifyLeft"];
    self.isCenterAlign = [status containsObject:@"justifyCenter"];
    self.isRightAlign = [status containsObject:@"justifyRight"];
    
    [self updateAllItemStatus];
}

#pragma mark - 其他方法
- (void)updateAllItemStatus {
    [self updateStyleBtnStatu];
    [self updateSizeBtnStatu];
    [self updateAlignBtnStatu];
}

- (void)updateStyleBtnStatu {
    if (self.hasBold && self.hasItalic && self.hasUnderLine) {
        if (self.styleBtn.isSelected) {
            [self.styleBtn setImage:[UIImage imageNamed:@"ToolBarBoldUnderLineItalic"] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.styleBtn setImage:[[UIImage imageNamed:@"ToolBarBoldUnderLineItalic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor clearColor]];
        }
    } else if (self.hasBold && self.hasItalic) {
        if (self.styleBtn.isSelected) {
            [self.styleBtn setImage:[UIImage imageNamed:@"ToolBarBoldItalic"] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.styleBtn setImage:[[UIImage imageNamed:@"ToolBarBoldItalic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor clearColor]];
        }
    } else if (self.hasBold && self.hasUnderLine) {
        if (self.styleBtn.isSelected) {
            [self.styleBtn setImage:[UIImage imageNamed:@"ToolBarBoldUnderLine"] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.styleBtn setImage:[[UIImage imageNamed:@"ToolBarBoldUnderLine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor clearColor]];
        }
    } else if (self.hasItalic && self.hasUnderLine) {
        if (self.styleBtn.isSelected) {
            [self.styleBtn setImage:[UIImage imageNamed:@"ToolBarUnderLineItalic"] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.styleBtn setImage:[[UIImage imageNamed:@"ToolBarUnderLineItalic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor clearColor]];
        }
    } else if (self.hasBold) {
        if (self.styleBtn.isSelected) {
            [self.styleBtn setImage:[UIImage imageNamed:@"ToolBarBold"] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.styleBtn setImage:[[UIImage imageNamed:@"ToolBarBold"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor clearColor]];
        }
    } else if (self.hasItalic) {
        if (self.styleBtn.isSelected) {
            [self.styleBtn setImage:[UIImage imageNamed:@"ToolBarItalic"] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.styleBtn setImage:[[UIImage imageNamed:@"ToolBarItalic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor clearColor]];
        }
    } else if (self.hasUnderLine) {
        if (self.styleBtn.isSelected) {
            [self.styleBtn setImage:[UIImage imageNamed:@"ToolBarUnderLine"] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.styleBtn setImage:[[UIImage imageNamed:@"ToolBarUnderLine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor clearColor]];
        }
    } else {
        if (self.styleBtn.isSelected) {
            [self.styleBtn setImage:[UIImage imageNamed:@"FontStyle"] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.styleBtn setImage:[[UIImage imageNamed:@"FontStyle"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.styleBtn setTintColor:[UIColor clearColor]];
        }
    }
}

- (void)updateSizeBtnStatu {
    if (self.isSmallSize) {
        if (self.sizeBtn.isSelected) {
            [self.sizeBtn setImage:[[UIImage imageNamed:@"ToolBarSmallSize_Selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        } else {
            [self.sizeBtn setImage:[[UIImage imageNamed:@"ToolBarSmallSize"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    } else if (self.isBigSize) {
        if (self.sizeBtn.isSelected) {
            [self.sizeBtn setImage:[[UIImage imageNamed:@"ToolBarBigSize_Selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        } else {
            [self.sizeBtn setImage:[[UIImage imageNamed:@"ToolBarBigSize"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    } else {
        if (self.sizeBtn.isSelected) {
            [self.sizeBtn setImage:[[UIImage imageNamed:@"ToolBarNormalSize_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        } else {
            [self.sizeBtn setImage:[[UIImage imageNamed:@"FontSize"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
    }
}

- (void)updateAlignBtnStatu {
    if (self.isCenterAlign) {
        if (self.alignBtn.isSelected) {
            [self.alignBtn setImage:[UIImage imageNamed:@"ToolBarCenter"] forState:UIControlStateNormal];
            [self.alignBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.alignBtn setImage:[[UIImage imageNamed:@"ToolBarCenter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.alignBtn setTintColor:[UIColor clearColor]];
        }
    } else if (self.isRightAlign) {
        if (self.alignBtn.isSelected) {
            [self.alignBtn setImage:[UIImage imageNamed:@"ToolBarRight"] forState:UIControlStateNormal];
            [self.alignBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.alignBtn setImage:[[UIImage imageNamed:@"ToolBarRight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.alignBtn setTintColor:[UIColor clearColor]];
        }
    } else {
        if (self.alignBtn.isSelected) {
            [self.alignBtn setImage:[UIImage imageNamed:@"Align"] forState:UIControlStateNormal];
            [self.alignBtn setTintColor:[UIColor whiteColor]];
        } else {
            [self.alignBtn setImage:[[UIImage imageNamed:@"Align"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.alignBtn setTintColor:[UIColor clearColor]];
        }
    }
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
    [self updateAllItemStatus];
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = tag;
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn setTintColor:[UIColor clearColor]];
    [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
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
