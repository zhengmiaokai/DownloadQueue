//
//  UILabel+Category.h
//  Basic
//
//  Created by zhengmiaokai on 16/5/12.
//  Copyright © 2016年 zhengmiaokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)

/*工厂方法*/
+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                      color:(UIColor *)color
              textAlignment:(NSTextAlignment)textAlignment;

/*行距*/
- (void)setAttributedStringWithLineSpace:(CGFloat)lineSpace;

/*行距、首行缩进*/
- (void)setAttributedStringWithLineSpace:(CGFloat)lineSpace FirstLineHeadIndent:(CGFloat)FirstLineHeadIndent;

/*区间、区间颜色*/
- (void)setAttributedStringRangStrings:(NSRange)rang
                             rangColor:(UIColor*)rangColor;

/*区间、区间颜色、区间字体*/
- (void)setAttributedStringRangStrings:(NSRange)rang
                             rangColor:(UIColor*)rangColor rangFont:(UIFont*)rangFont;

/*行距、区间、区间颜色、区间字体*/
- (void)setAttributedStringWithLineSpace:(CGFloat)lineSpace rang:(NSRange)rang rangColor:(UIColor*)rangColor rangFont:(UIFont*)rangFont;

/*行距、首行缩进、区间、区间颜色、区间字体*/
- (void)setAttributedStringWithLineSpace:(CGFloat)lineSpace FirstLineHeadIndent:(CGFloat)FirstLineHeadIndent rang:(NSRange)rang rangColor:(UIColor*)rangColor rangFont:(UIFont*)rangFont;

@end
