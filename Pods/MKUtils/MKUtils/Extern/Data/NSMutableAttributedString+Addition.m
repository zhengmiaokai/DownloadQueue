//
//  NSMutableAttributedString+Addition.m
//  Basic
//
//  Created by zhengmiaokai on 2018/7/6.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#import "NSMutableAttributedString+Addition.h"

@implementation NSMutableAttributedString (Addition)

+ (NSAttributedString *)attributedStringWithIcon:(NSString *)icon font:(UIFont *)font {
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
    
    UIImage *img = [UIImage imageNamed:icon];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    
    attachment.image = img;
    attachment.bounds = CGRectMake(0, 0, font.lineHeight, font.lineHeight);
    
    [attri appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    [attri addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attri.length)];
    
    return [attri copy];
}

- (CGSize)contentSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    
    [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    
    CGSize result = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return result;
}



@end
