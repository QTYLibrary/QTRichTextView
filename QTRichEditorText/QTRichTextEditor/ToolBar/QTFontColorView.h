//
//  QTFontColorView.h
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTFontColorView;

NS_ASSUME_NONNULL_BEGIN

#define FONT_COLOR_ITEM_COUNT 7
#define FONT_COLOR_ITEM_WIDTH 40
#define FONT_COLOR_ITEM_HEIGHT 40
#define FONT_COLOR_VIEW_WIDTH (FONT_COLOR_ITEM_WIDTH * FONT_COLOR_ITEM_COUNT)
#define FONT_COLOR_VIEW_HEIGHT FONT_COLOR_ITEM_HEIGHT

@protocol QTFontColorViewDelegate <NSObject>

@optional
/**
 点击字体大小按钮的回调
 
 @param fontColorView QTFontColorView对象
 @param sender 点击的按钮
 */
- (void)fontColorView:(QTFontColorView *)fontColorView buttonClick:(UIButton *)sender;

@end

@interface QTFontColorView : UIView

/**
 代理
 */
@property (nonatomic, weak) id<QTFontColorViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
