//
//  ViewController.h
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/**
 *  The base URL to use for the webView
 */
@property (nonatomic, strong) NSURL *baseURL;
/**
 *  If the keyboard should be shown when the editor loads
 */
@property (nonatomic) BOOL shouldShowKeyboard;
/**
 *  The placeholder text to use if there is no editor content
 */
@property (nonatomic, strong) NSString *placeholder;
/**
 *  
 */
@property (nonatomic, copy) NSString *html;

@end

