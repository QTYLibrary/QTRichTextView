//
//  QTFontStyleView.h
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTFontStyleView;

NS_ASSUME_NONNULL_BEGIN

#define FONT_STYLE_ITEM_COUNT 3
#define FONT_STYLE_ITEM_WIDTH 60
#define FONT_STYLE_ITEM_HEIGHT 40
#define FONT_STYLE_VIEW_WIDTH (FONT_STYLE_ITEM_WIDTH * FONT_STYLE_ITEM_COUNT)
#define FONT_STYLE_VIEW_HEIGHT FONT_STYLE_ITEM_HEIGHT

@protocol QTFontStyleViewDelegate <NSObject>

@optional
/**
 点击字体样式按钮的回调

 @param fontStyleView QTFontStyleView对象
 @param sender 点击的按钮
 */
- (void)fontStyleView:(QTFontStyleView *)fontStyleView buttonClick:(UIButton *)sender;

@end

@interface QTFontStyleView : UIView

/**
 代理
 */
@property (nonatomic, copy) id<QTFontStyleViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
