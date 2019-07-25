//
//  QTRichTextEditorDemo.m
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/25.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "QTRichTextEditorDemo.h"
#import "ViewController.h"

@interface QTRichTextEditorDemo ()

@end

@implementation QTRichTextEditorDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"QTRichTextEditorDemo";
    
    UIButton *test = [UIButton buttonWithType:UIButtonTypeSystem];
    [test setTitle:@"测试" forState:UIControlStateNormal];
    [test addTarget:self action:@selector(testDemo) forControlEvents:UIControlEventTouchUpInside];
    test.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 30, CGRectGetMidY(self.view.frame) - 15, 60, 30);
    [self.view addSubview:test];
}

- (void)testDemo {
    ViewController *controller = [[ViewController alloc] init];
    controller.html = @"<div class=\"ancda_news_section\">个好机会就解决<span style=\"font-size:20px;\">&nbsp;经济报道家牛奶混合</span><span style=\"font-size:12px;\">&nbsp;看看吗很纠结 并非 宝贝vjb</span><span style=\"font-size:16px;\">&nbsp;恐怖 v 吃妓女</span><span style=\"font-size:16px;\"></span></div>";
    [self.navigationController pushViewController:controller animated:YES];
}
@end
