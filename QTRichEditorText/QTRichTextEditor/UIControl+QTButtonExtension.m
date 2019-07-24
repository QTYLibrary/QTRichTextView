//
//  UIControl+QTButtonExtension.m
//  QTRichEditorText
//
//  Created by QinTuanye on 2019/7/24.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "UIControl+QTButtonExtension.h"
#import <objc/runtime.h>

@implementation UIControl (QTButtonExtension)

static const char* orderTagBy ="orderTagBy";
- (void)setOrderTag:(NSString *)orderTag{
        objc_setAssociatedObject(self, orderTagBy, orderTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)orderTag{
    return objc_getAssociatedObject(self, orderTagBy);
}

@end
