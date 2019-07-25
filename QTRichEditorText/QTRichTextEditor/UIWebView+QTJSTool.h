//
//  ViewController.m
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int16_t, QTFontFamily) {
    QTFontFamilyDefault = 0,
    QTFontFamilyTrebuchet = 1,
    QTFontFamilyVerdana = 2,
    QTFontFamilyGeorgia = 3,
    QTFontFamilyPalatino = 4,
    QTFontFamilyTimesNew = 5,
    QTFontFamilyCourierNew = 6,
};

@interface UIWebView (QTJSTool)

- (void)qt_focusTextEditor;

- (void)qt_blurTextEditor;

- (void)qt_setHTML:(NSString *)html;

- (NSString *)qt_getHTML;

- (void)qt_insertHTML:(NSString *)html;

- (NSString *)qt_getText;

- (BOOL)qt_isFirstResponder;

- (void)qt_removeFormat;

- (void)qt_alignLeft;

- (void)qt_alignCenter;

- (void)qt_alignRight;

- (void)qt_alignFull;

- (void)qt_setBold;

- (void)qt_setItalic;

- (void)qt_setSubscript;

- (void)qt_setUnderline;

- (void)qt_setSuperscript;

- (void)qt_setStrikethrough;

- (void)qt_setUnorderedList;

- (void)qt_setOrderedList;

- (void)qt_setHR;

- (void)qt_setIndent;

- (void)qt_setOutdent;

- (void)qt_heading1;

- (void)qt_heading2;

- (void)qt_heading3;

- (void)qt_heading4;

- (void)qt_heading5;

- (void)qt_heading6;

- (void)qt_setFontSize:(NSString *)size;

- (void)qt_paragraph;

- (void)qt_setSelectedFontFamily:(QTFontFamily)fontFamily;

- (void)qt_textColor:(UIColor *)color;

- (void)qt_bgColor:(UIColor *)color;

- (void)qt_undo;

- (void)qt_redo;

- (void)qt_insertLink:(NSString *)url title:(NSString *)title;

- (void)qt_updateLink:(NSString *)url title:(NSString *)title;

- (void)qt_removeLink;

- (void)qt_quickLink;

- (void)qt_setPlaceholderText:(NSString *)placeholder;

- (void)qt_setFooterHeight:(float)footerHeight;

- (void)qt_setContentHeight:(float)contentHeight;

- (void)qt_saveSelectLocation;

- (void)insertImage:(NSString *)url alt:(NSString *)alt;

- (void)updateImage:(NSString *)url alt:(NSString *)alt;

- (void)insertImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt;

- (void)updateImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt;

@end
