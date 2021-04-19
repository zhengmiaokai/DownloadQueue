//
//  NSString+Module.h
//  Basic
//
//  Created by zhengmiaokai on 2018/6/21.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
// 业务

#import <Foundation/Foundation.h>

@interface NSString (Module)

/** 验证邮箱
 */
- (BOOL)isValidateEmail;

/** 验证手机号码
 */
- (BOOL)isValidatePhoneNumber;

/** 验证身份证
 */
- (BOOL)isValidateIdentityCard;

@end
