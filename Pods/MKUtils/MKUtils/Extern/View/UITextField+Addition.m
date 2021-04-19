//
//  UITextField+Addition.m
//  LMBModuleTool
//
//  Created by zhengmiaokai on 2017/5/23.
//  Copyright © 2017年 辣妈帮. All rights reserved.
//

#import "UITextField+Addition.h"
#import <objc/runtime.h>
#import "MarcoConstant.h"
#import "UIView+Addition.h"

static const void *maxLengthKey = &maxLengthKey;

@implementation UITextField (Addition)

- (NSInteger)maxLength {
    NSNumber* number = objc_getAssociatedObject(self, maxLengthKey);
    return number.integerValue;
}

- (void)setMaxLength:(NSInteger)maxLength {
    NSNumber* number = [NSNumber numberWithInteger:maxLength];
    objc_setAssociatedObject(self, maxLengthKey, number, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFiledEditChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    if (self == textField) {
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxLength) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
                if (rangeIndex.length == 1) {
                    textField.text = [toBeString substringToIndex:self.maxLength];
                } else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

- (void)showInputAccessoryView {
    
    UIToolbar *_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
    
    UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = kFont16;
    [doneBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn sizeToFit];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    _toolbar.items = @[spaceItem, doneItem];
    
    self.inputAccessoryView = _toolbar;
}

- (void)done:(id)sender {
    [self resignFirstResponder];
}

@end
