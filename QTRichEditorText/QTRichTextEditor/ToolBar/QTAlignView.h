//
//  QTAlignView.h
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTAlignView;

NS_ASSUME_NONNULL_BEGIN

#define ALIGN_ITEM_COUNT 3
#define ALIGN_ITEM_WIDTH 60
#define ALIGN_ITEM_HEIGHT 40
#define ALIGN_VIEW_WIDTH (ALIGN_ITEM_WIDTH * ALIGN_ITEM_COUNT)
#define ALIGN_VIEW_HEIGHT ALIGN_ITEM_HEIGHT

@protocol QTAlignViewDelegate <NSObject>

@optional
/**
 点击字体大小按钮的回调
 
 @param alignView QTFontAlignView对象
 @param sender 点击的按钮
 */
- (void)alignView:(QTAlignView *)alignView buttonClick:(UIButton *)sender;

@end

@interface QTAlignView : UIView

/**
 代理
 */
@property (nonatomic, weak) id<QTAlignViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
