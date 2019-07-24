//
//  QTRichTextToolBar.h
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTRichTextToolBar;

NS_ASSUME_NONNULL_BEGIN

@protocol QTRichTextToolBarDelegate <NSObject>

@optional
/**
 点击工具栏按钮的回调方法

 @param toolBar QTRichTextToolBar对象
 @param sender 点击的按钮
 */
- (void)toolBar:(QTRichTextToolBar *)toolBar buttonClick:(UIButton *)sender;

@end

@interface QTRichTextToolBar : UIView

/**
 代理
 */
@property (nonatomic, weak) id<QTRichTextToolBarDelegate> delegate;
/**
 样式按钮
 */
@property (nonatomic, strong) UIButton *styleBtn;
/**
 字体大小按钮
 */
@property (nonatomic, strong) UIButton *sizeBtn;
/**
 对齐按钮
 */
@property (nonatomic, strong) UIButton *alignBtn;
/**
 字体颜色按钮
 */
@property (nonatomic, strong) UIButton *colorBtn;

/**
 更新按钮状态

 @param statu 状态
 */
- (void)updateItemsStatu:(NSString *)statu;

/**
 重置所有按钮状态
 */
- (void)resetItemsStatu;

@end

NS_ASSUME_NONNULL_END
