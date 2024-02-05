---
layout: post
title:  "Flutter Notes"
date:   2022-08-15
categories:
 - Turorial
tags:
 - Skills
---

# Flutter Notes

#### dialog变化高度

#### SingleLineFittedBox自动适配文本你的大小来适配固定的空间完全展示

```dart
class SingleLineFittedBox extends StatelessWidget {
  const SingleLineFittedBox({Key? key,this.child}) : super(key: key);
 final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return FittedBox(
          child: ConstrainedBox(
            constraints: constraints.copyWith(
              minWidth: constraints.maxWidth,
              maxWidth: double.infinity,
              //maxWidth: constraints.maxWidth
            ),
            child: child,
          ),
        );
      },
    );
  }
}
```

dart注解

```
WidgetsBindingObserver
```

### Flutter去掉按钮的点击效果

https://blog.7-ik.com/index.php/archives/190/

### flutter如何禁止listview滑动

 ListView禁止用户上下滑动可以使用physics属性

```
physics: const NeverScrollableScrollPhysics()
```

#### TickerProviderStateMixin

### Flutter try catch

### Flutter与原生交互的数据类型

| Dart                       | Java                | Kotlin      | Obj-C                                          | Swift                                   |
| -------------------------- | ------------------- | ----------- | ---------------------------------------------- | --------------------------------------- |
| null                       | null                | null        | nil (NSNull when nested)                       | nil                                     |
| bool                       | java.lang.Boolean   | Boolean     | NSNumber numberWithBool:                       | NSNumber(value: Bool)                   |
| int                        | java.lang.Integer   | Int         | NSNumber numberWithInt:                        | NSNumber(value: Int32)                  |
| int, if 32 bits not enough | java.lang.Long      | Long        | NSNumber numberWithLong:                       | NSNumber(value: Int)                    |
| double                     | java.lang.Double    | Double      | NSNumber numberWithDouble:                     | NSNumber(value: Double)                 |
| String                     | java.lang.String    | String      | NSString                                       | String                                  |
| Uint8List                  | byte[]              | ByteArray   | FlutterStandardTypedData typedDataWithBytes:   | FlutterStandardTypedData(bytes: Data)   |
| Int32List                  | int[]               | IntArray    | FlutterStandardTypedData typedDataWithInt32:   | FlutterStandardTypedData(int32: Data)   |
| Int64List                  | long[]              | LongArray   | FlutterStandardTypedData typedDataWithInt64:   | FlutterStandardTypedData(int64: Data)   |
| Float64List                | double[]            | DoubleArray | FlutterStandardTypedData typedDataWithFloat64: | FlutterStandardTypedData(float64: Data) |
| List                       | java.util.ArrayList | List        | NSArray                                        | Array                                   |
| Map                        | java.util.HashMap   | HashMap     | NSDictionary                                   | Dictionary                              |



### Flutter设置渐变背景

```Dart
Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xFFfbab66), Color(0xFFf7418c)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
    );
```

### Flutter中Image组件设置大小失败

解决办法如下, 给Image套一个Center组件

```
Container(
  width: 40,
  height: 40,
  child: Center(
    child: Image(
      width: 10,
      height: 10,
      image: ImageUtils.getAssetImage(
          textExpanded ? "history/history_down_arrow" : "history/history_right_arrow"),
    ),
  ),
),
```

### flutter中键盘处理, flutter中在dialog中处理键盘高度的问题

推荐使用[flutter_keyboard_visibility](https://pub.dev/packages/flutter_keyboard_visibility)去监听键盘的状态

### Flutter之三种依赖方式

```
flutter
```

------

#### 路径依赖

路径依赖，可以通过文件系统的path:依赖包。
路径可以是相对的，也可以是绝对的。
例如，要依赖位于应用相邻目录中的插件’plugin1’

```
dependencies:  plugin1:    path: ../plugin1/
```

#### git依赖

git依赖，可以依赖Git仓库中的包。
默认情况下，会去Git存储库的根目录中寻找包，如下：

```
dependencies:  plugin1:    git:      url: git://github.com/flutter/plugin1.git
```

我们可以制定路径来依赖：

```
dependencies:  plugin1:    git:      url: git://github.com/flutter/plugin1.git      path: path/xxx
```

我们也可以指定commit，branch或tag：

```
dependencies:  plugin1:    git:      url: git://github.com/flutter/plugin1.git      ref: some-branch
```

#### pub依赖

通过pub包仓库进行依赖

这两个是一样的，可以使用任何版本的包

```
dependencies:  plugin1:dependencies:  plugin1: any 
```

指定范围，使用1.2.3 ～ 2.0.0的包：

```
dependencies:  plugin1: ‘>=1.2.3 <2.0.0’
```

指定pub仓库源：

```
dependencies:  plugin1:    hosted:      name: plugin1      url: http://some-package-server.com
```

也可以指定版本：

```
dependencies:  plugin1:    hosted:      name: plugin1      url: http://some-package-server.com    version: ^1.0.0
```

#### flutter中隐藏控件的三种方式

1. Opacity: 其实是根据visible 控制透明度而已，其实还是占位的

2. Offstage`为true时表示不渲染，也不占位

3. Visibilty通过设置visible来展示或者隐藏子控件,不占位，并且可以设置在隐藏子控件时展示占位控件
   常用属性

4. 通过变量控制 visible ? Padding(padding: EdgeInsets.all(30), child: Text('yechaoa')) : Container(),

#### Flutter中文本控件文本的垂直居中简单处理方法

[文本不能垂直居中的原因](https://juejin.cn/post/6992768707206316040)

在TextStyle设置height:1.1,字体不同值不同,全部代码如下:

```
TextButton(
    onPressed: () {
      //TODO:- 购买vip
    },
    child: Text(intl("cxy010606"),
        style: TextStyle(
            fontSize: 12,
            height:1.1,
            color: KColor.WHITE,
            textBaseline: TextBaseline.alphabetic,
            fontWeight: FontWeight.w500))),
```

### flutter版本升级之后对空安全支持的修改

[非健全的空安全](https://dart.cn/null-safety/unsound-null-safety)

### 原生跳转flutter的实现

参考:

https://blog.csdn.net/wangtianya125/article/details/123046217

https://blog.51cto.com/928343994/2841654

dart[插件](https://pub.dev/packages/g_faraday)

### MediaQuery

MediaQueryData是MediaQuery.of获取数据的类型。说明如下：

属性	说明
size	逻辑像素，并不是物理像素，类似于Android中的dp，逻辑像素会在不同大小的手机上显示的大小基本一样，物理像素 = size*devicePixelRatio。
devicePixelRatio	单位逻辑像素的物理像素数量，即设备像素比。
textScaleFactor	单位逻辑像素字体像素数，如果设置为1.5则比指定的字体大50%。
platformBrightness	当前设备的亮度模式，比如在Android Pie手机上进入省电模式，所有的App将会使用深色（dark）模式绘制。
viewInsets	被系统遮挡的部分，通常指键盘，弹出键盘，viewInsets.bottom表示键盘的高度。
padding	被系统遮挡的部分，通常指“刘海屏”或者系统状态栏。
viewPadding	被系统遮挡的部分，通常指“刘海屏”或者系统状态栏，此值独立于padding和viewInsets，它们的值从MediaQuery控件边界的边缘开始测量。在移动设备上，通常是全屏。
systemGestureInsets	显示屏边缘上系统“消耗”的区域输入事件，并阻止将这些事件传递给应用。比如在Android Q手势滑动用于页面导航（ios也一样），比如左滑退出当前页面。
physicalDepth	设备的最大深度，类似于三维空间的Z轴。
alwaysUse24HourFormat	是否是24小时制。
accessibleNavigation	用户是否使用诸如TalkBack或VoiceOver之类的辅助功能与应用程序进行交互，用于帮助视力有障碍的人进行使用。
invertColors	是否支持颜色反转。
highContrast	用户是否要求前景与背景之间的对比度高， iOS上，方法是通过“设置”->“辅助功能”->“增加对比度”。 此标志仅在运行iOS 13的iOS设备上更新或以上。
disableAnimations	平台是否要求尽可能禁用或减少动画。
boldText	平台是否要求使用粗体。
orientation	是横屏还是竖屏。

### flutter 异步编程,  async, async*, yield, yield\*, future, stream,then等

学习资料:

#### flutter中Appbar嵌套Tabbar使用是, 如果需要在Tabbar中添加组件, 那么需要将Tabbar嵌套在PreferredSize中,例如:

```
PreferredSize(
  preferredSize: Size.fromHeight(44),
  child: Row(children: [
    Expanded(
      child: TabBar(...)
      )
     ]
   )
      
```

### flutter弹窗showBarModalBottomSheet出现黑边问题:

自定义shape属性即可,如下:

```
shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24)),
  side: BorderSide(
    color: Colors.white10,
    width: 1
  )
),
```

### dart中一切接对象, 所以函数的传值都是传递引用

如果要使用值传递, 直接传递一个json,然后转对象

### Mediaquery[详解](https://cloud.tencent.com/developer/article/1662156)

### flutter中textfield的焦点事件

要使用FocusScope.of(context).requestFocus()需要先定义一个FocusNode

```
FocusNode _commentFocus = FocusNode();TextField(focusNode: _commentFocus,),
```

　　

## 获取焦点

当点击时用FocusScope.of(context).requestFocus()获取焦点

```
FocusScope.of(context).requestFocus(_commentFocus);   // 获取焦点
```

　　

## 失去焦点

当发送留言之后可以通过unfocus()让其失去焦点

```
_commentFocus.unfocus();  // 失去焦点
```



### Flutter textfield控制光标位置

把光标移到最后

```dart
//方案一:
_editingController.text = suggestion;
final length = suggestion.length;
_editingController.selection = TextSelection(baseOffset:length , extentOffset:length);

//方案二:
TextField(
                  controller: TextEditingController.fromValue(TextEditingValue(
                  // 设置内容
                  text: inputText,
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: inputText.length)))),
            )
```

让TextField 全选

```undefined
_editingController.selection = TextSelection(baseOffset:0 , extentOffset: text.length);
```



### flutter获取图片宽高     


通过在其ImageProvider上调用resolve来读取ImageStream

##### 1.本地图片宽高获取

```
  Image image = Image.file(File.fromUri(Uri.parse(path)));
  // 预先获取图片信息
  image.image.resolve(new ImageConfiguration()).addListener(
       ImageStreamListener((ImageInfo info, bool _) {
    width = info.image.width;
    height = info.image.height;
	....
  }));
},
```



##### 2.网络图片宽高获取

```
Image image = Image.network(this.detail.message['path'] ?? '');
image.image
    .resolve(new ImageConfiguration())
    .addListener(new ImageStreamListener(
      (ImageInfo info, bool _) {
    model = IMImageMsgModel(
      url: this.detail.message['path'],
      width: info.image.width,
      height: info.image.height,
    );
    print('model.width======${model.width}');
  },
));
```



### flutter textfield控制长度

```
法案1:maxLength属性(会出现文本长度计数)
方案2:(不会出现文本长度计数)
inputFormatters: [
  LengthLimitingTextInputFormatter(maxNoteLength)
],
```

### flutter日期格式化

```
import 'package:intl/intl.dart';
```

```
DateTime now = DateTime.now();//获取当前时间
String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);//格式化日期
```

```
//同理，字符串转日期的方法如下
DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse("2019-07-19 08:40:23");
```

### flutter组件隐藏显示

```
Visibility
AnimatedOpacity
Offstage
控制空间宽高
```

### flutter sliver系列组件

[案例](https://segmentfault.com/a/1190000019902201)



### flutter颜色十六进制字符串转化

```dart
extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceAll('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex() => '${alpha.toRadixString(16).padLeft(2,"0")}'
      '${red.toRadixString(16).padLeft(2,"0")}'
      '${green.toRadixString(16).padLeft(2,"0")}'
      '${blue.toRadixString(16).padLeft(2,"0")}';
}
```



### flutter修改状态栏颜色

使用 AnnotatedRegion 组件修改状态栏文字颜色

```
AnnotatedRegion(
  value: SystemUiOverlayStyle.light,
  ...
```

### flutter随机数

```
Random().nextInt(255)//生成255以内的int类型,其他同理
```

### flutter监听页面的手势返回

### flutter中Appbar中actions大小控制

actions中设置控件的大小没有用, 只需要设置padding就行了.

### flutter中什么对象需要dispose

### flutter毫米转像素

### flutter中Container透明部分不响应事件

解决办法如下:

1,将GestureDetector的 behavior 属性设置为 opaque 或 translucent(behavior: HitTestBehavior.opaque)

2,将Container设置背景颜色

### flutter读取userdefault里面的信息

flutter sharedpreference各自封装的iOS和安卓的本地化存储方案, iOS中能直接对接原生的 nsuserdefault, 原生通过'flutter.key'能获取flutter中以key存储的值	

### flutter判断当前页面是否为某个页面

使用全局变量记录栈顶页面, 配合路由使用, 一定要注意和原生交互产生的新页面

### flutter给Container添加阴影

关键代码:

```dart
Container(
  decoration: BoxDecoration(
    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20.0.wDp)],
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8))
  ),
)
```

### flutter圆角组件

在这里使用 Container 容器来实现圆角矩形边框效果,但是要注意,Container组件只能自己圆角不能裁剪子组件, 还有其他的圆角组件**ClipRRect、ClipOval、CircleAvatar、BoxDecoration BorderRadius.circular、BoxDecoration BoxShape.circle**再文末简单介绍一下

1 圆角矩形边框

![20190712175832856](/Users/longhe/Documents/JC/Notes/assets/20190712175832856.gif)

        Container(
          margin: EdgeInsets.only(left: 40, top: 40),
          //设置 child 居中
          alignment: Alignment(0, 0),
          height: 50,
          width: 300,
          //边框设置
          decoration: new BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            //设置四周边框
            border: new Border.all(width: 1, color: Colors.red),
          ),
          child: Text("Container 的圆角边框"),
        ),

2 圆角矩形边框

![20190712180042942](/Users/longhe/Documents/JC/Notes/assets/20190712180042942.gif)

        Container(
          margin: EdgeInsets.only(left: 40, top: 40),
          //设置 child 居中
          alignment: Alignment(0, 0),
          height: 50,
          width: 300,
          //边框设置
          decoration: new BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            //设置四周边框
            border: new Border.all(width: 1, color: Colors.red),
          ),
          child: Text("Container 的圆角边框"),
        ),

3 可点击的圆角矩形边框

![20190712180229787](/Users/longhe/Documents/JC/Notes/assets/20190712180229787.gif)

使用 InkWell 来实现 ，更多关于 InkWell 可查看 flutter InkWell 设置水波纹点击效果详述


        Container(
          margin: EdgeInsets.only(left: 40, top: 40),
          child: new Material(
            //INK可以实现装饰容器
            child: new Ink(
              //用ink圆角矩形
              // color: Colors.red,
              decoration: new BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //设置四周边框
                border: new Border.all(width: 1, color: Colors.red),
              ),
              child: new InkWell(
                  //圆角设置,给水波纹也设置同样的圆角
                  //如果这里不设置就会出现矩形的水波纹效果
                  borderRadius: new BorderRadius.circular(25.0),
                  //设置点击事件回调
                  onTap: () {},
                  child: Container(
                    //设置 child 居中
                    alignment: Alignment(0, 0),
                    height: 50,
                    width: 300,
                    child: Text("点击 Container 圆角边框"),
                  )),
            ),
          ),
        ),

4 可点击的圆角矩形边框

![20190712180341846](/Users/longhe/Documents/JC/Notes/assets/20190712180341846.gif)

 

```
   Container(
      margin: EdgeInsets.only(left: 40, top: 40),
      child: new Material(
        child: new Ink(
          //设置背景
          decoration: new BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            //设置四周边框
            border: new Border.all(width: 1, color: Colors.red),
          ),
          child: new InkResponse(
            borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
            //点击或者toch控件高亮时显示的控件在控件上层,水波纹下层

//                highlightColor: Colors.deepPurple,
                //点击或者toch控件高亮的shape形状
                highlightShape: BoxShape.rectangle,
                //.InkResponse内部的radius这个需要注意的是，我们需要半径大于控件的宽，如果radius过小，显示的水波纹就是一个很小的圆，
                //水波纹的半径
                radius: 300.0,
                //水波纹的颜色
                splashColor: Colors.yellow,
                //true表示要剪裁水波纹响应的界面   false不剪裁  如果控件是圆角不剪裁的话水波纹是矩形
                containedInkWell: true,
                //点击事件
                onTap: () {
                  print("click");
                },
                child: Container(
                  //设置 child 居中
                  alignment: Alignment(0, 0),
                  height: 50,
                  width: 300,
                  child: Text("点击 Container 圆角边框"),
                ),
              ),
            ),
          ),
        ),


```

#### 1.ClipRRect：将 child 剪裁为宽高相等的圆角组件，可设置圆角度数



```cpp
  new Container(
      width: 80,//80或100
      height: 80,
         child: new ClipRRect(
              borderRadius: BorderRadius.circular(40),//圆角度数
              child: Image.network(this.imageUrl),
         ),
  ),
```

![img](https:////upload-images.jianshu.io/upload_images/7254079-4f3b7a22cd5efd35.png?imageMogr2/auto-orient/strip|imageView2/2/w/240)

ClipRRect.png

#### 2.ClipOval： 将child裁剪为宽高相等的圆角组件（只包括圆形和椭圆形），不可设置圆角度数



```cpp
 new Container(
      width: 80,//80或100
      height: 80,
         child:new ClipOval(
              child: Image.network(this.imageUrl),
         ),
  ),
```

![img](https:////upload-images.jianshu.io/upload_images/7254079-02c323fd79dd2f8e.png?imageMogr2/auto-orient/strip|imageView2/2/w/241)

ClipOval.png

#### 3.CircleAvatar：只能设置自身圆形，不能裁剪child



```cpp
 new Container(
      width: 80,//80或100
      height: 80,
      child: new CircleAvatar(
           backgroundImage: NetworkImage(this.imageUrl),
      ),
),
```

![img](https:////upload-images.jianshu.io/upload_images/7254079-956fe20648f70300.png?imageMogr2/auto-orient/strip|imageView2/2/w/231)

CircleAvatar.png

#### 4.BoxDecoration BorderRadius.circular 设置自身圆角,不能裁剪child



```cpp
new Container(
    width: 80.0,//100或80
    height: 80.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        image: DecorationImage(
            image: NetworkImage(this.imageUrl),
         )
      ),
  ),
```

![img](https:////upload-images.jianshu.io/upload_images/7254079-d736ee65115e9e9f.png?imageMogr2/auto-orient/strip|imageView2/2/w/240)

BorderRadius.png

#### 4.BoxDecoration BoxShape.circle 只能设置自身为圆形，不能裁剪child



```cpp
new Container(
    width:80,//80或100
    height: 80,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: NetworkImage(this.imageUrl),
      ),
    ),
  )
```

![img](https:////upload-images.jianshu.io/upload_images/7254079-e3153cd177d1a8b9.png?imageMogr2/auto-orient/strip|imageView2/2/w/231)

BoxShap.png

### 获取系统语言

```
MaterialApp(
  home: ...,
  localeResolutionCallback: (deviceLocale, supportedLocales) {
    //存储国际化
    List<String> locale = 		     [deviceLocale.languageCode,deviceLocale.countryCode,deviceLocale.scriptCode];
    Application.sp.setStringList(KString.LANGUAGE_CODE, locale);
    ToNativeMethodChannel.setNativeLanguage(locale);
    print('当前系统语言为:' + deviceLocale.scriptCode);
    return deviceLocale;
  },
));
```

### flutter如何获取页面加载完成的时机?

### Flutte类型转换

#### 字符串和int

```
//int转string

8848.toString();

//string转int

int.parse("8848");
```

#### 舍弃小数部分（取整）

首先我们来看如何只保留整数位，这里有很多方法可以实现：

```
double price = 100 / 3;

//舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
price.truncate();
//舍弃当前变量的小数部分，浮点数形式表示，结果为 33.0。返回值为 double。
price.truncateToDouble();
//舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
price.toInt();
//小数部分向上进位，结果为 34。返回值为 int 类型。
price.ceil();
//小数部分向上进位，结果为 34.0。返回值为 double。
price.ceilToDouble();
//当前变量四舍五入后取整，结果为 33。返回值为 int 类型。
price.round();
//当前变量四舍五入后取整，结果为 33.0。返回值为 double 类型。
price.roundToDouble();
```

根据自己的需求，是否需要四舍五入等，选择一个合适的方法即可。

#### 保留小数点后 n 位

如果我们想要控制浮点数的精度，想要保留小数点后几位数字，怎么实现？

最简单的是使用 toStringAsFixed() 方法：

```
double price = 100 / 3;
//保留小数点后2位数，并返回字符串：33.33。
price.toStringAsFixed(2);
//保留小数点后5位数，并返回一个字符串 33.33333。
price.toStringAsFixed(5);
```

注意，toStringAsFixed() 方法会进行四舍五入。



### TextButton取消点击效果

详细使用方式如下:

```dart
 //这是一个文本按钮 未设置点击事件下的样式
  Widget buildTextButton2() {
    return TextButton(
      child: Text("TextButton按钮"),
      //添加一个点击事件
      onPressed: () {},
      //设置按钮是否自动获取焦点
      autofocus: true,
      //定义一下文本样式
      style: ButtonStyle(
        //定义文本的样式 这里设置的颜色是不起作用的
        textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 18, color: Colors.red)),
        //设置按钮上字体与图标的颜色
        //foregroundColor: MaterialStateProperty.all(Colors.deepPurple),
        //更优美的方式来设置
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.focused) &&
                !states.contains(MaterialState.pressed)) {
              //获取焦点时的颜色
              return Colors.blue;
            } else if (states.contains(MaterialState.pressed)) {
              //按下时的颜色
              return Colors.deepPurple;
            }
            //默认状态使用灰色
            return Colors.grey;
          },
        ),
        //背景颜色
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue[200];
          }
          //默认不使用背景颜色
          return null;
        }),
        //设置水波纹颜色
        overlayColor: MaterialStateProperty.all(Colors.yellow),
        //设置阴影  不适用于这里的TextButton
        elevation: MaterialStateProperty.all(0),
        //设置按钮内边距
        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
        //设置按钮的大小
        minimumSize: MaterialStateProperty.all(Size(200, 100)),

        //设置边框
        side:
            MaterialStateProperty.all(BorderSide(color: Colors.grey, width: 1)),
        //外边框装饰 会覆盖 side 配置的样式
        shape: MaterialStateProperty.all(StadiumBorder()),
      ),
    );
  }
```

### 数组删除元素问题

删除元素方式很多,常用两种方式如下:

```
//方式一:
bool removeRes = provider.comments.list.remove(comment);

//方式二:
int deleteIndex = provider.comments.list.indexWhere((element) => element.id == comment.id);
provider.comments.list.removeAt(deleteIndex);
```

以上两种方式中, 当删除的元素是很复杂的模型是,由于某些原因删除会不成功, 稳妥起见推荐使用第二种方式.

### 焦点事件

```java
//实例化
 FocusNode _focusNode = FocusNode();
```

```java
//监听得放在初始化中
@override
  void initState() {
 super.initState();

   //输入框焦点
    _focusNode.addListener((){
      if (!_focusNode.hasFocus) {
//        print('失去焦点');
      }else{
//        print('得到焦点');   
      }
    });
}
```

```java
//离开页面记着销毁和清除
 @override
  void dispose() {
    // TODO: implement dispose 
    _focusNode.unfocus(); 
    super.dispose();
  }
```

```
//清除输入框焦点 
 FocusScope.of(context).requestFocus(FocusNode());
```

### Flutter延时执行

flutter中可以通过Future.delay或者Timer来达到延时执行的目的，示例代码如下：

```
//延时500毫秒执行
Future.delayed(const Duration(milliseconds: 500), () {

  //延时执行的代码

  setState(() {
    //延时更新状态
  });

});
```

或者使用Timer达到相同的效果：

```
Timer(Duration(seconds: 3), () {
  print("3秒后执行");
});
```



### 添加新图片之后无法找到

解决办法:删除app后重新运行

### WidgetsBindingObserver监测页面生命周期

```dart
class FlutterLifeCycleState extends State<FlutterLifeCycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //添加观察者
  }

  ///生命周期变化时回调
//  resumed:应用可见并可响应用户操作
//  inactive:用户可见，但不可响应用户操作
//  paused:已经暂停了，用户不可见、不可操作
//  suspending：应用被挂起，此状态IOS永远不会回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("@@@@@@@@@  didChangeAppLifecycleState: $state");
  }

  ///当前系统改变了一些访问性活动的回调
  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    print("@@@@@@@@@ didChangeAccessibilityFeatures");
  }

  /// Called when the system is running low on memory.
  ///低内存回调
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    print("@@@@@@@@@ didHaveMemoryPressure");
  }

  /// Called when the system tells the app that the user's locale has
  /// changed. For example, if the user changes the system language
  /// settings.
  ///用户本地设置变化时调用，如系统语言改变
  @override
  void didChangeLocales(List<Locale> locale) {
    super.didChangeLocales(locale);
    print("@@@@@@@@@ didChangeLocales");
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  ///应用尺寸改变时回调，例如旋转
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    Size size = WidgetsBinding.instance.window.physicalSize;
    print("@@@@@@@@@ didChangeMetrics  ：宽：${size.width} 高：${size.height}");
  }

  /// {@macro on_platform_brightness_change}
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    print("@@@@@@@@@ didChangePlatformBrightness");
  }

  ///文字系数变化
  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
    print(
        "@@@@@@@@@ didChangeTextScaleFactor  ：${WidgetsBinding.instance.window.textScaleFactor}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("flutter"),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this); //销毁观察者
  }
}
```

#### Flutter布局随键盘顶起来问题

在Scaffold加属性

```bash
resizeToAvoidBottomPadding: false,
```

### flutter嵌套原生试图(iOS端)

1. 创建工厂类,代码如下:

   头文件

   ```objective-c
   #import <Foundation/Foundation.h>
   #import <Flutter/Flutter.h>
   
   @interface FLNativeViewFactory : NSObject <FlutterPlatformViewFactory>
   @property(nonatomic,strong)NSObject<FlutterBinaryMessenger> *message;
   
   -(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
   @end
   ```

   实现文件:

   ```objective-c
   #import "FLNativieViewFactory.h"
   #import "JCFLWebView.h"
   @implementation FLNativeViewFactory
   
   -(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
   if (self = [super init]) {
       _message = messenger;
   }
   return self;
   }
   
   -(nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
   return [[JCFLWebView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:self.message];
   }
   
   -(NSObject<FlutterMessageCodec> *)createArgsCodec {
   return [FlutterStandardMessageCodec sharedInstance];
   }
   
   @end
   ```

   2. 创建具体的试图管理类

      头文件:

      ```objective-c
      #import <Foundation/Foundation.h>
      #import <Flutter/Flutter.h>
      
      NS_ASSUME_NONNULL_BEGIN
      
      @interface JCFLWebView : NSObject<FlutterPlatformView>
      
      -(instancetype)initWithFrame:(CGRect)frame
          viewIdentifier:(int64_t)viewId
               arguments:(id _Nullable)args
         binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
      
      -(UIView*)view;
      @end
      
      NS_ASSUME_NONNULL_END
      ```

      实现文件:

      ```objective-c
      #import "JCFLWebView.h"
      #import "FLNativieViewFactory.h"
      #import "JCWKWebViewController.h"
      
      @implementation JCFLWebView {
         UIView *_view;
      }
      
      -(instancetype)initWithFrame:(CGRect)frame
          viewIdentifier:(int64_t)viewId
               arguments:(id _Nullable)args
         binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
      if (self = [super init]) {
          _view = [[UIView alloc] init];
      }
      return self;
      }
      
      -(UIView*)view {
      return _view;
      }
      
      @end
      ```

   3. 在appdelegate中注册(注意idstring要和flutter中的一致)

      ```objective-c
       NSObject<FlutterPluginRegistrar>* registrar =
               [self registrarForPlugin:@"jcwebview_plugin"];
      
           FLNativeViewFactory* factory =
               [[FLNativeViewFactory alloc] initWithMessenger:registrar.messenger];
          
           [registrar registerViewFactory:factory withId:@"idstring"];
      
      
      ```

   4. flutter代码:

      ```dart
      UiKitView(
          viewType: 'idstring',
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        )
      ```

      

### Flutter打包web项目

1. 开启web功能支持 `flutter config --enable-web`,执行完之后需要重启编辑器

2. 打开已有项目进入到根目录，执行`flutter create .`开始创建`web`目录文件，执行完毕后，在项目中多了个一个web目录, 如果需要开启`null safety`,执行`dart migrate --apply-changes`

3. 执行`flutter build web`编译web项目

   

### [Dart异步编程实现](https://zhuanlan.zhihu.com/p/83781258)

### Flutter多个第三方依赖库版本冲突问题:

项目依赖如下几个包

```
http: 0.13.0
audioplayers: 0.17.4
leancloud_storage: 0.6.6
```

执行pub get之后就会报错:

```
Because leancloud_storage >=0.5.0 depends on dio ^3.0.10 which depends on http_parser >=0.0.1 <4.0.0, leancloud_storage >=0.5.0 requires http_parser >=0.0.1 <4.0.0.
And because http 0.13.3 depends on http_parser ^4.0.0 and no versions of http match >0.13.3 <0.14.0, leancloud_storage >=0.5.0 is incompatible with http ^0.13.3.
So, because examination depends on both http ^0.13.3 and leancloud_storage ^0.5.0, version solving failed.
```

如果要自己去找合适的版本好解决冲突问题,很麻烦, 最好的办法如下:

##### 第一步: 修改依赖包为如下写法:

```
http: any
audioplayers: any
leancloud_storage: any
```

##### 第二部:执行` pub get`

##### 第三部:打开工程目录下`pubspec.lock`文件, 然后找到对应的依赖库以及器版本号,最后第一步中的any,替换成`pubspec.lock`文件中的对应的版本好即可

### 单例模式

```dart
class Manager {
  // 工厂模式
  factory Manager() =>_getInstance();
  static Manager get instance => _getInstance();
  static Manager _instance;
  Manager._internal() {
    // 初始化
  }
  static Manager _getInstance() {
    if (_instance == null) {
      _instance = Manager._internal();
    }
    return _instance;
  }
}

//调用
// 无论如何初始化，取到的都是同一个对象
Manager manager = new Manager();
Manager manager2 = Manager.instance;


```



### 区分生产测试环境

```dart
final isProd = bool.fromEnvironment('dart.vm.product');
```

### 文本框换行

使用Expanded包一层:

```dart
Expanded(
    child: Text(
  model.examTitle,
  maxLines: 3,
  overflow: TextOverflow.ellipsis,
  softWrap: true,
  textAlign: TextAlign.left,
	)
)
```



### Dart关键词

#### factory

##### 一. 官方的描述

> *当你使用factory关键词时，你能控制在使用构造函数时，并不总是创建一个新的该类的对象，比如它可能会从缓存中返回一个已有的实例，或者是返回子类的实例。*

##### 二. 3个使用场景

1. 避免创建过多的重复实例，如果已创建该实例，则从缓存中拿出来。
2. 调用子类的构造函数(工厂模式 factory pattern)
3. 实现单例模式

#### dynamic

dynamic类型具有所有可能的属性和方法。Dart语言中函数方法都有dynamic类型作为函数的返回类型，函数的参数也都有dynamic类型。

其实dynamic不是实际的type，而是类型检查开关。一个变量被dynamic修饰，相当于告诉static type 系统“相信我，我知道我自己在做什么”。例如:

```dart
dynamic a;
Object b;
main() {
  a = "";
  b = "";
  printLengths();
}

printLengths() {
  // no warning
  print(a.length);
  // warning:
  // The getter 'length' is not defined for the class 'Object'
  print(b.length);
}
```

### [异步UI处理: FutureBuilder和StreamBuilder](https://book.flutterchina.club/chapter7/futurebuilder_and_streambuilder.html#_7-5-1-futurebuilder)

FutureBuilder直接收一个异步操作

StreamBuilder可接受多个异步操作,常用于会多次读取数据的异步任务场景，如网络内容下载、文件读写等。

### 泛型:

- 泛型方法
- 泛型类
- 泛型接口

### ChangeNotifier使用方法

1. 定义一个数据Model类，继承自ChangeNotifier
2. 使用ChangeNotifierProvider组件来将Model与Widget相关联
3. 更新UI: 有如下两种方法:
   1. 定义监听者Consumer，获取Model的值来
   2. 使用Provider.of来更新数据

#### 代码示例如下:

#### 定义一个数据Model类，继承自ChangeNotifier

```
class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }
}
```

#### 使用ChangeNotifierProvider组件来将Model与Widget相关联

```dart
 runApp(
    ChangeNotifierProvider(
      builder: (context) => Counter(),
      child: MyApp(),
    ),
  );
```

  如果你想提供更多状态，可以使用 MultiProvider：

```
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => CartModel()),
        Provider(builder: (context) => SomeOtherClass()),
      ],
      child: MyApp(),
    ),
  );
}
```

#### 定义监听者Consumer，获取Model的值来

```
 body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ],
        ),
      )
```

#### 使用Provider.of来更新数据

```
floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Provider.of<Counter>(context, listen: false).increment(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),

```



### Dart中的extends、with、implements

#### 1. extends:继承

	1. 单继承
	2. 继承父类中的所有变量和方法(因为Dart中没有公有和私有的区别),不能继承构造函数和析构函数
	3. 子类重写父类方法要用 @override
	4. 子类调用父类方法要用 super

#### 2. with:混合mixin

	1. 混合的对象是类
	2. 一个类可以混合多个对象

#### 3. implements: 实现接口

	1. 接口一般使用Abstract, 但是class也是一种隐私接口
	2. class 被当做接口使用时,class的方法就是接口方法。需要重新实现接口方法,方法前使用@override关键字
	3. class 被当做接口使用时,class的成员变量也需要在子类重新实现,使用@override关键字.
	4. 被实现的接口可以有多个



### Space和 SizedBox

1. SizedBox：

   精准控制child尺寸。
   精准定义 widget之间的间隔。此时SizedBox没有定义child

2. Spacer作用：

   通过Flex 创建widget之前的空间。



### WidgetsBinding.instance.addPostFrameCallback

**addPostFrameCallback** 是 StatefulWidge 渲染(build)结束(build)的回调，只会被调用一次，之后 StatefulWidget 需要刷新 UI 也不会被调用，**addPostFrameCallback** 的使用方法是在 **initState** 里添加回调：

```dart
@override
void initState() {
  super.initState();
  SchedulerBinding.instance.addPostFrameCallback((_) => {});
}
```





### Flutter App 的生命周期

#### 1. APP生命周期相关的函数

```dart
abstract class WidgetsBindingObserver {
  //页面pop
  Future<bool> didPopRoute() => Future<bool>.value(false);
  //页面push
  Future<bool> didPushRoute(String route) => Future<bool>.value(false);
  //系统窗口相关改变回调，如旋转
  void didChangeMetrics() { }
  //文本缩放系数变化
  void didChangeTextScaleFactor() { }
  //系统亮度变化
  void didChangePlatformBrightness() { }
  //本地化语言变化
  void didChangeLocales(List<Locale> locale) { }
  //App生命周期变化
  void didChangeAppLifecycleState(AppLifecycleState state) { }
  //内存警告回调
  void didHaveMemoryPressure() { }
  //Accessibility相关特性回调
  void didChangeAccessibilityFeatures() {}
}
```

#### 2.. 使用WidgetsBindingObserver实现生命周期监听的方法:

```dart
class MinePageState extends State<MinePage> with WidgetsBindingObserver {
 @override
 void initState() {
   super.initState();
   //注册监听器
   WidgetsBinding.instance.addObserver(this);
   //下面是通过注册函数直接接受回调
   WidgetsBinding.instance.addPostFrameCallback((_){
     // 只回调一次
     print("单次Frame绘制回调");
   });
   WidgetsBinding.instance.addPersistentFrameCallback((_){
     //每帧都回调
     print("实时Frame绘制回调");
   });
 }

 /// 重写方法，实现App生命周期监听
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("$state");
    if (state == AppLifecycleState.resumed) {
      // resumed 状态
    }
  }

@override
  void dispose() {
    super.dispose();
    //移除监听器
    WidgetsBinding.instance.removeObserver(this);
  }
}
```



### 组件生命周期

1. `StatelessWidget`的生命周期，从源码中可以看到`StatelessWidget`的生命周期只有一个`build`方法。
2. StatefulWidget的生命周期如下:

| 生命周期方法          | 调用时机                                    | 执行次数 |
| --------------------- | ------------------------------------------- | -------- |
| createState           | 创建State对象前                             | 1        |
| constructor           | 创建State对象时                             | 1        |
| initState             | 当State 对象插入视图树之后                  | 1        |
| didChangeDepandencies | State 对象的依赖关系发生变化后              | >=1      |
| build                 | State 改动之后                              | >=1      |
| addPostFrameCallback  | 首帧渲染结束的回调                          | 1        |
| setState              | 需要刷新 UI 时                              | >=1      |
| didUpdateWidget       | widget 配置发生变化时，如调用 setState 触发 | >=1      |
| deactivate            | widget 不可见时                             | >=1      |
| dispose               | widget 被永久移除                           | 1        |

​		



- [ ] Json[序列化](https://flutterchina.club/json/)

Flutter常用命令列表

| 命令                    | 命令解释           | 参数                         |
| ----------------------- | ------------------ | ---------------------------- |
| flutter emulators       | 获取可用模拟器列表 | --launch xxx (启动模拟器xxx) |
| flutter devices         | 获取真机设备列表   |                              |
| flutter run -t 文件路径 | 指定启动文件       | lib/main_local.dart          |

