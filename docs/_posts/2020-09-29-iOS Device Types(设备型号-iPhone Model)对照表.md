---
layout: post
title: iOS Device Types(设备型号:iPhone Model)对照表
date:  2020-08-23 10:10:03
categories:
 - tutorial
tags:
 - Skills
---

在开发过程中,我们无法通过代码去获取设备的名称, 例如` iPhone 12 mini` 我们只能多去到对应的设备类型为:`iPhone13,1`,所以我们经常需要做一些转换操作,下面是设备名称和设备类型的对照表. 需要注意的是,在使用模拟器的时候我们无法获取到准确的设备名称,所以我们在使用设备名称作为判断条件的时候最好是能配合模拟器和真机的宏`TARGET_IPHONE_SIMULATOR`和`TARGET_OS_IPHONE`使用.例如



```objective-c
#if TARGET_OS_IPHONE
if([self.currentDevice isEqualToString:@"iPhone 12 mini"]) {
	//真机逻辑
}
#elif TARGET_OS_IPHONE
	//模拟器逻辑
#endif
```



### 一、模拟器:

模拟器没有具体的设备型号,根据苹果机器的cpu类型是有两种设备型号, 现在基本都是x86_64.

| DEVICE TYPE | PRODUCT NAME     |
| ----------- | ---------------- |
| i386        | iPhone Simulator |
| x86_64      | iPhone Simulator |

### 二、真机:

| DEVICE TYPE | PRODUCT NAME                      |
| ----------- | --------------------------------- |
| iPhone1,1   | iPhone                            |
| iPhone1,2   | iPhone 3G                         |
| iPhone2,1   | iPhone 3GS                        |
| iPhone3,1   | iPhone 4 (GSM)                    |
| iPhone3,3   | iPhone 4 (CDMA)                   |
| iPhone4,1   | iPhone 4S                         |
| iPhone5,1   | iPhone 5 (A1428)                  |
| iPhone5,3   | iPhone 5c (A1456/A1532)           |
| iPhone5,4   | iPhone 5c (A1507/A1516/A1529)     |
| iPhone6,1   | iPhone 5s (A1433/A1453)           |
| iPhone6,2   | iPhone 5s (A1457/A1518/A1530)     |
| iPhone5,2   | iPhone 5 (A1429)                  |
| iPhone7,1   | iPhone 6 Plus                     |
| iPhone7,2   | iPhone 6                          |
| iPhone8,1   | iPhone 6s                         |
| iPhone8,2   | iPhone 6s Plus                    |
| iPhone8,4   | iPhone SE                         |
| iPhone9,1   | iPhone 7 (A1660/A1779/A1780)      |
| iPhone9,2   | iPhone 7 Plus (A1661/A1785/A1786) |
| iPhone9,3   | iPhone 7 (A1778)                  |
| iPhone9,4   | iPhone 7 Plus (A1784)             |
| iPhone10,1  | iPhone 8 (A1863/A1906)            |
| iPhone10,2  | iPhone 8 Plus (A1864/A1898)       |
| iPhone10,3  | iPhone X (A1865/A1902)            |
| iPhone10,4  | iPhone 8 (A1905)                  |
| iPhone10,5  | iPhone 8 Plus (A1897)             |
| iPhone10,6  | iPhone X (A1901)                  |
| iPhone11,2  | iPhone XS                         |
| iPhone11,4  | iPhone XS Max China               |
| iPhone11,6  | iPhone XS Max                     |
| iPhone11,8  | iPhone XR                         |
| iPhone12,1  | iPhone 11                         |
| iPhone12,3  | iPhone 11 Pro                     |
| iPhone12,5  | iPhone 11 Pro Max                 |
| iPhone13,1  | iPhone 12 mini                    |
| iPhone13,2  | iPhone 12                         |
| iPhone13,3  | iPhone 12 Pro                     |
| iPhone13,4  | iPhone 12 Pro Max                 |

三, 判断示例代码

```objective-c
#import <sys/utsname.h>//要导入头文件

+ (NSString *)getCurrentDeviceModel{
   struct utsname systemInfo;
   uname(&systemInfo);
   
   NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
      
  if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
  if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
  if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
  if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
  if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
  if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
  if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
  if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
  if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
  if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
  if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
  if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
  // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
  if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
  if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
  if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
  if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
  if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
  if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
  if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
  if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
  if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
  if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
  if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
  if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
  if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
  if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
  if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
  if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
  if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
  if ([deviceModel isEqualToString:@"iPhone12,8"])   return @"iPhone SE2";
  if ([deviceModel isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
  if ([deviceModel isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
  if ([deviceModel isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
  if ([deviceModel isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
  if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
  if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
  if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
  if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
  if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
  if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
  if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
  if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
  if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
  if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
  if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
  if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
  if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
  if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
  if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
  if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
  if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
  if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
  if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
  if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
  if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
  if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
  if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
  if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
  if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
  if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
  if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
  if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
  if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
  if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
  if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
  if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
  if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";

  if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
  if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
  if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
  if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";

  if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
  if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
      return deviceModel;
  }
```



### 参考资料

- [点击查看iOS Device Types(设备型号:iPhone Model)对照表最新最全的信息](https://www.theiphonewiki.com/wiki/Models)



我的邮箱:mailto:objc_china@163.com

