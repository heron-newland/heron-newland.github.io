---
layout: post
title:  "WKWebView及其与H5的交互"
date:   2015-07-12 19:52:13 +0800
categories:
 - Web
tags:
 - OC
---

 iOS 8.0之后 苹果推出的新框架WebKit提供了替换 UIWebView 的组件 WKWebView。各种 UIWebView 的性能问题没有了，速度更快了，占用内存少了，体验更好了，下面列举一些其它的优势:

<!--more-->

- 支持更多的HTML5的特性

- 高达60fps滚动刷新频率与内置手势

- 与Safari相容的JavaScript引擎

- 在性能、稳定性方面有很大提升占用内存更少 

- 可获取加载进度等。

- 协议方法及功能都更细致,将UIWebViewDelegate 与 UIWebView 拆分成了14类与3个协议，包含该更细节功能的实现。

WKWebView和JS交互图如下:

![图片](/assets/images/WebViewAndJS.png)

## 基本使用方法
本文主要说明WKWebView与JS的交互，这里只简单介绍WKWebView基础用法，其他具体详细用法详见官方文档.

	import WebKit
	
	class ViewController: UIViewController {
    
    var web: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //web配置
        let webConfigure = WKWebViewConfiguration()
        //初始化
        web = WKWebView(frame: .zero, configuration: webConfigure)
        //添加视图
        view.addSubview(web)
        //生成请求
        let request = URLRequest(url: URL(string: "http://localhost/message.html")!)
        //加载请求
        web.load(request)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //设置frame
        web.frame = view.bounds
    }
}

### WKWebView的两个代理

#### WKNavigationDelegate主要处理页面跳转相关事件, 和UIWebView差不多

#### WKUIDelegate主要处理一些页面上的交互事件，如警告框、对话框等。具体细节自行学习

## WKWebView与JS的交互(本文重点)

WKWebView与JS交互的所有的操作都是通过WKUserContentController来处理的.WKUserContentController 是 WKWebViewConfiguration 的属性,而WKWebViewConfiguration 是 WKWebView 的属性（也就是在WKWebView实例化的时候传入的configuration, 获取方式如下:

  		let userContentController = web.configuration.userContentController

### WKUserContentController介绍: 

	//添加ScriptMessage（JS事件）和处理者
    open func add(_ scriptMessageHandler: WKScriptMessageHandler, name: String)
	
	//移除指定ScriptMessage（JS事件）监听	
    open func removeScriptMessageHandler(forName name: String)
	//注入JS
	 open func addUserScript(_ userScript: WKUserScript)
	 //删除所有注入的JS
	 open func removeAllUserScripts()
	 
### JS调用原生

ScriptMessage（JS事件）的添加删除

1. 首先在JS代码中加入对事先约定好的 ScriptMessage（JS事件）的调用


		window.webkit.messageHandlers.<事件名>.postMessage(需要传递的数据,如果没有参数就传null)

2. 原生端则需要加入对此JS事件的监听

		例如：传递一个名为 ”showMobile” 的消息


		window.webkit.messageHandlers.closeWindow.postMessage()

3. 原生端添加一个名为 ”showMobile” 的 JS的监听

		 let userContentController = web.configuration.userContentController
		 
		 userContentController.add(self, name: "showMobile")

	> 这里就添加了对 ”showMobile” 的监听。但是当截获 此JS事件的时候需要作何处理，则需要在对应的协议方法中实现，则scriptMessageHandler需要实现协议WKScriptMessageHandler 会在稍后介绍。

4. 通过WKScriptMessageHandler(这是一个协议, 第三部中指定为了self监听 ”showMobile”事件

		  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		  //message.name是监听的方法名称, message.body时监听的方法传递的参数
		        print(message.name)
		       
		    }
    
5. 移除对一个名为 ”showMobile” 的JS事件的监听

		  let userContentController = web.configuration.userContentController
		  userContentController.removeScriptMessageHandler(forName: "showMobile")
        

具体代码如下:
	
	import WebKit
	
	class ViewController: UIViewController {
	    
	    var web: WKWebView!
	    
	    override func viewDidLoad() {
	        super.viewDidLoad()
	       
	        //web配置
	        let webConfigure = WKWebViewConfiguration()
	        //初始化
	        web = WKWebView(frame: .zero, configuration: webConfigure)
	        //添加视图
	        view.addSubview(web)
	        //生成请求
	        let request = URLRequest(url: URL(string: "http://localhost/message.html")!)
	        //加载请求
	        web.load(request)
	        //获取
	        let userContentController = web.configuration.userContentController
	        //添加对名为showMobile方法的监听, 在此方法在js中调用时通知原生
	        userContentController.add(self, name: "showMobile")
	    }
	
	    override func viewDidLayoutSubviews() {
	        super.viewDidLayoutSubviews()
	        //设置frame
	        web.frame = view.bounds
	    }
	    deinit {
	        //移除监听
	        let userContentController = web.configuration.userContentController
	        userContentController.removeScriptMessageHandler(forName: "showMobile")
	    }
	}
	extension ViewController: WKScriptMessageHandler{
	    //监听的回调
	    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
	        print(message.name)
	       
	    }
	}


### 原生调用JS

与UIWebView一样WKWebView可直接调用JS方法

	//alertName()是在js中定义的方法名, '黄飞虎'为参数
	web.evaluateJavaScript("alertName('黄飞虎')") { (data, error) in
	            print(data)
	   }
	        
	        
### 原生为JS定义属性/函数(注入JS)
	        
- 当注入的类型字符串类型时，必须用''括起来。


- OC注入的参数为全局属性，在html中的JS脚本可以直接调用属性名来获取值。

通过String形式，编写JS脚本，通过以下两种方式注入网页

方式一：在初始化WKWebView时，通过配置WKWebViewConfiguration>userContentController注入JS脚本 。

	   let userContentController = web.configuration.userContentController
	        let userScript = WKUserScript(source: "var addredd = '武汉'", injectionTime: .atDocumentStart, forMainFrameOnly: true)
	        userContentController.addUserScript(userScript)


方式二：使用WKWebView实例方法evaluateJavaScript动态注入JS脚本

		
	   web.evaluateJavaScript( "var addredd = '武汉'") { (data, error) in
	            
	        }
        
## WKWebView获取加载通过KVO获取加载进度和标题的方法:

 	web.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)  {
        if  keyPath == "title" {
            navigationItem.title = change?[NSKeyValueChangeKey.newKey] as? String
            
        }else if keyPath == "estimatedProgress" {
            let progress: CGFloat = change?[NSKeyValueChangeKey.newKey] as? CGFloat ?? 0.0
            shapeLayer.strokeEnd = progress
            if progress == 1.0 {
                shapeLayer.strokeEnd = 0
            }else{
                shapeLayer.strokeEnd = progress
            }
        }
        view.layoutSubviews()
    }
    
    deinit {
        web.removeObserver(self, forKeyPath: "title")
        web.removeObserver(self, forKeyPath: "estimatedProgress")
    }
	}
	
## 联系方式

objc_china@163.com

