//
//  KSHeader.h
//  KSPageView
//
//  Created by 范云飞 on 2020/1/16.
//  Copyright © 2020 范云飞. All rights reserved.
//

#ifndef KSHeader_h
#define KSHeader_h

#ifdef DEBUG
    #define NSLog(...) NSLog(__VA_ARGS__);
#else
    #define NSLog(...)
#endif

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define DEVICE_WIDTH MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)
#define DEVICE_HEIGHT MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

#define TRANS_VALUE(x)  ceil(x*MIN(SCREEN_WIDTH,SCREEN_HEIGHT)/750.0)
#define TRANS_VALUE2(x) ceil(x*MIN(SCREEN_WIDTH,SCREEN_HEIGHT)/375.0)

#define  IS_IPhone5 (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size)
#define  IS_IPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size)  || CGSizeEqualToSize(CGSizeMake(414.f, 896.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(896.f, 414.f), [UIScreen mainScreen].bounds.size))

#define SafeArea_TopBarHeight    (IS_IPhoneX ? 88.f : 64.f)
#define SafeArea_StatusBarHeight (IS_IPhoneX ? 44 : 20)
#define SafeArea_TabbarBarHeight (IS_IPhoneX ? 83 : 49)
#define SafeArea_BottomMargin    (IS_IPhoneX ? 34.f : 0.f)
#define SafeArea_TopMargin       (IS_IPhoneX ? 24.f : 0.f)

#define HexColor(hexString) [UIColor colorWithHexString:hexString]

#define ZYIsNullOrEmpty(str)            ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1)


#endif /* KSHeader_h */
