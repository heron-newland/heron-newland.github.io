---
layout: post
title:  "Core Graphics学习之路"
date:   2019-02-16 10:10:03
categories:
 - Skills
tags:
 - OC
---




Core Graphics是基于C的API，可以用于一切绘图。Quartz 2D是Core Graphics框架的一部分，是一个强大的二维图像绘制引擎。Quartz 2D在UIKit中也有很好的封装和集成，我们日常开发时所用到的UIKit中的组件都是由Core Graphics进行绘制的。不仅如此，当我们引入UIKit框架时系统会自动引入Core Graphics框架，并且为了方便开发者使用在UIKit内部还对一些常用的绘图API进行了封装。
不废话，直接来看利用Core Graphics怎么绘图。

<!--more-->

一般步骤

1、获取绘图上下文

2、创建并设置路径

3、将路径添加到上下文

4、设置上下文状态

5、绘制路径

图形上下文CGContextRef代表图形输出设备（也就是绘制的位置），包含了绘制图形的一些设备信息。Quartz 2D中所有对象都必须绘制在图形上下文. 

获取上下文有两种方式:

1. 在`drawRect`中可以直接获取;
2. 在`UIGraphicsBeginImageContext()`等手动开启上下文之后也能获取



### 线条

下面绘制的时一条实心红色实线

	- (void)drawLineWithContext:(CGContextRef)context{
	    CGMutablePathRef path = CGPathCreateMutable();
	    CGPathMoveToPoint(path, nil, 0, self.safeAreaInsets.top);
	    CGPathAddLineToPoint(path, nil, self.bounds.size.width, 300);
	    CGContextSetLineWidth(context, 8);
	    CGContextAddPath(context, path);
	    [UIColor.redColor setStroke];
	    CGContextDrawPath(context, kCGPathStroke);
	    //释放资源
	     CGPathRelease(path);
	}

下面时绘制一条带阴影的点划线

	- (void)drawDashLineWith:(CGContextRef)context{
	    CGMutablePathRef path = CGPathCreateMutable();
	    CGPathMoveToPoint(path, nil, self.bounds.size.width, self.safeAreaInsets.top);
	    CGPathAddLineToPoint(path, nil, 0, 300);
	    CGContextAddPath(context, path);
	    CGContextSetLineWidth(context, 6);
	    [UIColor.greenColor setStroke];
	    //画10个点, 空20个点, 画30个点,空40个点
	    CGFloat length[] = {10,20,30,40};
	    //最后一个参数表示取length中几个值来画点划线
	    //取值为0:画实线
	    //取值为1: 取length的第一个元素10, 然后画10个点, 空10个点,以此循环
	    //取值为2: 取length中的前两个元素(10,20), 画10个点, 空20个点,以此循环
	    CGContextSetLineDash(context, 0, length, 3);
	    CGColorSpaceRef colorSpace =  CGColorSpaceCreateDeviceRGB();
	    //components包含四个元素,分别为颜色的 R,G,B,A
	    CGFloat components[] = {255,0,255,1};//红色
	    CGColorRef color = CGColorCreate(colorSpace, components);
	    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 0.5, color);
	    CGContextDrawPath(context, kCGPathStroke);
	    //释放资源
	    CGColorSpaceRelease(colorSpace);
	    CGColorRelease(color);
	    CGPathRelease(path);
	}


UIKit已经为我们准备好了一个上下文，在drawRect:方法（这个方法在loadView、viewDidLoad方法后执行）中我们可以通过UIKit封装函数UIGraphicsGetCurrentContext()方法获得这个图形上下文
然后我们按照上面说的步骤一步一步的执行下来得到结果：

得到结果如图：

![划线]({{site.url}}/assets/images/coreGraphics/drawline.png)



### 图形绘制

矩形, 其他比如椭圆, 圆形, 扇形等方法类似

	- (void)drawShapWithContext:(CGContextRef)context{
	    CGContextAddRect(context, CGRectMake(self.originLocation.x, self.originLocation.y, self.currentlocation.x - self.originLocation.x, self.currentlocation.y - self.originLocation.y));
	    CGContextSetLineWidth(context, 4);
	    [UIColor.blackColor setStroke];
	    CGContextDrawPath(context, kCGPathStroke);  
	}

运行结果:

![划线]({{site.url}}/assets/images/coreGraphics/rect.png)


### 绘制贝塞尔曲线

在Quartz 2D中曲线绘制分为两种：二次贝塞尔曲线和三次贝塞尔曲线。二次曲线只有一个控制点，而三次曲线有两个控制点，如下图所示：

二次贝塞尔

	- (void)drawQuadBezielWithContext:(CGContextRef)context{
	    CGContextMoveToPoint(context, 10, 200);
	    /*
	     绘制二次贝塞尔曲线
	     c:图形上下文
	     cpx:控制点x坐标
	     cpy:控制点y坐标
	     x:结束点x坐标
	     y:结束点y坐标
	     */
	    CGContextAddQuadCurveToPoint(context, 100, 100, 200, 200);
	    [UIColor.redColor setStroke];
	     CGContextSetLineCap(context, kCGLineCapRound);
	    CGContextSetLineWidth(context, 6);
	    CGContextDrawPath(context, kCGPathStroke);
	    
	    CGContextSaveGState(context);
	    CGMutablePathRef path = CGPathCreateMutable();
	    CGPathMoveToPoint(path, nil, 10, 200);
	    CGPathAddLineToPoint(path, nil, 100, 100);
	    CGPathAddLineToPoint(path, nil, 200, 200);
	    CGContextAddPath(context, path);
	    [UIColor.lightGrayColor setStroke];
	    CGContextSetLineWidth(context, 2);
	    CGContextSetLineJoin(context, kCGLineJoinRound);
	    CGFloat length[] = {4};
	    CGContextSetLineDash(context, 0, length, 1);
	    CGContextDrawPath(context, kCGPathStroke);
	    CGContextRestoreGState(context);
	    
	    //释放资源
	    CGPathRelease(path);
	}

三次贝塞尔

	- (void)drawTriBezielWithContext:(CGContextRef)context{
	    CGContextMoveToPoint(context, 10, 500);
	    /*绘制三次贝塞尔曲线
	     c:图形上下文
	     cp1x:第一个控制点x坐标
	     cp1y:第一个控制点y坐标
	     cp2x:第二个控制点x坐标
	     cp2y:第二个控制点y坐标
	     x:结束点x坐标
	     y:结束点y坐标
	     */
	    CGContextAddCurveToPoint(context, 80, 200, 300, 600, 200, 500);
	    [UIColor.redColor setStroke];
	    CGContextSetLineWidth(context, 6);
	    CGContextDrawPath(context, kCGPathStroke);
	    
	    CGContextSaveGState(context);
	    CGMutablePathRef path = CGPathCreateMutable();
	    CGPathMoveToPoint(path, nil, 10, 500);
	    CGPathAddLineToPoint(path, nil, 80, 200);
	    CGPathMoveToPoint(path, nil, 300, 600);
	    CGPathAddLineToPoint(path, nil, 200, 500);
	    CGContextAddPath(context, path);
	    [UIColor.lightGrayColor setStroke];
	    CGContextSetLineWidth(context, 2);
	    CGContextSetLineJoin(context, kCGLineJoinRound);
	    CGContextSetLineCap(context, kCGLineCapRound);
	    CGFloat length[] = {4};
	    CGContextSetLineDash(context, 0, length, 1);
	    CGContextDrawPath(context, kCGPathStroke);
	    CGContextRestoreGState(context);
	    //释放资源
	    CGPathRelease(path);
	}

结果:

![贝塞尔]({{site.url}}/assets/images/coreGraphics/beziel.png)

### 文字绘制

Core Graphics不仅可以画图还能绘制文字, 能设置了绘制区间、字体颜色段落属性等 当然还可以设置更多其他属性,主要方法如下:
  	
  	//如下方法还有很多变种, 使用方法类似
  	 [str drawAtPoint:CGPointMake(10, 100) withAttributes:nil];


### 图像绘制

当然Core Graphics也能绘制图像,很简单

    UIImage *img = [UIImage imageNamed:@"xy-scale"];
    [img drawInRect:CGRectMake(10, 100, 100, 100)];



### 绘制渐变

Quartz 2D的渐变方式分为两种：

线性渐变线：渐变色以直线方式从开始位置逐渐向结束位置渐变

径向渐变：以中心点为圆心从起始渐变色向四周辐射，直到终止渐变色

在iOS中绘制渐变还需要注意一点就是指定颜色空间，所谓颜色空间就是不同颜色在不同的维度上取值最终组成一种颜色的过程。就拿RGB来说，如果将红色、绿色、蓝色看成是x、y、z轴坐标系，那么在三个坐标上分别取0~255范围内的不同值则可以组成各类颜色。当然，不同颜色空间的“坐标系”也是不同的（也就是说颜色表示的方式是不同的），常用的颜色空间除了RGB还有CMYK（印刷业常用这种颜色模式）、Gray

下面的代码分别演示了两种渐变方式，具体渐变绘制函数参数代码中已经注释的很清楚了：

#### 线性渐变


	- (void)drawLinerGradientWithContext:(CGContextRef)context{
	    //    CGContextSaveGState(context);
	    //使用rgb颜色空间
	   CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	    CGFloat components[] = {248.0/255.0,86.0/255.0,86.0/255.0,1,
	        249.0/255.0,127.0/255.0,127.0/255.0,1,
	        0,1.0,1.0,1.0};
	    CGFloat loactions[] = {0, 0.5,1};
	    /*
	     指定渐变色
	     space:颜色空间
	     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
	     如果有三个颜色则这个数组有4*3个元素
	     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
	     count:渐变个数，等于locations的个数
	     */
	   CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, loactions, 3);
	    /*
	     绘制线性渐变
	     context:图形上下文
	     gradient:渐变色
	     startPoint:起始位置
	     endPoint:终止位置
	     options:绘制方式,DrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
	     DrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
	     */
	    CGContextDrawLinearGradient(context, gradient, CGPointMake(100, 100), CGPointMake(200, 200), kCGGradientDrawsBeforeStartLocation);
	//    CGContextRestoreGState(context);
	    
	}

#### 径向渐变

	- (void)drawRadialGradientWithContext:(CGContextRef)context{
	    //使用rgb颜色空间
	    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	    CGFloat components[] = {248.0/255.0,86.0/255.0,86.0/255.0,1,
	        249.0/255.0,127.0/255.0,127.0/255.0,1,
	        0,1.0,1.0,1.0};
	    CGFloat loactions[] = {0, 0.5,1};
	    /*
	     指定渐变色
	     space:颜色空间
	     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
	     如果有三个颜色则这个数组有4*3个元素
	     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
	     count:渐变个数，等于locations的个数
	     */
	    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, loactions, 3);
	    /*
	     绘制线性渐变
	     context:图形上下文
	     gradient:渐变色
	     startPoint:起始位置
	     startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
	     endCenter:终点位置（通常和起始点相同，否则会有偏移）
	     endRadius:终点半径（也就是渐变的扩散长度）
	     options:绘制方式,DrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
	     DrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
	     */
	    CGContextDrawRadialGradient(context, gradient, CGPointMake(300, 400), 0, CGPointMake(300, 400), 100, kCGGradientDrawsBeforeStartLocation);
	}

运行效果

![渐变]({{site.url}}/assets/images/coreGraphics/gradient.png)


### 叠加模式

使用Quartz 2D绘图时后面绘制的图像会覆盖前面的，默认情况下如果前面的被覆盖后将看不到后面的内容，但是有时候这个结果并不是我们想要的，因此在Quartz 2D中提供了填充模式供开发者配置调整。由于填充模式类别特别多。
因此下面以一个例子来说明：

	- (void)drawRect:(CGRect)rect {
	    // Drawing code
	    CGContextRef context = UIGraphicsGetCurrentContext();
	    CGContextSaveGState(context);
	    CGRect rect0 = CGRectMake(20, 0, 150, self.bounds.size.height);


​	    
	    NSMutableArray *arr0 = [NSMutableArray array];
	    for (int i = 0; i<28; i++) {
	        CGRect rect = CGRectMake(190, self.safeAreaInsets.top + i * 25, 10, 250);
	        [arr0 addObject:@(rect)];
	    }
	    
	    NSArray *nameStrs = @[
	                          @"kCGBlendModeNormal",
	                          @"kCGBlendModeMultiply",
	                          @"kCGBlendModeScreen",
	                          @"kCGBlendModeOverlay",
	                          @"kCGBlendModeDarken",
	                          @"kCGBlendModeLighten",
	                          @"kCGBlendModeColorDodge",
	                          @" kCGBlendModeColorBurn",
	                          @"kCGBlendModeSoftLight",
	                          @"kCGBlendModeHardLight",
	                          @"kCGBlendModeDifference",
	                          @"kCGBlendModeExclusion",
	                          @"kCGBlendModeHue",
	                          @"kCGBlendModeSaturation",
	                          @"kCGBlendModeColor",
	                          @"kCGBlendModeLuminosity",
	                          @"kCGBlendModeClear",
	                          @"kCGBlendModeCopy",
	                          @"kCGBlendModeSourceIn",
	                          @"kCGBlendModeSourceOut",
	                          @"kCGBlendModeSourceAtop",
	                          @"kCGBlendModeDestinationOver",
	                          @"kCGBlendModeDestinationIn",
	                          @"kCGBlendModeDestinationOut",
	                          @"kCGBlendModeDestinationAtop",
	                          @" kCGBlendModeXOR",
	                          @"kCGBlendModePlusDarker",
	                          @"kCGBlendModePlusLighter"
	                          ];
	    
	    NSMutableArray *arr1 = [NSMutableArray array];
	    for (int i = 0; i<28; i++) {
	        CGRect rect = CGRectMake(0, self.safeAreaInsets.top + i * 25, 180, 10);
	        [arr1 addObject:@(rect)];
	    }
	    [UIColor.yellowColor set];
	    UIRectFill(rect0);
	    
	    [UIColor.redColor set];
	    
	    for (int i = 0; i<arr1.count; i++) {
	        NSValue *val = arr1[i];
	        UIRectFillUsingBlendMode(val.CGRectValue, i);
	    }
	    for (int i = 0; i<arr0.count; i++) {
	        NSValue *val = arr0[i];
	        NSString *name = nameStrs[i];
	        [name drawAtPoint:val.CGRectValue.origin withAttributes:nil];
	    }
	    
	}


对比代码和显示效果查看每种叠加效果

![渐变]({{site.url}}/assets/images/coreGraphics/overlay.png)

### 上下文变换

在view中可以利用transform对试图进行平移旋转缩放，绘图中我们也经常用到图形形变，在CoreText中绘制文字的时候因为Core Graphics坐标原点在左下角、UIKit在右上角 。所有要通过变换转过来，下面通过一个图片的变换演示一下图形上下文的形变

	- (void)changeCoordinateWithContext:(CGContextRef)context{
	    //    CGContextRotateCTM(context, M_PI / 50);
	    //Core Graphics坐标原点在左下角, UIKit坐标系在左上角, 所以先把坐标系转换成Core Graphics坐标
	    CGContextScaleCTM(context, 1, -1);
	    CGContextTranslateCTM(context, 0, -self.bounds.size.height);
	
	    CGContextDrawImage(context, CGRectMake(0, 0, 100, 100), [UIImage imageNamed:@"user"].CGImage);
	}
	- (void)rotateWithContext:(CGContextRef)context{
	    //缩放
	    CGContextScaleCTM(context, 2, 2);
	    //平移
	    CGContextTranslateCTM(context, 100, 20);
	    CGContextDrawImage(context, CGRectMake(0, 100, 100, 100), [UIImage imageNamed:@"user"].CGImage);
	}

### 绘制图像

#### 在drawRect中绘制:

    //    在前面基本绘图部分，绘制图像时使用了UIKit中封装的方法进行了图像绘制，我们不妨看一下使用Quartz 2D内置方法绘制是什么效果。
    
       /**
     在上下文中直接绘制图片
    
     @param context <#context description#>
     */
    - (void)drawImageWithContext:(CGContextRef)context{
        UIImage *img = [UIImage imageNamed:@"user"];
        //绘制图片
        CGContextDrawImage(context, CGRectMake(0, 100, 100, 100), img.CGImage);
        //文理贴图
        CGContextDrawTiledImage(context, CGRectMake(0, 0, 100, 100), img.CGImage);
    }


![渐变]({{site.url}}/assets/images/coreGraphics/tiled.png)

#### 直接开启图片上下文绘制

利用位图图形上下文给一个图片添加水印，在下面的程序中我们首先创建上下文，然后在上下文中绘制图片、直线和文本，最后从当前位图上下文中取得最终形成的新图片显示到界面

	- (void)drawBitMap{
	    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
	
	    UIImage *img = [UIImage imageNamed:@"user"];
	    [img drawInRect:CGRectMake(0, 0, 300, 300)];
	    
	    //获取当前上下文(获取上下文只有在drawRect方法 和 开启上下文之后才能获取,比如开启图片向下文:UIGraphicsBeginImageContext)
	    CGContextRef context = UIGraphicsGetCurrentContext();
	    CGContextMoveToPoint(context, 0, 0);
	    CGContextAddLineToPoint(context, 300, 300);
	    CGContextSetLineWidth(context, 3);
	    //下面两种方式都可以设置strokecolor
	//    CGFloat components[] = {1,1,1,1};
	//    CGContextSetStrokeColor(context, components);
	    [UIColor.redColor setStroke];
	    CGContextDrawPath(context, kCGPathStroke);
	    NSString *name = @"我的版权";
	    [name drawInRect:CGRectMake(0, 0, 300, 300) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
	
	    UIImage *drawImg = UIGraphicsGetImageFromCurrentImageContext();
	    UIGraphicsEndImageContext();
	    self.drawView.image = drawImg;
	}

//    注意：上面这种方式绘制的图像除了可以显示在界面上还可以调用对应方法进行保存（代码注释中已经包含保存方法）；除此之外这种方法相比在drawRect：方法中绘制图形效率更高，它不用每次展示时都调用所有图形绘制方法。


![渐变]({{site.url}}/assets/images/coreGraphics/drawImage.png)

绘制pdf

绘制到PDF则要启用pdf图形上下文，PDF图形上下文的创建使用方式跟位图图形上下文是类似的，需要注意的一点就是绘制内容到PDF时需要创建分页，每页内容的开始都要调用一次UIGraphicsBeginPDFPage();方法。下面的示例演示了文本绘制和图片绘制（其他图形绘制也是类似的）：

	- (void)drawRect:(CGRect)rect {
	    // Drawing code
	    CGContextRef context = UIGraphicsGetCurrentContext();
	    CGContextTranslateCTM(context, 0, self.bounds.size.height);
	    CGContextScaleCTM(context, 1, -1);
	    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dgcdhp" ofType:@"pdf"]];
	    CFURLRef urlref = (__bridge CFURLRef)url;
	    CGPDFDocumentRef pdf =  CGPDFDocumentCreateWithURL(urlref);
	    CGPDFPageRef page =  CGPDFDocumentGetPage(pdf, 1);
	    CGContextDrawPDFPage(context, page);
	}



drawRect的刷新直接调用setNeedsDisplay相信大家都知道在适当的时候调用即可。



github地址:[https://github.com/heron-newland/Core-Graphics](https://github.com/heron-newland/Core-Graphics)

参考链接：[http://allluckly.cn/投稿/tuogao29](http://allluckly.cn/投稿/tuogao29)
