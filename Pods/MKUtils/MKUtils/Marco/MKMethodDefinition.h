//
//  DynamicDefinition.h
//  Basic
//
//  Created by zhengmiaokai on 2018/7/26.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#ifndef MKMethodDefinition_h
#define MKMethodDefinition_h

#import "MKMetaDefinition.h"

/* methond */
#define MKString(...)  [NSString stringWithFormat:__VA_ARGS__]

#define MKSMutableString(...)  [NSMutableString stringWithFormat:__VA_ARGS__]

#define DLog(s, ...) [MKBaseLog file:__FILE__ function: (char *)__FUNCTION__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

///weakify
#define weakify(...) \
rac_keywordify \
metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)

///strongify
#define strongify(...) \
rac_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
metamacro_foreach(rac_strongify_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")

#endif /* MKMethodDefinition_h */
