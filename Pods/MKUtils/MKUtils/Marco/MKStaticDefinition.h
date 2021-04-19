//
//  definition.h
//  Basic
//
//  Created by zhengmiaokai on 16/3/22.
//  Copyright © 2016年 zhengmiaokai. All rights reserved.
//

#ifndef MKStaticDefinition_h
#define MKStaticDefinition_h

/* system */
#define kSystemVersion [UIDevice systemVersion]

/* image */
#define kDefaultImage [UIImage imageNamed:@""]

/* font */
#define kFont8          [UIFont systemFontOfSize:8]
#define kFont9          [UIFont systemFontOfSize:9]
#define kFont10         [UIFont systemFontOfSize:10]
#define kFont11         [UIFont systemFontOfSize:11]
#define kFont12         [UIFont systemFontOfSize:12]
#define kFont13         [UIFont systemFontOfSize:13]
#define kFont14         [UIFont systemFontOfSize:14]
#define kFont15         [UIFont systemFontOfSize:15]
#define kFont16         [UIFont systemFontOfSize:16]
#define kFont17         [UIFont systemFontOfSize:17]
#define kFont18         [UIFont systemFontOfSize:18]
#define kFont19         [UIFont systemFontOfSize:19]
#define kFont20         [UIFont systemFontOfSize:20]
#define kFont21         [UIFont systemFontOfSize:21]
#define kFont22         [UIFont systemFontOfSize:22]

#define kFont(num)  [UIFont systemFontOfSize:num]
#define kBFont(num) [UIFont boldSystemFontOfSize:num]

/* color */
#define kColor_White [UIColor whiteColor]

#define kColor(r,g,b,apha)  [UIColor colorWithR:r g:g b:b alpha:apha]

#define kHexColor(hexColor)  [UIColor colorWithHexString:hexColor]

#define RGB_HEX(rgbHexValue) [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbHexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbHexValue & 0xFF)) / 255.0 alpha:1.0]

/* Frame */
#define kScreenBounds  [[UIScreen mainScreen] bounds]

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

#define kNavigationBarHeight  (kStatusBarHeight + 44.0f)

#define kTabbarHeight  (isNotchScreen ? 83.0f : 49.0f)

#define kScreenScale  [[UIScreen mainScreen] scale]

/*
#if DEBUG

#elif RELEASE

#else

#endif
 */

#endif /* MKStaticDefinition_h */
