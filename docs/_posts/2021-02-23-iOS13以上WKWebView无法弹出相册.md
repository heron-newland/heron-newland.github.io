---
layout: post
title: iOS13以上WKWebView无法弹出相册
date:  2021-02-23 10:10:03
categories:
 - tutorial
tags:
 - Skills
---

弹出相册是H5和原生很常见的交互,并且H5的实现也非常简单, 正常情况下是没有问题的,但是如果webview添加到不合适的view,并且iOS系统版本在iOS13.0以上,就无法弹出. 下面就详细复现一下这个例子.

H5端的代码如下:

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<script type="text/javascript">
    function hahaha(argument) {
        // body...
        console.log("hahahah")
    }
</script>

<body>
<input accept='image/*' type='file' onclick="hahaha()">
</body>


```

那么我们将者段代码保存之后直接放在本地服务上做测试, 访问地址为`http://192,168.120.217/testH5.html`

iOS客户端的代码也很简单,就在控制器的ViewDidLoad方法中做如下实现:

 

```objective-c
WKWebView *web = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//错误写法
[UIApplication.sharedApplication.keyWindow addSubview:web];
//正确写法
//[self.view addSubview:web];

[web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192,168.120.217/testH5.html"]]];
```

可以看出正常的写法应该是将webview添加到控制器的view中,但是此处却添加到了keywindow中,这样写在iOS13以下的系统都能正常弹出相册选择(present方式弹出),但是到iOS13.0以上就无法弹出相册选择,因为iOS13以上版改变了相册弹出方式,相册弹出的位置改为跟随按钮,而不是统一从底部弹出.所以webview最好添加到当前活跃控制器的view上.

获取当前活跃控制器的方法如下:

```objective-c
- (UIViewController *)getCurrentViewController{
  UIViewController* currentViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
  BOOL runLoopFind = YES;
  while (runLoopFind) {
      if (currentViewController.presentedViewController) {
          currentViewController = currentViewController.presentedViewController;
      } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
          UINavigationController* navigationController = (UINavigationController* )currentViewController;
          currentViewController = [navigationController.childViewControllers lastObject];
  } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
      UITabBarController* tabBarController = (UITabBarController* )currentViewController;
      currentViewController = tabBarController.selectedViewController;
  } else {
        NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
        if (childViewControllerCount > 0) {
            currentViewController = currentViewController.childViewControllers.lastObject;
            return currentViewController;
        } else {
            return currentViewController;
        }
    }
  }
  return currentViewController;
}
```

