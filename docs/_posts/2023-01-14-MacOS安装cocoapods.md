---
layout: post
title:  "MacOS安装cocoapods"
date:   2023-01-14
categories:
 - Turorial
tags:
 - Skills
---

## MacOS安装cocoapods

1. ### 安装brew

```
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
```

2. ### 安装ruby

   brew install ruby

3. ### 更换Ruby镜像

   先移除现在的镜像
   终端输入：
   `gem sources --remove https://rubygems.org/`

   然后替换成现在大中华地区可用的(taobao的那个镜像已经不好用了)
   `gem sources -a https://gems.ruby-china.com/`

   执行完之后查看是否替换成功
   `gem sources -l`
   输出结果

   

   ```cpp
   *** CURRENT SOURCES ***
   https://gems.ruby-china.org/
   ```

   说明替换成功

4. ### 安装cocoapods

   终端输入：
   `sudo gem install -n /usr/local/bin cocoapods` 或者`sudo gem install cocoapods -n /usr/local/bin`

   之后在执行
   `pod setup`
   输出

   

   ```bash
   Setting up CocoaPods master repo
     $ /usr/bin/git clone https://github.com/CocoaPods/Specs.git master --progress
     Cloning into 'master'...
     remote: Counting objects: 2038413, done.        
     remote: Compressing objects: 100% (6489/6489), done.        
     Receiving objects:  11% (239182/2038413), 47.75 MiB | 2.00 KiB/s
   ```

   这是一个漫长的等待。。。

5. ### 如何卸载cocoapods

   终端输入：
   `sudo gem uninstall cocoapods`

6. ### 拉取cocoapods仓库

   ## Cloning spec repo `cocoapods` 卡住

   cocoaPod安装完之后， 第一次进行`pod install`操作。可能会出现卡住不动或者的情况，只是由于cocoapPod安装好了， 但是必要的资源还没准备好，后台在默默的下载，具体大小，可根据[git的api](https://links.jianshu.com/go?to=https%3A%2F%2Fapi.github.com%2Frepos%2FCocoaPods%2FSpecs)中的size查看

   

   ```jsx
   Cloning spec repo `cocoapods` from `https://github.com/CocoaPods/Specs.git`
   [!] Unable to add a source with url `https://github.com/CocoaPods/Specs.git` named `cocoapods`.
   You can try adding it manually in `/Users/98-elden/.cocoapods/repos` or via `pod repo add`.
   ```

   解决办法：
   1、去[git仓库下载](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2FCocoaPods%2FSpecs)好资源，倒入本地文件夹下`.cocoapods/repos/cocoapods/`
   [解决方法来源](https://links.jianshu.com/go?to=https%3A%2F%2Fblog.csdn.net%2FMorris_%2Farticle%2Fdetails%2F105492447)

   ![img](https:////upload-images.jianshu.io/upload_images/5955701-877577cc0ba714d5.png?imageMogr2/auto-orient/strip|imageView2/2/w/733)

   

   ### 问题

   homebrew安装好之后homebrew-core文件夹里面是空的

   sudo git clone git://mirrors.ustc.edu.cn/homebrew-core.git/  /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
