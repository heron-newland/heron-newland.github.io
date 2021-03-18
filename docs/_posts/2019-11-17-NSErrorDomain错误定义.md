---
layout: post
title:  NSErrorDomain错误码及其说明
date:   2019-11-17 17:32:53 +0800
categories:
 - Tools
tags:
 - Skills
---

下面是NSErrorDomain错误码以及其对应的解释，方便查阅。

<!--more-->

```objective-c
/ * NSError NSCocoaErrorDomain代码。注意,其他框架(如AppKit和CoreData)也提供额外NSCocoaErrorDomain错误代码。* /

NS_ENUM(NSInteger){
/ /文件系统和文件I / O相关的错误,与NSFilePathErrorKey或NSURLErrorKey包含路径或
URLNSFileNoSuchFileError = 4 / /企图做一个文件系统操作在一个不存在的文件NSFileLockingError = 255,/ /无法锁定文件NSFileReadUnknownError = 256 / /读取错误(原因未知)
NSFileReadNoPermissionError = 257,/ /读取错误(权限问题)
NSFileReadInvalidFileNameError = 258 / /读取错误(无效的文件名)
NSFileReadCorruptFileError = 259,/ /读取错误(文件腐败、糟糕的格式等)
NSFileReadNoSuchFileError = 260,/ /读取错误(没有这样的文件)
NSFileReadInapplicableStringEncodingError = 261,/ /读取错误也NSStringEncodingErrorKey(字符串编码不适用)
NSFileReadUnsupportedSchemeError = 262,/ /读取错误(不支持的URL方案)
NSFileReadTooLargeError NS_ENUM_AVAILABLE(10 _5 2 _0)= 263 / /读取错误(文件太大)
NSFileReadUnknownStringEncodingError NS_ENUM_AVAILABLE(10 _5 2 _0)= 264 / /读取错误(字符串编码的文件内容不能确定)
NSFileWriteUnknownError = 512 / /写错误(原因未知)
NSFileWriteNoPermissionError = 513,/ /写错误(权限问题)
NSFileWriteInvalidFileNameError = 514 / /写错误(无效的文件名)
NSFileWriteFileExistsError NS_ENUM_AVAILABLE(10 _7,5 _0)= 516,/ /写错误(文件存在)
NSFileWriteInapplicableStringEncodingError = 517,/ /写错误也NSStringEncodingErrorKey(字符串编码不适用)
NSFileWriteUnsupportedSchemeError = 518 / /写错误(不支持的URL方案)
NSFileWriteOutOfSpaceError = 640 / /写错误(磁盘空间)
NSFileWriteVolumeReadOnlyError NS_ENUM_AVAILABLE(10 _6 4 _0)= 642 / /写错误(只读的体积)/ / NSFileManager卸载错误
NSFileManagerUnmountUnknownError NS_ENUM_AVAILABLE(10 _11,NA)= 768 / /音量不能卸载(原因未知)
NSFileManagerUnmountBusyError NS_ENUM_AVAILABLE(10 _11,NA)= 769 / /音量不能卸载,因为它是在使用中/ /其他错误
NSKeyValueValidationError = 1024,/ /现有的验证错误
NSFormattingError = 2048,/ /格式错误
NSUserCancelledError = 3072 / /用户取消操作(这个通常不值得一个面板和可能是一个不错的一个特例)
NSFeatureUnsupportedError NS_ENUM_AVAILABLE(10 _8 6 _0)= 3328 / /功能不支持的错误/ /可执行文件加载错误
NSExecutableNotLoadableError NS_ENUM_AVAILABLE(10 _5 2 _0)= 3584 / /可执行的类型不是可加载在当前过程
NSExecutableArchitectureMismatchError NS_ENUM_AVAILABLE(10 _5 2 _0)= 3585 / /可执行文件没有提供一个架构兼容当前进程
NSExecutableRuntimeMismatchError NS_ENUM_AVAILABLE(10 _5 2 _0)= 3586 / /可执行目标C运行时信息不符合当前进程
NSExecutableLoadError NS_ENUM_AVAILABLE(10 _5 2 _0)= 3587 / /可执行不能加载因为一些其他的原因,比如它取决于问题库
NSExecutableLinkError NS_ENUM_AVAILABLE(10 _5 2 _0)= 3588 / /可执行失败由于连接问题/ /包容性的误差范围定义,对未来检查错误代码
NSFileErrorMinimum = 0,
NSFileErrorMaximum = 1023,
NSValidationErrorMinimum = 1024,
NSValidationErrorMaximum = 2047,
NSExecutableErrorMinimum NS_ENUM_AVAILABLE(10 _5 2 _0)= 3584,
NSExecutableErrorMaximum NS_ENUM_AVAILABLE(10 _5 2 _0)= 3839,
NSFormattingErrorMinimum = 2048,
NSFormattingErrorMaximum = 2559,
NSPropertyListReadCorruptError NS_ENUM_AVAILABLE(10 _6 4 _0)= 3840 / /错误解析属性列表
NSPropertyListReadUnknownVersionError NS_ENUM_AVAILABLE(10 _6 4 _0)= 3841 / /属性列表中的版本号是未知的
NSPropertyListReadStreamError NS_ENUM_AVAILABLE(10 _6 4 _0)= 3842 / /流错误阅读属性列表
NSPropertyListWriteStreamError NS_ENUM_AVAILABLE(10 _6 4 _0)= 3851 / /流错误写属性列表
NSPropertyListWriteInvalidError NS_ENUM_AVAILABLE(10 _10 8 _0)= 3852 / /无效的属性列表对象时指定的或无效的属性列表类型写作
NSPropertyListErrorMinimum NS_ENUM_AVAILABLE(10 _6 4 _0)= 3840,
NSPropertyListErrorMaximum NS_ENUM_AVAILABLE(10 _6 4 _0)= 4095,
NSXPCConnectionInterrupted NS_ENUM_AVAILABLE(10 _8 6 _0)= 4097,
NSXPCConnectionInvalid NS_ENUM_AVAILABLE(10 _8 6 _0)= 4099,
NSXPCConnectionReplyInvalid NS_ENUM_AVAILABLE(10 _8 6 _0)= 4101,
NSXPCConnectionErrorMinimum NS_ENUM_AVAILABLE(10 _8 6 _0)= 4096,
NSXPCConnectionErrorMaximum NS_ENUM_AVAILABLE(10 _8 6 _0)= 4224,
NSUbiquitousFileUnavailableError NS_ENUM_AVAILABLE(10 _9 7 _0)= 4353 / / NSURLUbiquitousItemDownloadingErrorKey与此代码包含一个错误时,项目还没有上传到iCloud的其他设备
NSUbiquitousFileNotUploadedDueToQuotaError NS_ENUM_AVAILABLE(10 _9 7 _0)= 4354 / / NSURLUbiquitousItemUploadingErrorKey与此代码包含一个错误时,项目还没有上传到iCloud,因为这将让帐户
NSUbiquitousFileUbiquityServerNotAvailable NS_ENUM_AVAILABLE(10 _9 7 _0)= 4355 / / NSURLUbiquitousItemDownloadingErrorKey NSURLUbiquitousItemUploadingErrorKey包含一个错误的代码当连接到iCloud服务器失败
NSUbiquitousFileErrorMinimum NS_ENUM_AVAILABLE(10 _9 7 _0)= 4352,
NSUbiquitousFileErrorMaximum NS_ENUM_AVAILABLE(10 _9 7 _0)= 4607,
NSUserActivityHandoffFailedError NS_ENUM_AVAILABLE(10 _10 8 _0)= 4608 / /没有用户活动的数据(例如,如果远程设备成为不可用。)
NSUserActivityConnectionUnavailableError NS_ENUM_AVAILABLE(10 _10 8 _0)= 4609 / /用户活动无法继续下去,因为需要连接不可用
NSUserActivityRemoteApplicationTimedOutError NS_ENUM_AVAILABLE(10 _10 8 _0)= 4610 / /远程应用程序未能及时发送数据
NSUserActivityHandoffUserInfoTooLargeError NS_ENUM_AVAILABLE(10 _10 8 _0)= 4611 / / NSUserActivity用户信息字典太大
NSUserActivityErrorMinimum NS_ENUM_AVAILABLE(10 _10 8 _0)= 4608,
NSUserActivityErrorMaximum NS_ENUM_AVAILABLE(10 _10 8 _0)= 4863,
NSCoderReadCorruptError NS_ENUM_AVAILABLE(10 _11 9 _0)= 4864 / /在解码错误解析数据
NSCoderValueNotFoundError NS_ENUM_AVAILABLE(10 _11 9 _0)= 4865 / /数据请求的文件不存在NSCoderErrorMinimum NS_ENUM_AVAILABLE(10 _11 9 _0)= 4864,
NSCoderErrorMaximum NS_ENUM_AVAILABLE(10 _11 9 _0)= 4991,
NSBundleErrorMinimum NS_ENUM_AVAILABLE(10 _11 9 _0)= 4992,
NSBundleErrorMaximum NS_ENUM_AVAILABLE(10 _11 9 _0)= 5119,
NSBundleOnDemandResourceOutOfSpaceError NS_ENUM_AVAILABLE(NA,9 _0)= 4992 / /没有足够的可用空间下载请求的资源的需求。
NSBundleOnDemandResourceExceededMaximumSizeError NS_ENUM_AVAILABLE(NA,9 _0)= 4993 / /应用程序超出了需求资源的内容使用一次
NSBundleOnDemandResourceInvalidTagError NS_ENUM_AVAILABLE(NA,9 _0)= 4994 / /应用程序指定一个标签系统找不到应用程序标记清单};
```

