//
//  UILabel+Category.m
//  Basic
//
//  Created by zhengmiaokai on 16/5/12.
//  Copyright © 2016年 zhengmiaokai. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

+ (UILabel *)labelWithFrame:(CGRect)frame
                         text:(NSString *)text
                         font:(UIFont *)font
                        color:(UIColor *)color
                textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.textAlignment = textAlignment;
    return label;
}

- (void)setAttributedStringWithLineSpace:(CGFloat)lineSpace {
    [self setAttributedStringWithLineSpace:lineSpace FirstLineHeadIndent:0 rang:NSMakeRange(0, 0) rangColor:nil rangFont:nil];
}

- (void)setAttributedStringWithLineSpace:(CGFloat)lineSpace FirstLineHeadIndent:(CGFloat)FirstLineHeadIndent {
    [self setAttributedStringWithLineSpace:lineSpace FirstLineHeadIndent:FirstLineHeadIndent rang:NSMakeRange(0, 0) rangColor:nil rangFont:nil];
}

- (void)setAttributedStringRangStrings:(NSRange)rang rangColor:(UIColor*)rangColor {
    
    [self setAttributedStringWithLineSpace:0 FirstLineHeadIndent:0 rang:rang rangColor:rangColor rangFont:nil];
}

- (void)setAttributedStringRangStrings:(NSRange)rang rangColor:(UIColor*)rangColor rangFont:(UIFont*)rangFont {
    
    [self setAttributedStringWithLineSpace:0 FirstLineHeadIndent:0 rang:rang rangColor:rangColor rangFont:rangFont];
}

- (void)setAttributedStringWithLineSpace:(CGFloat)lineSpace rang:(NSRange)rang rangColor:(UIColor*)rangColor rangFont:(UIFont*)rangFont {
    
    [self setAttributedStringWithLineSpace:lineSpace FirstLineHeadIndent:0 rang:rang rangColor:rangColor rangFont:rangFont];
}

- (void)setAttributedStringWithLineSpace:(CGFloat)lineSpace FirstLineHeadIndent:(CGFloat)FirstLineHeadIndent rang:(NSRange)rang rangColor:(UIColor*)rangColor rangFont:(UIFont*)rangFont {
    
    if (!self.text || self.text.length<=0) {
        return;
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    if (!(lineSpace == 0 && FirstLineHeadIndent == 0)) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        
        [style setAlignment:self.textAlignment];
        
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        
        if (FirstLineHeadIndent != 0) {
            [style setFirstLineHeadIndent:FirstLineHeadIndent];
        }
        
        if (lineSpace != 0) {
            [style setLineSpacing:lineSpace];
        }
        
        [attributedText addAttribute:NSParagraphStyleAttributeName
                               value:style
                               range:NSMakeRange(0, [attributedText length])];
    }
    
    if (rangColor) {
        [attributedText addAttribute:NSForegroundColorAttributeName value:rangColor range:rang];
    }
    if (rangFont) {
        [attributedText addAttribute:NSFontAttributeName value:rangFont range:rang];
    }
    
    self.attributedText = attributedText;
}

@end
