//
//  ViewController.m
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "QTRichTextEditor.h"
#import "UIColor+expanded.h"

#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define kEditorURL @"QTRichTextEditor"
#define kMAX_INPUT_COUNT 5000

@interface ViewController () <UIWebViewDelegate, QTRichTextToolBarDelegate, QTFontStyleViewDelegate, QTFontSizeViewDelegate, QTAlignViewDelegate, QTFontColorViewDelegate>

/**
 富文本编辑视图
 */
@property (nonatomic, strong) UIWebView *editorView;
/**
 工具条
 */
@property (nonatomic, strong) QTRichTextToolBar *toolBar;
/**
 字体样式控件
 */
@property (nonatomic, strong) QTFontStyleView *styleView;
/**
 字体大小控件
 */
@property (nonatomic, strong) QTFontSizeView *sizeView;
/**
 对齐方式控件
 */
@property (nonatomic, strong) QTAlignView *alignView;
/**
 字体颜色控件
 */
@property (nonatomic, strong) QTFontColorView *colorView;
/**
 是否是粘贴操作
 */
@property (nonatomic, assign) BOOL isEditorPaste;
/**
 UIWebView是否加载完成
 */
@property (nonatomic, assign) BOOL isFinishLoad;

@end

@implementation ViewController

- (IBAction)onCompleted:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - 父类方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.placeholder = @"最多输入5000字";
    [self setupViews];
    [self updateViewsFrame];
    [self loadResource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 私有方法
- (void)updateHTML {
    if (!self.html) {
        _html = @"";
    }
    [self.editorView qt_insertHTML:self.html];
}

- (void)loadResource {
    // Create a string with the contents of QTRichTextEditor.html
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kEditorURL ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    // Add JQuery.js to the html file
    NSString *jquery = [[NSBundle mainBundle] pathForResource:@"jQuery" ofType:@"js"];
    NSString *jqueryString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:jquery] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- jQuery -->" withString:jqueryString];
    
    //Add JSBeautifier.js to the html file
    NSString *beautifier = [[NSBundle mainBundle] pathForResource:@"JSBeautifier" ofType:@"js"];
    NSString *beautifierString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:beautifier] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- jsbeautifier -->" withString:beautifierString];
    
    //Add ZSSRichTextEditor.js to the html file
    NSString *source = [[NSBundle mainBundle] pathForResource:@"QTRichTextEditor" ofType:@"js"];
    NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--editor-->" withString:jsString];
    
    [self.editorView loadHTMLString:htmlString baseURL:self.baseURL];
}

- (void)updateToolBarAndMenuBarStatu:(NSString *)statu {
    [self.toolBar updateItemsStatu:statu];
    [self.styleView updateItemsStatu:statu];
    [self.sizeView updateItemsStatu:statu];
    [self.alignView updateItemsStatu:statu];
    [self.colorView updateItemsStatu:statu];
}

#pragma mark - 监听富文本内容改变
- (void)observerEditorTextDidChanged:(UIWebView *)webView {
    __weak typeof(self) weakSelf = self;
    JSContext *ctx = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    ctx[@"contentUpdateCallback"] = ^(JSValue *msg) {
        __weak typeof(weakSelf) StrongSelf = weakSelf;
        [StrongSelf editorDidChangeWithText:[StrongSelf.editorView qt_getText] andHTML:[StrongSelf.editorView qt_getHTML]];
        [StrongSelf checkForMentionOrHashtagInText:[StrongSelf.editorView qt_getText]];
        
        if (StrongSelf.isEditorPaste) {
//            [StrongSelf.editorView qt_blurTextEditor];
            StrongSelf.isEditorPaste = NO;
        }
    };
    
    ctx[@"contentPasteCallback"] = ^(JSValue *msg) {
        __weak typeof(weakSelf) StrongSelf = weakSelf;
        StrongSelf.isEditorPaste = YES;
    };
    [ctx evaluateScript:@"document.getElementById('qt_editor_content').addEventListener('input', contentUpdateCallback, false);"];
    
    [ctx evaluateScript:@"document.getElementById('qt_editor_content').addEventListener('paste', contentPasteCallback, false);"];
}

- (void)editorDidChangeWithText:(NSString *)text andHTML:(NSString *)html {
    NSLog(@"editorDidChangeWithText=>text: %@, html: %@", text, html);
//    if (text.length > kMAX_INPUT_COUNT) {
//        [self.editorView ];
//    }
}

- (void)checkForMentionOrHashtagInText:(NSString *)text {
    if ([text containsString:@" "] && [text length] > 0) {
        NSString *lastWord = nil;
        NSString *matchedWord = nil;
        BOOL ContainsHashtag = NO;
        BOOL ContainsMention = NO;
        
        NSRange range = [text rangeOfString:@" " options:NSBackwardsSearch];
        lastWord = [text substringFromIndex:range.location];
        
        if (lastWord != nil) {
            //Check if last word typed starts with a #
            NSRegularExpression *hashtagRegex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:nil];
            NSArray *hashtagMatches = [hashtagRegex matchesInString:lastWord options:0 range:NSMakeRange(0, lastWord.length)];
            
            for (NSTextCheckingResult *match in hashtagMatches) {
                NSRange wordRange = [match rangeAtIndex:1];
                NSString *word = [lastWord substringWithRange:wordRange];
                matchedWord = word;
                ContainsHashtag = YES;
            }
            
            if (!ContainsHashtag) {
                //Check if last word typed starts with a @
                NSRegularExpression *mentionRegex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:nil];
                NSArray *mentionMatches = [mentionRegex matchesInString:lastWord options:0 range:NSMakeRange(0, lastWord.length)];
                
                for (NSTextCheckingResult *match in mentionMatches) {
                    NSRange wordRange = [match rangeAtIndex:1];
                    NSString *word = [lastWord substringWithRange:wordRange];
                    matchedWord = word;
                    ContainsMention = YES;
                }
            }
        }
        
        if (ContainsHashtag) {
            [self hashtagRecognizedWithWord:matchedWord];
        }
        
        if (ContainsMention) {
            [self mentionRecognizedWithWord:matchedWord];
        }
    }
}

//Blank implementation
- (void)hashtagRecognizedWithWord:(NSString *)word {}

//Blank implementation
- (void)mentionRecognizedWithWord:(NSString *)word {}

#pragma mark - Keyboard Frame changed
- (void)keyBoardWillChangeFrame:(NSNotification*)notification{
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:duration animations:^{
            self.toolBar.transform =  CGAffineTransformIdentity;
            CGRect editorFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
            self.editorView.frame = editorFrame;
            [self updateAllToolBarMenuViewsFrame];
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
            
            CGRect editorFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - frame.size.height);
            self.editorView.frame = editorFrame;
            [self updateAllToolBarMenuViewsFrame];
        }];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = [[request URL] absoluteString];
    NSLog(@"shouldStartLoadWithRequest=>request: %@", urlString);
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    } else if ([urlString rangeOfString:@"callback://0/"].location != NSNotFound) {
        // We recieved the callback
        NSString *className = [urlString stringByReplacingOccurrencesOfString:@"callback://0/" withString:@""];
        NSLog(@"shouldStartLoadWithRequest=>className: %@", className);
        [self updateToolBarAndMenuBarStatu:className];
    } else if ([urlString rangeOfString:@"debug://"].location != NSNotFound) {
        NSLog(@"Debug Found");
        // We recieved the callback
        NSString *debug = [urlString stringByReplacingOccurrencesOfString:@"debug://" withString:@""];
        debug = [debug stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
        NSLog(@"%@", debug);
    } else if ([urlString rangeOfString:@"scroll://"].location != NSNotFound) {
        NSInteger position = [[urlString stringByReplacingOccurrencesOfString:@"scroll://" withString:@""] integerValue];
//        [self editorDidScrollWithPosition:position];
        
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad...");
    if (self.shouldShowKeyboard) {
        [self.editorView qt_focusTextEditor];
    }
    
    if (_placeholder && [_placeholder length] != 0) {
        [self.editorView qt_setPlaceholderText:_placeholder];
    }
    
    [self observerEditorTextDidChanged:webView];
    
    self.isFinishLoad = YES;
}

#pragma mark - QTRichTextToolBarDelegate
- (void)toolBar:(QTRichTextToolBar *)toolBar buttonClick:(UIButton *)sender {
    [self hideAllToolBarMenuViews];
    if (sender.tag != 100 && sender.isSelected && ![self.editorView isFirstResponder]) {
        [self.editorView qt_focusTextEditor];
    }
    switch (sender.tag) {
        case 100:
            // 隐藏键盘
            [self.view endEditing:YES];
            break;
            
        case 101: {
            // 字体样式
            [self showFontStyleViewWithSender:sender];
        } break;
            
        case 102: {
            // 字体大小
            [self showFontSizeViewWithSender:sender];
        } break;
            
        case 103: {
            // 对齐方式
            [self showAlignViewWithSender:sender];
        } break;
            
        case 104: {
            // 字体颜色
            [self showFontColorViewWithSender:sender];
        } break;
            
        case 105:
            // 撤销
            [self.editorView qt_undo];
            break;
            
        case 106:
            // 重做
            [self hideAllToolBarMenuViews];
            [self.editorView qt_redo];
            break;
    }
}

- (void)hideAllToolBarMenuViews {
    if (self.styleView.superview) {
        [self.styleView removeFromSuperview];
    }
    if (self.sizeView.superview) {
        [self.sizeView removeFromSuperview];
    }
    if (self.alignView.superview) {
        [self.alignView removeFromSuperview];
    }
    if (self.colorView.superview) {
        [self.colorView removeFromSuperview];
    }
}

- (void)showFontStyleViewWithSender:(UIButton *)sender {
    [self updateFontStyleViewFrame:sender];
    if (sender.isSelected) {
        [self.view addSubview:self.styleView];
    } else {
        [self.styleView removeFromSuperview];
    }
}

- (void)showFontSizeViewWithSender:(UIButton *)sender {
    [self updateFontSizeViewFrame:sender];
    if (sender.isSelected) {
        [self.view addSubview:self.sizeView];
    } else {
        [self.sizeView removeFromSuperview];
    }
}

- (void)showAlignViewWithSender:(UIButton *)sender {
    [self updateAlignViewFrame:sender];
    if (sender.isSelected) {
        [self.view addSubview:self.alignView];
    } else {
        [self.alignView removeFromSuperview];
    }
}

- (void)showFontColorViewWithSender:(UIButton *)sender {
    [self updateFontColorViewFrame:sender];
    if (sender.isSelected) {
        [self.view addSubview:self.colorView];
    } else {
        [self.colorView removeFromSuperview];
    }
}

#pragma mark - UIFontStyleViewDelegate
- (void)fontStyleView:(QTFontStyleView *)fontStyleView buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 200:
            // 加粗
            [self.editorView qt_setBold];
            break;
            
        case 201:
            // 斜体
            [self.editorView qt_setItalic];
            break;
            
        case 202:
            // 下划线
            [self.editorView qt_setUnderline];
            break;
    }
}

#pragma mark - UIFontSizeViewDelegate
- (void)fontSizeView:(QTFontSizeView *)fontSizeView buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 300:
            // 小号字体
            [self.editorView qt_setFontSize:@"2"];
            break;
            
        case 301:
            // 普通字体
            [self.editorView qt_setFontSize:@"3"];
            break;
            
        case 302:
            // 大号字体
            [self.editorView qt_setFontSize:@"4"];
            break;
    }
}

#pragma mark - UIAlignViewDelegate
- (void)alignView:(QTAlignView *)alignView buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 400:
            // 左对齐
            [self.editorView qt_alignLeft];
            break;
            
        case 401:
            // 居中对齐
            [self.editorView qt_alignCenter];
            break;
            
        case 402:
            // 右对齐
            [self.editorView qt_alignRight];
            break;
    }
}

#pragma mark - UIFontColorViewDelegate
- (void)fontColorView:(QTFontColorView *)fontColorView buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 500:
            // 黑色
            [self.editorView qt_textColor:[UIColor colorWithRGBHex:0x2c2c2c]];
            break;
            
        case 501:
            // 灰色
            [self.editorView qt_textColor:[UIColor colorWithRGBHex:0x999999]];
            break;
            
        case 502:
            // 红色
            [self.editorView qt_textColor:[UIColor colorWithRGBHex:0xFA5555]];
            break;
            
        case 503:
            // 橙色
            [self.editorView qt_textColor:[UIColor colorWithRGBHex:0xFF7807]];
            break;
            
        case 504:
            // 绿色
            [self.editorView qt_textColor:[UIColor colorWithRGBHex:0x65CD0D]];
            break;
            
        case 505:
            // 蓝色
            [self.editorView qt_textColor:[UIColor colorWithRGBHex:0x3797F7]];
            break;
            
        case 506:
            // 紫色
            [self.editorView qt_textColor:[UIColor colorWithRGBHex:0x5856D6]];
            break;
    }
    if (self.colorView.superview) {
        [self.colorView removeFromSuperview];
        [self.toolBar resetItemsStatu];
    }
}

#pragma mark - 初始化视图
- (void)setupViews {
    [self.view addSubview:self.editorView];
    [self.view addSubview:self.toolBar];
}

- (void)updateViewsFrame {
    NSLog(@"updateViewsFrame=>width: %f height: %f", self.view.frame.size.width, self.view.frame.size.height);
    self.editorView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
    self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - 44 - 64, self.view.frame.size.width, 44);
    [self updateAllToolBarMenuViewsFrame];
}

- (void)updateAllToolBarMenuViewsFrame {
    [self updateFontStyleViewFrame:self.toolBar.styleBtn];
    [self updateFontSizeViewFrame:self.toolBar.sizeBtn];
    [self updateAlignViewFrame:self.toolBar.alignBtn];
    [self updateFontColorViewFrame:self.toolBar.colorBtn];
}

- (void)updateFontStyleViewFrame:(UIButton *)sender {
    CGRect rect = [self relativeFrame:sender];
    CGFloat w = FONT_STYLE_VIEW_WIDTH;
    CGFloat h = FONT_STYLE_VIEW_HEIGHT;
    CGFloat mid = CGRectGetMidX(rect);
    CGFloat x = mid - (w * 0.5);
    if (x < 16) {
        x = 16;
    }
    CGFloat y = self.toolBar.frame.origin.y - 11 - h;
    self.styleView.frame = CGRectMake(x, y, w, h);
}

- (void)updateFontSizeViewFrame:(UIButton *)sender {
    CGRect rect = [self relativeFrame:sender];
    CGFloat w = FONT_SIZE_VIEW_WIDTH;
    CGFloat h = FONT_SIZE_VIEW_HEIGHT;
    CGFloat mid = CGRectGetMidX(rect);
    CGFloat x = mid - (w * 0.5);
    if (x < 16) {
        x = 16;
    }
    CGFloat y = self.toolBar.frame.origin.y - 11 - h;
    self.sizeView.frame = CGRectMake(x, y, w, h);
}

- (void)updateAlignViewFrame:(UIButton *)sender {
    CGRect rect = [self relativeFrame:sender];
    CGFloat w = ALIGN_VIEW_WIDTH;
    CGFloat h = ALIGN_VIEW_HEIGHT;
    CGFloat mid = CGRectGetMidX(rect);
    CGFloat x = mid - (w * 0.5);
    if (x < 16) {
        x = 16;
    }
    CGFloat y = self.toolBar.frame.origin.y - 11 - h;
    self.alignView.frame = CGRectMake(x, y, w, h);
}

- (void)updateFontColorViewFrame:(UIButton *)sender {
    CGRect rect = [self relativeFrame:sender];
    CGFloat w = FONT_COLOR_VIEW_WIDTH;
    CGFloat h = FONT_COLOR_VIEW_HEIGHT;
    CGFloat mid = CGRectGetMidX(rect);
    CGFloat x = mid - (w * 0.5);
    if ((x + w + 16) > CGRectGetMaxX(self.toolBar.frame)) {
        x = CGRectGetMaxX(self.toolBar.frame) - 16 - w;
    }
    CGFloat y = self.toolBar.frame.origin.y - 11 - h;
    self.colorView.frame = CGRectMake(x, y, w, h);
}

- (CGRect)relativeFrame:(UIView *)view {
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect frame = [view convertRect:view.bounds toView:window];
    return frame;
}

#pragma mark - getter方法
- (UIWebView *)editorView {
    if (!_editorView) {
        _editorView = [[UIWebView alloc] init];
        _editorView.delegate = self;
        _editorView.hidesInputAccessoryView = YES;
        _editorView.keyboardDisplayRequiresUserAction = NO;
        _editorView.scalesPageToFit = YES;
        _editorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _editorView.dataDetectorTypes = UIDataDetectorTypeNone;
        _editorView.scrollView.bounces = NO;
        _editorView.backgroundColor = [UIColor whiteColor];
    }
    return _editorView;
}

- (QTRichTextToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[QTRichTextToolBar alloc] init];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

- (QTFontStyleView *)styleView {
    if (!_styleView) {
        _styleView = [[QTFontStyleView alloc] init];
        _styleView.delegate = self;
    }
    return _styleView;
}

- (QTFontSizeView *)sizeView {
    if (!_sizeView) {
        _sizeView = [[QTFontSizeView alloc] init];
        _sizeView.delegate = self;
    }
    return _sizeView;
}

- (QTAlignView *)alignView {
    if (!_alignView) {
        _alignView = [[QTAlignView alloc] init];
        _alignView.delegate = self;
    }
    return _alignView;
}

- (QTFontColorView *)colorView {
    if (!_colorView) {
        _colorView = [[QTFontColorView alloc] init];
        _colorView.delegate = self;
    }
    return _colorView;
}

#pragma mark - setter方法
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (self.isFinishLoad && _placeholder && [_placeholder length] != 0) {
        [self.editorView qt_setPlaceholderText:_placeholder];
    }
}

@end


