//
//  NSMutableAttributedString+Addition.h
//  Basic
//
//  Created by zhengmiaokai on 2018/7/6.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Addition)

+ (NSAttributedString *)attributedStringWithIcon:(NSString *)icon font:(UIFont *)font;

- (CGSize)contentSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
