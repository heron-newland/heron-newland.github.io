---
layout: post
title:  "UIPageViewController"
date:   2018-8-30 10:10:03
categories:
 - UI
tags:
 - Swift
---

由于app的定制化需求越来越高, 根据不同场景使用不同字体也逐渐流行起来, 本文主要介绍几种常用字体格式以及其在iOS开发中的用法.

<!--more-->


### 字体格式简介

目前主流字体有三种后缀格式，分别为：`ttc/ttf/otf`

* **TTF**是apple和微软共同推出的字体文件格式，只有一种字型。

* **TTC**是几个TTF合成的字库，安装后字体列表中会看到两个以上的字体。两个字体中大部分字都一样时，可以将两种字体做成一个TTC文件，现在常见的TTC中的不同字体，汉字一般没有差别，只是英文符号的宽度不一样，以便适应不同的版面要求。

    虽然都是字体文件，但.ttc是microsoft开发的新一代字体格式标准，可以使多种truetype字体共享同一笔划信息，有效地节省了字体文件所占空间，增加了共享性。但是有些软件缺乏对这种格式字体的识别，使得ttc字体的编辑产生困难。

* **OTF**是TTF的升级版，支持更高级特性的字体。


### 下载自定义字体

很多网站都有字体下载, 比如 [字体吧](http://ziti8.cc/fonts/1057.htm), 有些以中文名称命名的字体下载下来之后文件名可能会出现乱码, 可以重新命名,最好以下载时字体的汉字名称的汉语拼音命名, 比如 `文鼎彩云`你可命名为 `wendingcaiyun`到时候查找自己自定义字体的时候会好找一些.

### 将自定义字体引入工程

下载好之后将 `.ttf/.ttc/.otf` 格式的文件拖入工程中(注意: 有些字体下载之后是压缩格式, 要先解压之后在将 `.ttf/.ttc/.otf`文件拖入工程)

### 配置项目的info.plist文件
在info.plist中添加 key 值为 `Fonts provided by application `的 key,值为一个数组, 将拖入工程的`.ttf/.ttc/.otf`字体格式名称填入(注意:名称一定要和拖入工程中的文件名称一致), 如下图所示:

	
![图片1](/assets/images/font.png)

### 打印所有的字体,找到自己导入的字体的名称

	  for fontFamilyName in UIFont.familyNames{
	            print("family:\(fontFamilyName)")
	            for font in UIFont.fontNames(forFamilyName: fontFamilyName) {
	                print("\nfont:\(font)")
	            }
	            print("-----------")
	        }

注意: 打印的字体名称和你导入的字体的文件名不一定相同, 但是大致差不多, 比如 `文鼎彩云`我重命名为 `wendingcaiyun`,然后控制台打印出来是:`ARTXCaiYunGB-UL`

### 使用自定义字体

		//使用`文鼎彩云`
        nameLabel.font = UIFont(name: "ARTXCaiYunGB-UL", size: 16)

