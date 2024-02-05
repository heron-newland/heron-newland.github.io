---
layout: post
title:  "CocoaLumberjack"
date:   2022-03-06
categories:
 - Turorial
tags:
 - Skills
---


# CocoaLumberjack


### CocoaLumberjack这个框架是做什么的？

CocoaLumberjack是Mac和iOS上一个集快捷、简单、强大和灵活于一身的日志框架。CocoaLumberjack类似于流行 的日志框架（如log4j），但它是专为Objective-C设计的，利用了多线程、GCD（如果可用）、无锁原子操作Objective-C运行时的 动态特性。

### CocoaLumberjack 它的优点有哪些? 

- 快速

在大多数用例中，Lumberjack比NSLog快了一个数量级。

- 简单

当应用程序启动时，只需一行加单的代码就可配置Lumberjack。然后用DDLog语句简单地取代NSLog语句，使用方法与NSLog完全一样

- 灵活性

配置你自己想要的日志框架。修改每个文件的日志级别（尤其是测试时）。修改每个logger的日志级 别（详细的控制台，但是简洁的日志文件）。修改每个Xcode配置的日志级别。为你的应用程序定制日志级别的数量。添加自己的精细的日志。在运行时动态修 改日志级别。 选择如何以及何时回滚你的日志文件。将日志文件上传至中心服务器。压缩存档日志文件来节省硬盘空间，一个日志语句可以被发送到多个logger，意味着你可以同时记录文件和控制台。此外，还可以创建自己的logger，将日志语句发送到网络、数据库或者分布式文件系统中，日志保存方法十分灵活。



### CocoaLumberjack的使用场景

1.跟踪在程序中不断出现的不可复制的bug；

2.对原声的系统日志感到失望

3.出于支持系统和稳定性的需要，你想将应用程序升级到下一级别；

4.为你的应用程序（Mac或者iPhone）寻找企业级的日志解决方案。

5.自定义日志级别，查看对应安全级别的日志。

### [安装方式请参考](https://github.com/CocoaLumberjack/CocoaLumberjack)

