//
//  UIWebView+QTJSTool.m
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "UIWebView+QTJSTool.h"

typedef struct{
    float r;
    float g;
    float b;
} HRRGBColor;

@implementation UIWebView (QTJSTool)

- (void)qt_focusTextEditor {
    self.keyboardDisplayRequiresUserAction = NO;
    NSString *js = [NSString stringWithFormat:@"qt_editor.focusEditor();"];
    [self stringByEvaluatingJavaScriptFromString:js];
}

- (void)qt_blurTextEditor {
    NSString *js = [NSString stringWithFormat:@"qt_editor.blurEditor();"];
    [self stringByEvaluatingJavaScriptFromString:js];
}

- (void)qt_setHTML:(NSString *)html {
    NSString *cleanedHTML = [self removeQuotesFromHTML:html];
    NSString *trigger = [NSString stringWithFormat:@"qt_editor.setHTML(\"%@\");", cleanedHTML];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (NSString *)qt_getHTML {
    NSString *html = [self stringByEvaluatingJavaScriptFromString:@"qt_editor.getHTML();"];
    html = [self removeQuotesFromHTML:html];
    html = [self tidyHTML:html formatHTML:YES];
    return html;
}

- (void)qt_insertHTML:(NSString *)html {
    NSString *cleanedHTML = [self removeQuotesFromHTML:html];
    NSString *trigger = [NSString stringWithFormat:@"qt_editor.insertHTML(\"%@\");", cleanedHTML];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (NSString *)qt_getText {
    return [self stringByEvaluatingJavaScriptFromString:@"qt_editor.getText();"];
}

- (BOOL)qt_isFirstResponder {
    return [[self stringByEvaluatingJavaScriptFromString:@"document.activeElement.id=='qt_editor_content'"] isEqualToString:@"true"];
}

- (void)qt_removeFormat {
    NSString *trigger = @"qt_editor.removeFormating();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_alignLeft {
    NSString *trigger = @"qt_editor.setJustifyLeft();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_alignCenter {
    NSString *trigger = @"qt_editor.setJustifyCenter();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_alignRight {
    NSString *trigger = @"qt_editor.setJustifyRight();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_alignFull {
    NSString *trigger = @"qt_editor.setJustifyFull();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setBold {
    NSString *trigger = @"qt_editor.setBold();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setItalic {
    NSString *trigger = @"qt_editor.setItalic();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setSubscript {
    NSString *trigger = @"qt_editor.setSubscript();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setUnderline {
    NSString *trigger = @"qt_editor.setUnderline();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setSuperscript {
    NSString *trigger = @"qt_editor.setSuperscript();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setStrikethrough {
    NSString *trigger = @"qt_editor.setStrikeThrough();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setUnorderedList {
    NSString *trigger = @"qt_editor.setUnorderedList();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setOrderedList {
    NSString *trigger = @"qt_editor.setOrderedList();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setHR {
    NSString *trigger = @"qt_editor.setHorizontalRule();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setIndent {
    NSString *trigger = @"qt_editor.setIndent();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_setOutdent {
    NSString *trigger = @"qt_editor.setOutdent();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_heading1 {
    NSString *trigger = @"qt_editor.setHeading('h1');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_heading2 {
    NSString *trigger = @"qt_editor.setHeading('h2');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_heading3 {
    NSString *trigger = @"qt_editor.setHeading('h3');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_heading4 {
    NSString *trigger = @"qt_editor.setHeading('h4');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_heading5 {
    NSString *trigger = @"qt_editor.setHeading('h5');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_heading6 {
    NSString *trigger = @"qt_editor.setHeading('h6');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_paragraph {
    NSString *trigger = @"qt_editor.setParagraph();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_showFontsPicker {
    // Save the selection location
    [self stringByEvaluatingJavaScriptFromString:@"qt_editor.prepareInsert();"];
    //Call picker
//    ZSSFontsViewController *fontPicker = [ZSSFontsViewController cancelableFontPickerViewControllerWithFontFamily:ZSSFontFamilyDefault];
//    fontPicker.delegate = self;
//    [self.navigationController pushViewController:fontPicker animated:YES];
    
}

- (void)qt_setSelectedFontFamily:(QTFontFamily)fontFamily {
    NSString *fontFamilyString;
    
    switch (fontFamily) {
        case QTFontFamilyDefault:
            fontFamilyString = @"Arial, Helvetica, sans-serif";
            break;
            
        case QTFontFamilyGeorgia:
            fontFamilyString = @"Georgia, serif";
            break;
            
        case QTFontFamilyPalatino:
            fontFamilyString = @"Palatino Linotype, Book Antiqua, Palatino, serif";
            break;
            
        case QTFontFamilyTimesNew:
            fontFamilyString = @"Times New Roman, Times, serif";
            break;
            
        case QTFontFamilyTrebuchet:
            fontFamilyString = @"Trebuchet MS, Helvetica, sans-serif";
            break;
            
        case QTFontFamilyVerdana:
            fontFamilyString = @"Verdana, Geneva, sans-serif";
            break;
            
        case QTFontFamilyCourierNew:
            fontFamilyString = @"Courier New, Courier, monospace";
            break;
            
        default:
            fontFamilyString = @"Arial, Helvetica, sans-serif";
            break;
    }
    
    NSString *trigger = [NSString stringWithFormat:@"qt_editor.setFontFamily(\"%@\");", fontFamilyString];
    
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_textColor {
    // Save the selection location
    [self stringByEvaluatingJavaScriptFromString:@"qt_editor.prepareInsert();"];
//    // Call the picker
//    HRColorPickerViewController *colorPicker = [HRColorPickerViewController cancelableFullColorPickerViewControllerWithColor:[UIColor whiteColor]];
//    colorPicker.delegate = self;
//    colorPicker.tag = 1;
//    colorPicker.title = NSLocalizedString(@"Text Color", nil);
//    [self.navigationController pushViewController:colorPicker animated:YES];
    
}

- (void)qt_bgColor {
    // Save the selection location
    [self stringByEvaluatingJavaScriptFromString:@"qt_editor.prepareInsert();"];
    // Call the picker
//    HRColorPickerViewController *colorPicker = [HRColorPickerViewController cancelableFullColorPickerViewControllerWithColor:[UIColor whiteColor]];
//    colorPicker.delegate = self;
//    colorPicker.tag = 2;
//    colorPicker.title = NSLocalizedString(@"BG Color", nil);
//    [self.navigationController pushViewController:colorPicker animated:YES];
}

- (void)qt_setSelectedColor:(UIColor*)color tag:(int)tag {
    NSString *hex = [NSString stringWithFormat:@"#%06x", HexColorFromUIColor(color)];
    NSString *trigger;
    if (tag == 1) {
        trigger = [NSString stringWithFormat:@"qt_editor.setTextColor(\"%@\");", hex];
    } else if (tag == 2) {
        trigger = [NSString stringWithFormat:@"qt_editor.setBackgroundColor(\"%@\");", hex];
    }
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)qt_undo {
    [self stringByEvaluatingJavaScriptFromString:@"qt_editor.undo();"];
}

- (void)qt_redo {
    [self stringByEvaluatingJavaScriptFromString:@"qt_editor.redo();"];
}

- (void)qt_insertLink:(NSString *)url title:(NSString *)title {
    
    NSString *trigger = [NSString stringWithFormat:@"qt_editor.insertLink(\"%@\", \"%@\");", url, title];
    [self stringByEvaluatingJavaScriptFromString:trigger];

//    [self editorDidChangeWithText:[self qt_getText] andHTML:[self qt_getHTML]];
}

- (void)qt_updateLink:(NSString *)url title:(NSString *)title {
    NSString *trigger = [NSString stringWithFormat:@"qt_editor.updateLink(\"%@\", \"%@\");", url, title];
    [self stringByEvaluatingJavaScriptFromString:trigger];

//    [self editorDidChangeWithText:[self qt_getText] andHTML:[self qt_getHTML]];
}

- (void)qt_removeLink {
    [self stringByEvaluatingJavaScriptFromString:@"qt_editor.unlink();"];

//    [self editorDidChangeWithText:[self qt_getText] andHTML:[self qt_getHTML]];
}

- (void)qt_quickLink {
    [self stringByEvaluatingJavaScriptFromString:@"qt_editor.quickLink();"];
    
//    [self editorDidChangeWithText:[self qt_getText] andHTML:[self qt_getHTML]];
}

- (void)qt_setPlaceholderText:(NSString *)placeholder {
    NSString *js = [NSString stringWithFormat:@"qt_editor.setPlaceholder(\"%@\");", placeholder];
    [self stringByEvaluatingJavaScriptFromString:js];
}

- (void)qt_setFooterHeight:(float)footerHeight {
    //Call the setFooterHeight javascript method
    NSString *js = [NSString stringWithFormat:@"qt_editor.setFooterHeight(\"%f\");", footerHeight];
    [self stringByEvaluatingJavaScriptFromString:js];
}

- (void)qt_setContentHeight:(float)contentHeight {
    //Call the contentHeight javascript method
    NSString *js = [NSString stringWithFormat:@"qt_editor.contentHeight = %f;", contentHeight];
    [self stringByEvaluatingJavaScriptFromString:js];
}

- (void)qt_saveSelectLocation {
    // Save the selection location
    [self stringByEvaluatingJavaScriptFromString:@"qt_editor.prepareInsert();"];
}

- (void)insertImage:(NSString *)url alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"qt_editor.insertImage(\"%@\", \"%@\");", url, alt];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)updateImage:(NSString *)url alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"qt_editor.updateImage(\"%@\", \"%@\");", url, alt];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)insertImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"qt_editor.insertImageBase64String(\"%@\", \"%@\");", imageBase64String, alt];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)updateImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"qt_editor.updateImageBase64String(\"%@\", \"%@\");", imageBase64String, alt];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

#pragma mark - 其他方法
- (NSString *)removeQuotesFromHTML:(NSString *)html {
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    return html;
}

- (NSString *)tidyHTML:(NSString *)html formatHTML:(BOOL)format {
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br />"];
    html = [html stringByReplacingOccurrencesOfString:@"<hr>" withString:@"<hr />"];
    if (format) {
        html = [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"style_html(\"%@\");", html]];
    }
    return html;
}

int HexColorFromUIColor(const UIColor* color){
    HRRGBColor rgb_color;
    RGBColorFromUIColor(color, &rgb_color);
    return HexColorFromRGBColor(&rgb_color);
}

void RGBColorFromUIColor(const UIColor* uiColor,HRRGBColor* rgb){
    const CGFloat* components = CGColorGetComponents(uiColor.CGColor);
    if(CGColorGetNumberOfComponents(uiColor.CGColor) == 2){
        rgb->r = components[0];
        rgb->g = components[0];
        rgb->b = components[0];
    }else{
        rgb->r = components[0];
        rgb->g = components[1];
        rgb->b = components[2];
    }
}

int HexColorFromRGBColor(const HRRGBColor* rgb){
    return (int)(rgb->r*255.0f) << 16 | (int)(rgb->g*255.0f) << 8 | (int)(rgb->b*255.0f) << 0;
}

@end
