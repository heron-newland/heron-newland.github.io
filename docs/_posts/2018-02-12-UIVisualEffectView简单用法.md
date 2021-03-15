---
layout: post
title:  "UIVisualEffectView简单用法"
date:   2018-02-12 10:32:03
categories:
 - Tutorial
tags:
 - OC
---

通常要想创建一个特殊效果(如blur效果)，可以创建一个`UIVisualEffectView`视图对象，这个对象提供了一种简单的方式来实现复杂的视觉效果。<b style = "color: red">这个可以把这个对象看作是效果的一个容器，实际的效果会影响到该视图对象底下的内容，对添加到该视图对象的`contentView`中的内容不会有模糊效果。</b>

<!--more-->

我们举个例子来看看如果使用`UIVisualEffectView`：

	//背景图
	let bgView: UIImageView = UIImageView(image: UIImage(named: "visual"))
	bgView.frame = self.view.bounds
	self.view.addSubview(bgView)
	//模糊效果
	let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
	let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
	blurView.frame = CGRectMake(50.0, 50.0, self.view.frame.width - 100.0, 200.0)
	self.view.addSubview(blurView)

这段代码是在当前视图控制器上添加了一个`UIImageView`作为背景图。然后在视图的一小部分中使用了`blur`效果。

我们可以看到`UIVisualEffectView`还是非常简单的。需要注意是的，不应该直接添加子视图到`UIVisualEffectView`视图中，而是应该添加到`UIVisualEffectView`对象的`contentView`中。

>另外，尽量避免将`UIVisualEffectView`对象的`alpha`值设置为小于1.0的值，因为创建半透明的视图会导致系统在离屏渲染时去对UIVisualEffectView对象及所有的相关的子视图做混合操作。这不但消耗CPU/GPU，也可能会导致许多效果显示不正确或者根本不显示。

我们在上面看到，初始化一个`UIVisualEffectView`对象的方法是`UIVisualEffectView(effect: blurEffect)`，其定义如下：

`init(effect effect: UIVisualEffect)`
这个方法的参数是一个UIVisualEffect对象。我们查看官方文档，可以看到在UIKit中，定义了几个专门用来创建视觉特效的，它们分别是UIVisualEffect、UIBlurEffect和UIVibrancyEffect。它们的继承层次如下所示：

	NSObject
	| -- UIVisualEffect
	    | -- UIBlurEffect
	    | -- UIVibrancyEffect
	    
    
`UIVisualEffect`是一个继承自`NSObject`的创建视觉效果的基类，然而这个类除了继承自`NSObject`的属性和方法外，没有提供任何新的属性和方法。其主要目的是用于初始化`UIVisualEffectView`，在这个初始化方法中可以传入`UIBlurEffect`或者`UIVibrancyEffect`对象。

一个`UIBlurEffect`对象用于将`blur`(毛玻璃)效果应用于`UIVisualEffectView`视图下面的内容。如上面的示例所示。不过，这个对象的效果并不影响`UIVisualEffectView`对象的`contentView`中的内容。

`UIBlurEffect`主要定义了三种效果，这些效果由枚举`UIBlurEffectStyle`来确定，该枚举的定义如下：

	//iOS10 以后新增了三种效果, 可以试试
	enum UIBlurEffectStyle : Int {
	    case ExtraLight
	    case Light
	    case Dark
	}
	


与`UIBlurEffect`不同的是，`UIVibrancyEffect`主要用于放大和调整`UIVisualEffectView`视图下面的内容的颜色，同时让`UIVisualEffectView`的`contentView`中的内容看起来更加生动。通常`UIVibrancyEffect`对象是与`UIBlurEffect`一起使用，主要用于处理在`UIBlurEffect`特效上的一些显示效果。接上面的代码，我们看看在`blur`的视图上添加一些新的特效，如下代码所示：

	let vibrancyView: UIVisualEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
	vibrancyView.setTranslatesAutoresizingMaskIntoConstraints(false)
	blurView.contentView.addSubview(vibrancyView)
	var label: UILabel = UILabel()
	label.setTranslatesAutoresizingMaskIntoConstraints(false)
	label.text = "Vibrancy Effect"
	label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
	label.textAlignment = .Center
	label.textColor = UIColor.whiteColor()
	vibrancyView.contentView.addSubview(label)


`vibrancy`特效是取决于颜色值的。所有添加到`contentView`的子视图都必须实现`tintColorDidChange`方法并更新自己。需要注意的是，我们使用`UIVibrancyEffect(forBlurEffect:)`方法创建`UIVibrancyEffect`时，参数`blurEffect`必须是我们想加效果的那个`blurEffect`，否则可能不是我们想要的效果。

另外，`UIVibrancyEffect`还提供了一个类方法`notificationCenterVibrancyEffect`，其声明如下：

`class func notificationCenterVibrancyEffect() -> UIVibrancyEffect!`
这个方法创建一个用于通知中心的Today扩展的vibrancy特效。

参考

	UIVisualEffectView Class Reference
	
	UIVisualEffect Class Reference
	
	UIBlurEffect Class Reference
	
	UIVibrancyEffect Class Reference
	
	UIVisualEffect – Swift Tutorial
	
	iOS 8: UIVisualEffect

