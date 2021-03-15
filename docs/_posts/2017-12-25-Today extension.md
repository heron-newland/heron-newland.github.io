---
layout: post
title:  "Today extension"
date:   2017-12-25 17:32:53 +0800
categories:
 - Extension
tags:
 - OC
---

extension是iOS8新开放的一种对几个固定系统区域的扩展机制，它可以在一定程度上弥补iOS的沙盒机制对应用间通信的限制。

<!--more-->


目录:
一、关于App Extensions
二、创建 Today Extension
三、extension和containing app、host app之间的关系
四、App Groups
五、extension和containing app数据共享
六、extension和containing app代码共享
七、生命周期
八、 调试
九、 iOS应用文件系统


extension的出现，为用户提供了在其它应用中使用我们应用提供的服务的便捷方式，比如用户可以在Today的widgets中查看应用展示的简略信息，而不用再进到我们的应用中，这将是一种全新的用户体验；但是，extension的出现可能会减少用户启动应用的次数，同时还会增大开发者的工作量。
0
#### 几个关键词

##### extension point
系统中支持extension的区域，extension的类别也是据此区分的，iOS上共有Today、Share、Action、Photo Editing、Storage Provider、Custom keyboard几种，其中Today中的extension又被称为widget。

每种extension point的使用方式和适合干的活都不一样，因此不存在通用的extension。

##### app extension
即为本文所说的extension。extension并不是一个独立的app，它有一个包含在app bundle中的独立bundle，extension的bundle后缀名是.appex。其生命周期也和普通app不同，这些后文将会详述。

extension不能单独存在，必须有一个包含它的containing app。

另外，extension需要用户手动激活，不同的extension激活方式也不同，比如： 比如Today中的widget需要在Today中激活和关闭；Custom keyboard需要在设置中进行相关设置；Photo Editing需要在使用照片时在照片管理器中激活或关闭；Storage Provider可以在选择文件时出现；Share和Action可以在任何应用里被激活，但前提是开发者需要设置Activation Rules，以确定extension需要在合适出现。

##### containing app
尽管苹果开放了extension，但是在iOS中extension并不能单独存在，要想提交到AppStore，必须将extension包含在一个app中提交，并且app的实现部分不能为空,这个包含extension的app就叫containing app。

extension会随着containing app的安装而安装，同时随着containing app的卸载而卸载。

##### host app
能够调起extension的app被称为host app，比如widget的host app就是Today。

### 二、创建 Today Extension
#### 2.1 在项目中新创建一个target

`**File -> New -> Target**` 在弹出的窗口中选择 `Today Extension` 然后给target命名即可

*前提: 确保xcode已经登录开发者账号(个人免费的账号也行),并且已经签名成功 *

### 三、extension和containing app、host app之间的关系

#### 3.1 extension和host app

extension和host app之间可以通过extensionContext属性直接通信，该属性是新增加的UIViewController类别：

	@interface UIViewController(NSExtensionAdditions) <NSExtensionRequestHandling>
	
	// Returns the extension context. Also acts as a convenience method for a view controller to check if it participating in an extension request.
	@property (nonatomic,readonly,retain) NSExtensionContext *extensionContext NS_AVAILABLE_IOS(8_0);
	
	@end

实际上extension和host app之间是通过IPC（interprocess communication）实现的，只是苹果把调用接口高度抽象了，我们并不需要关注那么底层的东西。

#### 3.2 containing app和host app

他们之间没有任何直接关系，也从来不需要通信。

#### 3.3 extension和containing app

这二者之间的关系最复杂，纠纠缠缠扯不清关系。

*	不能直接通信


首先，尽管extension的bundle是放在containing app的bundle中，但是他们是两个完全独立的进程，之间不能直接通信。不过extension可以通过openURL的方式启动containing app（当然也能启动其它app），不过必须通过extensionContext借助host app来实现：

	//通过openURL的方式启动Containing APP
	- (void)openURLContainingAPP
	{
	    [self.extensionContext openURL:[NSURL URLWithString:@"appex://"]
	                 completionHandler:^(BOOL success) {
	                     NSLog(@"open url result:%d",success);
	                 }];
	}

>备注: extension中是无法直接使用openURL的。

*	可以共享Shared resources


extension和containing app可以共同读写一个被称为`Shared resources`的存储区域，这是通过`App Groups`实现的，后文将会详述。

*	containing app能够控制extension的出现和隐藏

通过以下代码，containing app可以让extension出现或隐藏（当然extension也可以让自己隐藏）：

>让隐藏的插件重新显示

	- (void)showTodayExtension
	{
	    [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"com.wangzz.app.extension"];
	}


>隐藏插件

	- (void)hiddeTodayExtension
	{
	    [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:@"com.wangzz.app.extension"];
	}



总之, 三者间的关系可以通过官网给的两张图片形象地说明：
 ![图片](/assets/images/3dTouch.png)
 
  ![图片](/assets/images/3dTouch.png)
  
![](/Users/bochb/Heron/第三方库/MacDown/IMG_2151.PNG)

![](/Users/bochb/Heron/第三方库/MacDown/IMG_2152.PNG)


### 四、App Groups

**这是iOS8新开放的功能，在OS X上早就可用了。它主要用于同一group下的app共享同一份读写空间，以实现数据共享。**

extension和containing app共同读写一份数据是很合理的需求，比如系统的股市应用，widget和app中都需要展示几个公司的股票数据，这就可以通过App Groups实现。

#### 4.1 功能开启

为了便于后续操作，请先确保你的开发者账号在Xcode上处于登录状态。并且要在app和extension中分别开启

##### 4.1.1在app中开启

App Groups位于：

`**TARGETS-->AppExtensionDemo-->Capabilities-->App Groups**`

找到以后，将App Groups右上角的开关打开，然后选择添加groups，比如我的是`group.Extension_today`，当然这是为了测试随便起得名字，正规点得命名规则应该是：group.com.company.appname。

添加成功以后如下图所示：


 ![图片](/assets/images/today/屏幕快照 2018-02-06 上午9.20.12.png)
 
##### 4.1.2在extension中开启

我创建的是widget，target名称为TodayExtension，对应的App Groups位于：


`TARGETS-->TodayExtension-->Capabilities-->App Groups`

开启方式和app中一样，需要注意的是必须保证这里地App Groups名称和app中的相同，即为`group.Extension_today`。

### 五、extension和containing app数据共享

App Groups给我们提供了同一group内app可以共同读写的区域，可以通过以下方式实现数据共享：

#### 5.1 通过NSUserDefaults共享数据

>存数据

通过以下方式向NSUserDefaults中保存数据：

	- (void)saveTextByNSUserDefaults
	{
	    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.Extension_today"];
	    [shared setObject:_textField.text forKey:@"Extension_today>"];
	    [shared synchronize];
	}

需要注意的是：

1.保存数据的时候必须指明group id；

2.而且要注意NSUserDefaults能够处理的数据只能是可plist化的对象，详情见Property List Programming Guide。

3.为了防止出现数据同步问题，不要忘记调用[shared synchronize];

>读数据

	//对应的读取数据方式：
	- (NSString *)readDataFromNSUserDefaults
	{
	    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.Extension_today"];
	    NSString *value = [shared valueForKey:@"wangzz"];
	
	    return value;
	}

#### 5.2 通过NSFileManager共享数据

NSFileManager在iOS7提供了containerURLForSecurityApplicationGroupIdentifier方法，可以用来实现app group共享数据。

>保存数据

	- (BOOL)saveTextByNSFileManager
	{
	    NSError *err = nil;
	    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.Extension_today"];
	    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/good"];
	
	    NSString *value = _textField.text;
	    BOOL result = [value writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
	    if (!result) {
	        NSLog(@"%@",err);
	    } else {
	        NSLog(@"save value:%@ success.",value);
	    }
	
	    return result;
	}

>读数据

	- (NSString *)readTextByNSFileManager
	{
	    NSError *err = nil;
	    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.Extension_today"];
	    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/good"];
	    NSString *value = [NSString stringWithContentsOfURL:containerURL encoding:NSUTF8StringEncoding error:&err];
	
	    return value;
	}

在这里我试着保存和读取的是字符串数据，但读写SQlite我相信也是没问题的。

>数据同步

两个应用共同读取同一份数据，就会引发数据同步问题。WWDC2014的视频中建议使用`**NSFileCoordination**`实现普通文件的读写同步，而数据库可以使用`**CoreData,Sqlite**`也支持同步。

#### 5.3 通过归档共享数据

>存储数据

    	//app group路径
        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Extension_today")?.appendingPathComponent("abc")
         /*
	         上面得到的path前缀是: file://
	         使用归档要去掉 file://
	         */
        let pathString = path!.absoluteString.replacingOccurrences(of: "file://", with: "")
        
        //归档写入方式
       NSKeyedArchiver.archiveRootObject(text, toFile: pathString)
       
>读取数据

	//app group路径
	        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Extension_today")?.appendingPathComponent("abc")
	        /*
	         上面得到的path前缀是: file://
	         使用归档要去掉 file://
	         */
	        let pathString = path!.absoluteString.replacingOccurrences(of: "file://", with: "")
	        //解档读取
	        let str = NSKeyedUnarchiver.unarchiveObject(withFile: pathString)

#### 5.4 数据共享的总结, 数据共享有如下几种方式:

>1、使用iOS 8 新引入的自制 framework 的方式来组织需要重用的代码，这样在链接 framework 后容器App 和扩展就都能使用相同的代码了。(详情参考本文第六章)

>2、通过开启 App Groups 和进行相应的配置来开启在两个进程间的数据共享。这包括了使用NSUserDefaults进行小数据的共享，或者使用NSFileCoordinator和NSFilePresenter甚至是 CoreData 和 SQLite 来进行更大的文件或者是更复杂的数据交互。(详情才考本文第五章)

>3、可通过自定义的 url scheme ，从扩展向应用反馈数据和交互。(详情参考第三章第3小节)

>4、使用 [MMWormhole](https://github.com/mutualmobile/MMWormhole) 框架进行数据交互, 支持实时消息发送和接收(很好的一个框架)

<mark>注意事项: 

>1. 在app和extension之间使用 NotificationCenter (Foundation框架)是无法进行通讯的

>2. 使用 CFNotificationCenterRef (Core Fundation框架)可以进行通讯, 但是不能进行数据交换*(框架决定的, 在文档里面可以查看 If center is a Darwin notification center, this value is ignored.)* . 可以通过app group共享空间保存数据, 然后根据通知实时的读取和写入*(MMWormhole框架就是这样做的, 给每个发送的消息绑定ID, 然后根据ID取取数据)*

### 六、extension和container app数据实时更新
#### 6.1 从app到extension

*	app将更新的数据存储在app group资源共享区
	
*	extension在 widgetPerformUpdate 方法中读取

#### 6.2从extension到app
通过 CFNotificationCenterRef 通知的方式通知(通知不能传值), 使用app group资源共享区进行数据交换
通过MMWormhole框架实现代码如下:

> extension中

	//初始化
	let wormhole = MMWormhole(applicationGroupIdentifier: "group.Extension_today", optionalDirectory: "wormhole")
	//发送消息
	wormhole.passMessageObject(self.slidValue.text as? NSString, identifier: "text")

> app中

	//初始化
	let wormhole = MMWormhole(applicationGroupIdentifier: "group.Extension_today", optionalDirectory: "wormhole")
	//viewDidLoad中
	 wormhole.listenForMessage(withIdentifier: "text") {[unowned self] (string) in
	            self.textField.text = string as? String
	}

### 七、extension和containing app代码共享

和数据共享类似，extension和containing app很自然地会有一些业务逻辑上可以共用的代码，这时可以通过iOS8中刚开放使用的framework实现。苹果在App Extension Programming Guide中是这样描述的：

In iOS 8.0 and later, you can use an embedded framework to share code between your extension and its containing app. For example, if you develop image-processing code that you want both your Photo Editing extension and its containing app to share, you can put the code into a framework and embed it in both targets.

即将framework分别嵌入到extension和containing app的target中实现代码共享。

>参考extension和containing app数据共享，将framework只保存一份放在App Groups区域(此方法用于特殊用途, 正常请按照苹果官方推荐的方法, 将公共方法打成framework, 分别在app和extension中引入)

#### 6.1 copy framework到App Groups

在app首次启动的时候将framework放到App Groups区域：

	
	- (BOOL)copyFrameworkFromMainBundleToAppGroup
	{
	    NSFileManager *manager = [NSFileManager defaultManager];
	    NSError *err = nil;
	    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.Extension_today"];
	    NSString *sorPath = [NSString stringWithFormat:@"%@/Dylib.framework",[[NSBundle mainBundle] bundlePath]];
	    NSString *desPath = [NSString stringWithFormat:@"%@/Library/Caches/Dylib.framework",containerURL.path];
	
	    BOOL removeResult = [manager removeItemAtPath:desPath error:&err];
	    if (!removeResult) {
	        NSLog(@"%@",err);
	    } else {
	        NSLog(@"remove success.");
	    }
	
	    BOOL copyResult = [[NSFileManager defaultManager] copyItemAtPath:sorPath toPath:desPath error:&err];
	    if (!copyResult) {
	        NSLog(@"%@",err);
	    } else {
	        NSLog(@"copy success.");
	    }
	
	    return copyResult;
	}




#### 6.2 使用framework：

	- (BOOL)loadFrameworkInAppGroup
	{
	    NSError *err = nil;
	    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.Extension_today"];
	    NSString *desPath = [NSString stringWithFormat:@"%@/Library/Caches/Dylib.framework",containerURL.path];
	    NSBundle *bundle = [NSBundle bundleWithPath:desPath];
	    BOOL result = [bundle loadAndReturnError:&err];
	    if (result) {
	        Class root = NSClassFromString(@"Person");
	        if (root) {
	            Person *person = [[root alloc] init];
	            if (person) {
	                [person run];
	            }
	        }
	    } else {
	        NSLog(@"%@",err);
	    }
	
	    return result;
	}
	
经过测试，能够加载成功。

<mark>注意:</mark>需要说明的是，这里只是说那么用是可以成功加载framework，但还面临不少问题，比如如果用户在启动app之前去使用extension，这时framework还没有copy过去，怎么处理；另外iOS的机制或者苹果的审核是否允许这样使用等。

在一切确定下来之前还是乖乖按文档中的方式使用吧。

### 七、生命周期

**extension和普通app的最大区别之一是生命周期。**

*	开始:


	在用户通过host app点击extension时，系统就会实例化extension应用，这是生命周期的开始。

*	执行任务:


	在extension启动以后，开始执行它的使命。

*	终止:


	在用户取消任务，或者任务执行结束，或者开启了一个长时后台任务时，系统会将其杀掉。

由此可见，extension就是为了任务而生！

下图来自官方文档，它将生命周期划分的更详细：


 ![图片](/assets/images/today/IMG_2155.PNG)

通过打印日志发现，Today中的widget在将Today切换到全部或者未读通知时都会被杀掉。


 
### 八、 Today extension的具体使用方式UI部分

*	开启widget的折叠状态
	
	  	self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
	        
*	自定义widget的margin, iOS 10以后此方法不会被调用,也就是失效了.用户在无法改变margin, 可用使用autoLayout达到相同的效果
 
	    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
	        return UIEdgeInsetsMake(0, 100, 0, 100)
	    }
	    
*	折叠展开时都会调用
 
	    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {      
	    if activeDisplayMode == .compact {//折叠模式
	       //折叠模式的最大高度为110
	            self.preferredContentSize = maxSize
	     }else{//展开模式
	     self.preferredContentSize = CGSize(width: 0, height: 300)
	        //展开模式的最大高度几乎全屏
	            //  self.preferredContentSize = maxSize
	        } 
	    }
    
    
*	每次widget重新加载都会调用此方法(更新周期大概是2s吧, 如果在2s以内来回切回到today, widget不会更新)
    
        func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        //app group路径
        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Extension_today")?.appendingPathComponent("abc")
        let userD = UserDefaults(suiteName: "group.Extension_today")
        let str = userD?.value(forKey: "text") as! String
        slidValue.text = str
        completionHandler(NCUpdateResult.newData)
    }
    
    
    其他的使用方式基本和UIKit里面的使用方式一样
 
### 八、 调试

extension和普通app的调试方式差不多，开始调试前先选中extension对应的target，点击run即可

ps: 如果xcode版本为8.0或更低版本, 会需要选择一个host app，这里选择Today。如下图:


 ![图片](/assets/images/today/extension_debug.png)


### 九、 iOS8应用文件系统

发现iOS8的文件系统发生了变化，新的文件系统将可执行文件（即原来的.app文件）从沙盒中移到了另外一个地方，这样感觉更合理。

测试代码
下述代码用于打印App Groups路径、应用的可执行文件路径、对应的Documents路径：


- (void)logAppPath
{
    //app group路径
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.Extension_today"];
    NSLog(@"app group:\n%@",containerURL.path);

    //打印可执行文件路径
    NSLog(@"bundle:\n%@",[[NSBundle mainBundle] bundlePath]);

    //打印documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"documents:\n%@",path);
}

>container app执行结果

*	app group资源目录

"app:Optional(file:///Users/bochb/Library/Developer/CoreSimulator/Devices/1BBE29EA-1192-4477-82CF-C3DD2974C88B/data/Containers/Shared/AppGroup/F190D246-B4F2-4D03-B8D0-19E5203D06A5/)"

*	执行文件目录

"app:/Users/bochb/Library/Developer/CoreSimulator/Devices/1BBE29EA-1192-4477-82CF-C3DD2974C88B/data/Containers/Bundle/Application/AF65AB5B-A78D-4984-989D-7E3D09BAE12E/Today_swift.app"

*	数据保存目录

"app:Optional(\"/Users/bochb/Library/Developer/CoreSimulator/Devices/1BBE29EA-1192-4477-82CF-C3DD2974C88B/data/Containers/Data/Application/0044797E-DC8A-4037-9A7B-91471F7360AA/Documents\")"

>extension执行结果

*	app group资源目录

"extension:Optional(file:///Users/bochb/Library/Developer/CoreSimulator/Devices/1BBE29EA-1192-4477-82CF-C3DD2974C88B/data/Containers/Shared/AppGroup/F190D246-B4F2-4D03-B8D0-19E5203D06A5/)"

*	执行文件目录

"extension:/Users/bochb/Library/Developer/CoreSimulator/Devices/1BBE29EA-1192-4477-82CF-C3DD2974C88B/data/Containers/Bundle/Application/2310ED15-EEB8-42F1-AEFE-272DDA854DC7/Today_swift.app/PlugIns/Today_Extension.appex"

*	数据保存目录

"extension:Optional(\"/Users/bochb/Library/Developer/CoreSimulator/Devices/1BBE29EA-1192-4477-82CF-C3DD2974C88B/data/Containers/Data/PluginKitPlugin/C3573233-F44E-4DB4-82CF-2136E4B4CD39/Documents\")"

***由此可见，不管是extension还是containing app，他们的可执行文件和保存数据的目录都是分开存放的，即所有app的可执行文件都放在一个大目录下，保存数据的目录保存在另一个大目录下，同样，AppGroup放在另一个大目录下。***


### <mark>附件:
#### 1.使用cocoapods给app和extension导入共同的库, Podfile 内容如下:

	# Uncomment the next line to define a global platform for your project
	platform :ios, '9.0'
	#定义主程序pod库
	def host_pods
	    pod 'SSKeychain'
	    pod 'AFNetworking'
	end
	
	#定义extension和主程序共有的pod库
	def shared_pods
	    pod 'MMWormhole', '~> 2.0.0'
	end
	
	
	#extension导入pod库
	target 'Today_Extension' do
	    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	    use_frameworks!
	    shared_pods
	end
	
	#主程序导入的pod库
	target 'Today_swift' do
	    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	    use_frameworks!
	    shared_pods
	    host_pods
	
	    target 'Today_swiftTests' do
	        inherit! :search_paths
	        # Pods for testing
	    end
	    
	    target 'Today_swiftUITests' do
	        inherit! :search_paths
	        # Pods for testing
	    end
	    
	end




>参考资源

>[简书](https://www.jianshu.com/p/e807ee6e46e5)

>[技术博客](http://foggry.com/blog/2014/06/23/wwdc2014zhi-app-extensionsxue-xi-bi-ji/)

>感谢以上文章的作者!