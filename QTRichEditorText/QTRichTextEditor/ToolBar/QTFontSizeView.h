//
//  QTFontSizeView.h
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTFontSizeView;

NS_ASSUME_NONNULL_BEGIN

#define FONT_SIZE_ITEM_COUNT 3
#define FONT_SIZE_ITEM_WIDTH 60
#define FONT_SIZE_ITEM_HEIGHT 40
#define FONT_SIZE_VIEW_WIDTH (FONT_SIZE_ITEM_WIDTH * FONT_SIZE_ITEM_COUNT)
#define FONT_SIZE_VIEW_HEIGHT FONT_SIZE_ITEM_HEIGHT

@protocol QTFontSizeViewDelegate <NSObject>

@optional
/**
 点击字体大小按钮的回调
 
 @param fontSizeView QTFontSizeView对象
 @param sender 点击的按钮
 */
- (void)fontSizeView:(QTFontSizeView *)fontSizeView buttonClick:(UIButton *)sender;

@end

@interface QTFontSizeView : UIView

/**
 代理
 */
@property (nonatomic, weak) id<QTFontSizeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
