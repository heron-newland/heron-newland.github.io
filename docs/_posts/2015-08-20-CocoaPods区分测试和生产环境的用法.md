---
layout: post
title:  "CocoaPods区分测试和生产环境的用法"
date:   2015-08-20 19:52:13 +0800
categories:
 - Tool
tags:
 - OC
---

通产我们会使用一些辅助开发工具, 但是在生产环境时我们又不需要.但是`CocoaPods`有无法使用宏定义来区分生产和测试环境,如果手动去配置, 那么需要不断使用 `pod install`来安装和删除这些工具, 非常麻烦. 下面就介绍一种方式能让CocoaPods根据不同的环境来正确管理依赖库: `:configurations => ['Debug']`

比方说,我们在开发时会用的帧率检测工具, 但是生产时我们不需要那么我们可以使用如下方式:
	
	pod 'KMCGeigerCounter', :configurations => ['Debug']	