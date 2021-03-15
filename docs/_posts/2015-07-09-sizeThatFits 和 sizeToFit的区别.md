---
layout: post
title:  "sizeThatFits 和 sizeToFit的区别"
date:   2015-07-09 19:52:13 +0800
categories:
 - Skills
tags:
 - OC
---
`sizeToFit`和 `sizeThatFits` 都是UIView的方法, 用来管理视图在父视图中的最佳大小(不包含对自己子视图的管理).如果没有父视图, 则根据 屏幕的 `bounds` 来进行调整。如果你需要 `view` 根据父视图来调整大小，就需要将 `view` 添加到父视图中。

当调用 `UIView` 的 `sizeToFit` 后, 会自动调用 `sizeThatFits` 方法来计算 `UIView` 最佳的 `bounds.size` 然后改变视图的 `frame.size`, 当然如果你不嫌麻烦可以先调用`sizeThatFits`计算出视图的最佳`size` 然后在给视图的`size`赋值,效果和直接调用 `sizeToFit` 是一样的, 代码如下

	// 或者给一个限定的宽度和高度 让 label 在这个范围内进行自适应 size
	    CGSize size = [label sizeThatFits:CGSizeMake([[UIScreen mainScreen] bounds].size.width, MAXFLOAT)];
	    CGRect rect = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, size.height);
	    [label setFrame:rect];


## 二者区别

- `sizeToFit`:会计算出最优的 size 而且会改变自己的size

- `sizeThatFits`会计算出最优的 size 但是不会改变 自己的 size

<mark>注意:苹果官方建议不要重载`sizeToFit`，如果你需要改变视图的默认尺寸信息，你可以重载 `sizeThatFits(_:)` 方法。在这个方法里面可以进行一些必要的计算并在这个方法中对计算的结果进行返回</mark>

## 使用场景

我们一般在不方便手动布局的时候才调用sizeToFit方法, 在一些系统自动布局的场合我们用sizeToFit就比较适合了,如下:

- navigationItem


- UIBarButtonItem的
- Label
- imageView

## 注意事项
- autolayout 约束过的 view 该方法失效       

- 调用  sizeToFit()  会去自动调用  sizeThatFits(_ size: CGSize) 方法。
- sizeToFit不应该在子类中被重写，应该重写sizeThatFits。
- sizeThatFits 传入的参数是receiver当前的size，返回一个适合子 view 的size。
- sizeToFit 可以被手动直接调用。
- sizeToFit 和 sizeThatFits方法都没有递归，对subviews也不负责，只负责自己。
- sizeThatFits 不会改变 receiver 的 size, 调用 sizeToFit() 会改变 receiver 的 size

## 联系方式

objc_china@163.com

