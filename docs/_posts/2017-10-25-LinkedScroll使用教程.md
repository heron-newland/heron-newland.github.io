---
layout: post
title:  "LinkedScroll-一款类似主流新闻客户端(板块标题-内容)上下联动的框架"
date:   2017-10-25 15:32:03 +0800
categories:
 - framework
tags:
 - Swift
---





LinkedScroll是一款处理上下联动的使用框架, 因为在开发过程中经常碰到类似的业务需求所以才写了这个库,它不仅适配iPhoneX系列手机, 并且支持屏幕旋转. 使用方法和UITableView的使用方法基本一致. 后期会不断增加新的功能.欢迎各位使用者提出建议和意见.

<!--more-->

## LinkedScroll
![logo](/assets/images/LinkedScroll/Icon.png)


### [github地址](https://github.com/heron-newland/LinkedScroll)

### 基本类介绍
*	HLLScrollTitleView.swift 标题view

*	HLLScrollContentView.swift	内容view

*	HLLScrollViewControllerDelegate.swift 处理标题和内容联动的代理

*	HLLScrollViewDataSource.swift	控件的数据源, 我们必须自己实现数据源方法

*	HLLScrollViewDelegate.swift	控件的代理, 选择实现来获取控件信息

*	HLLScrollView.swift	继承titleView 和 contentView的合成view, 使用此控件的时候主要使用它

*	HLLScrollViewController.swift 集成scrollView的控制器, 我们可以集成自这个类, 实现简单的上下联动的控制器

* HLLTitleView: 自定义titleView中的没有标题的时候使用此类, 继承他然后自定义里面的控件即可

### 集成方法
要求: 
>iOS 9.0或以上

>xCode 9.0或以上

>swift 4.0 或以上


#### 	 手动集成
 
		将LinkedScrollView文件夹手动拖入工程即可
	
#### 	 cocoaPods集成
	
			platform :ios, '9.0'
			
			target 'testMyPods' do
		
			use_frameworks!
			
			pod 'LinkedScroll'
			
			end


### 使用方法

#### 方式一:继承自`HLLScrollViewController`, 实现数据源方法即可, 使用方式可UITableViewController一致, 具体代码如下:

	import UIKit

	class HLLViewController: HLLScrollViewController {

    //备选的数据源
    var data = ["新闻房产", "体育", "房产财经", "房产", "动漫房产", "动漫","新闻房产", "体育"]
    //数据源
    var titles = [String]()
    
    override func viewDidLoad() {
        //给数据源赋值
        titles = data
        super.viewDidLoad()
    }
    
    //刷新数据的方法====================================
    @IBAction func refreshData(_ sender: Any) {
        //模拟更新数据源的逻辑, 此处一般时网络请求
        let i = arc4random_uniform(UInt32(data.count))
        if i == 0 {
            return
        }
        var refreshedTitles = [String]()
        for j in 0..<Int(i) {
            refreshedTitles.append(data[j])
        }
        titles = refreshedTitles
        
        //刷新界面
        reloadData()
    }
    
    //MARK: - dataSource ==============================
    override func scrollTitles(for scrollView: HLLScrollView?) -> [String] {
        return titles
    }
    
    /// 内容数据源
    ///
    /// - Parameter scrollView:
    /// - Returns: 控制器数组, 用于显示内容
    override func scrollContentViewControllers(for scrollView: HLLScrollView?) -> [UIViewController] {
        var controllers = [UIViewController]()
        //这里简单用for循环创建控制器, 具体控制器根据实际情况创建
        for _ in 0 ..< titles.count {
            controllers.append(NewsViewController())
        }
        return controllers
    }
    
    /// 内容控制器的父控制器, 用来添加自控制器,可以不实现, 默认为nil
    override func scrollContentParentViewController(for scrollView: HLLScrollView?) -> UIViewController? {
        return self;
    }
	}


#### 方式二:初始化一个 `HLLScrollView`(继承自UIView),添加到控制的view中即可, 代码 如下:

	import UIKit

	class ViewController : UIViewController, HLLScrollViewDataSource, HLLScrollViewDelegate {
    
       //备选的数据源
    var data = ["新闻","大家都在看", "直播", "体育", "财经", "房产", "动漫", "猜你感兴趣","大家都在看", "直播"]
    //数据源
    var titles = [String]()
    
    /// 懒加载一个HLLScrollView, 并设置相关属性,里面属性可以根据需求灵活定制
    private lazy var scrollView: HLLScrollView = {
        let sView = HLLScrollView()
        //title的高度
        //sView.titleViewHeight = 100.0
        
        //数据源
        sView.dataSource = self
        
        //代理
        sView.delegate = self
        
        //titleView的高度
        //文字高亮颜色, 指示线的颜色默认和高亮文字颜色一致也可以通过scrollTitleView.lineView.backgroundColor属性自行修改
        //sView.scrollTitleView.highlightTextColor = UIColor.red
        
        //文字普通颜色
        //sView.scrollTitleView.normalTextColor = UIColor.gray
        
        //title绘制圆角
        //        sView.scrollTitleView.lineView.layer.cornerRadius = 16
        
        //指示线的高度
        //        sView.scrollTitleView.lineHeight = 44
        
        //指示线背景颜色
        //        sView.scrollTitleView.lineView.backgroundColor = UIColor.blue
        
        //当前选中label放大的增量, 如果设为0.0则不缩放, 默认值为0.0, 不要设置太大, 值太大由于高度不够文字会显示不全
        sView.scrollTitleView.textScaleRate = 0.2
        
        //是否隐藏指示线条
        //sView.scrollTitleView.isIndicatorLineHidden = true
        
        //title的间隔
        sView.scrollTitleView.margin = 30
        //title字体
        sView.scrollTitleView.textFont = UIFont.systemFont(ofSize: 17)
        
        //title背景颜色
        //sView.backgroundColor = UIColor.white
        
        //是否允许左右滑动内容来切换标题标签, 默认为true
        //        sView.scrollContentView.isPanToSwitchEnable = false
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(#imageLiteral(resourceName: "增加-4"), for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        //设置右边的更多按钮
        sView.scrollTitleView.rightView = btn
        
        //markView是否在点击或者滚动到当前title时候隐藏
        // sView.scrollTitleView.isMarkHiddenByTap = false
        
        return sView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titles = data
        view.autoresizingMask = [.flexibleTopMargin, .flexibleHeight]
        view.addSubview(scrollView)
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //设置HLLScrollView对象的frame
        //方式一: 自己计算, 导航栏, tabbar, statusBar的高度
        //scrollView.frame = CGRect(x: 0, y: self.navigateBarHeight() + UIApplication.getStatusBarHeight(), width: view.bounds.width, height: view.bounds.height - self.navigateBarHeight() - self.tabBarHeight() - UIApplication.getStatusBarHeight())
        //方式二, 利用安全区域计算
        scrollView.frame = CGRect(x: safeAreaInset().left, y:  safeAreaInset().top, width: view.bounds.width - safeAreaInset().left - safeAreaInset().right, height: view.bounds.height - safeAreaInset().top - safeAreaInset().bottom)
    }

    //MARK: - dataSource========================
    /// 标题数组:必须实现
    ///
    /// - Parameter scrollView:
    /// - Returns:
    func scrollTitles(for scrollView: HLLScrollView?) -> [String] {
        return titles
    }
    
    /// 控制器数组:必须实现
    /// 标题数组和控制器数组一一对应
    func scrollContentViewControllers(for scrollView: HLLScrollView?) -> [UIViewController] {
        var controllers = [UIViewController]()
        for _ in 0 ..< titles.count {
            controllers.append(NewsViewController())
        }
        return controllers
    }
    
    ///HLLScrollView的父控制器:必须实现
    func scrollContentParentViewController(for scrollView: HLLScrollView?) -> UIViewController? {
        return self;
    }
    
    /// 自定义标题组件数组, 可选:实现
    func scrollTitleViews(for scrollView: HLLScrollView?) -> [HLLTitleView]? {
        var ts = [TitleView]()
        //根据标题初始化titleView中的每一个title视图, 下面简单的使用for循环创建,可以根据实际需求创建
        //TitleView 是每个title的自定义视图, 继承自HLLTitleView
        for (index, _) in titles.enumerated() {
            let tView = TitleView()
            //是否隐藏mark, 实际应用时如果服务器数据有更新可以让mark显示
            tView.isMarkHidden = index % 2 == 0
            ts.append(tView as HLLTitleView as! TitleView)
        }
        return ts
    }
	}
	  
    //MARK: - 右边按钮的点击事件
    @objc func btnClick() {
        //滚动到相应下标
        scrollView.scroll(to: 3)
    }
    

    //更新数据的方法
    @IBAction func reload(_ sender: Any) {
          //模拟更新数据源的逻辑, 此处一般时网络请求
        let i = arc4random_uniform(UInt32(data.count))
        if i == 0 {
            return
        }
        var refreshedTitles = [String]()
        for j in 0..<Int(i) {
            refreshedTitles.append(data[j])
        }
        titles = refreshedTitles
        //刷新界面
        scrollView.reloadData()
    }

    	
####刷新数据源

方式一刷新数据源的方法:

	reloadData()
	
方式二刷新数据源的方法:

	scrollView.reloadData()
   
####  通过HLLScrollViewDelegate代理实现用户交互, 代理方法如下:
 
 
	/// title被点击
	@objc optional func titleScrollView(titleScrollView: UIScrollView, titleLabel: HLLTitleView, tappedIndex: Int)
    
    /// title滑动
    @objc optional func titleScrollViewDidScroll(titleScrollView: UIScrollView)
    
    ///title即将结束滑动
    @objc optional  func titleScrollViewWillBeginDecelerating(titleScrollView: UIScrollView)
    
    ///title结束滑动
    @objc optional  func titleScrollViewDidEndDecelerating(titleScrollView: UIScrollView)
    
    ///title停止拖动
    @objc optional  func titleScrollViewDidEndDragging(titleScrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    ///title开始拖动
    @objc optional  func titleScrollViewWillBeginDragging(titleScrollView: UIScrollView)
    
    
    //content
    ///content滑动
    @objc optional func contentScrollViewDidScroll(contentScrollView: UIScrollView)
    
    ///content即将结束滑动
    @objc optional  func contentScrollViewWillBeginDecelerating(contentScrollView: UIScrollView)
    
    ///content结束滑动
    @objc optional  func contentScrollViewDidEndDecelerating(contentScrollView: UIScrollView)
    
    ///content停止拖动
    @objc optional  func contentScrollViewDidEndDragging(contentScrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    ///content开始拖动
    @objc optional  func contentScrollViewWillBeginDragging(contentScrollView: UIScrollView)
    
    
     	
### 使用技巧
通过改变属性值可以自定义自己想要的样式, 具体属性如下:

* HLLScrollTitleView属性
		
>*	isIndicatorLineHidden: 是否文字下方的指示线是否隐藏, 默认为false(不隐藏)


![无指示线](/assets/images/LinkedScroll/noIndicator.png)

![有线](/assets/images/LinkedScroll/hasIndicator.png)


>*	highlightTextColor: 文字高亮颜色, 指示线的颜色默认和高亮文字颜色一致也可以通过scrollTitleView.lineView.backgroundColor属性自行修改

>*	normalTextColor: 文字普通颜色

![有线](/assets/images/LinkedScroll/changeColor.png)


>*	titleView:整个标题视图, 是` [HLLTitleView]`类型

>*	titleViewHeight: 标题视图的高度

![有线](/assets/images/LinkedScroll/changeH.png)


>*	lineHeight: 指示线的高度

![有线](/assets/images/LinkedScroll/lineH.png)


>*	textScaleRate:当前选中label放大的增量, 如果设为0.0则不缩放, 默认值为0.0, 不要设置太大, 值太大由于高度不够文字会显示不全

![有线](/assets/images/LinkedScroll/textScale.png)


>*	textFont:title字体大小, titleLabel的宽度会随着字体的变化而变化, 但是高度不会变化, 通过`titleViewHeight`属性设置适当的高度

![有线](/assets/images/LinkedScroll/textFont.png)


> *	lineView:指示线, 可以自定义指示线, 或者通过改变其属性定义自己的效果

> *	rightView: titleView右边的视图, 比如可以定义一个按钮, 点击查看所有条目, 如下图中的加号

![有线](/assets/images/LinkedScroll/right.png)


> *	isMarkHiddenByTap: title的标记是否在点击之后消失, 如果为true那么标记视图在点击后会消失, 下图中红点就是标记

![有线](/assets/images/LinkedScroll/mark.png)

 
> *	margin: 每title之间的间距


* HLLScrollContentView属性

>*	isPanToSwitchEnable: 是否允许左右滑动内容来切换标题标签, 默认为true

*	通过属性组合得到的效果

>让指示线的高度等于titleView的高度, 具体组合属性设置ruxia:

		//备注: sView就是HLLScrollView对象
        sView.titleViewHeight = 44
        sView.scrollTitleView.lineView.layer.cornerRadius = 16
        sView.scrollTitleView.lineHeight = 44
        sView.scrollTitleView.lineView.backgroundColor = UIColor.blue


![](/assets/images/LinkedScroll/effect1.png)


*	自定义titleView的方法(如果不设置自定义title, title里面只有一个label), 自定义的方式如下:

>   	 func scrollTitles(for scrollView: HLLScrollView?) -> [String] {
	        let titles = ["新闻","大家都在看", "直播", "体育", "财经", "房产", "动漫", "猜你感兴趣","大家都在看", "直播"]
 			 var ts = [TitleView]()
        //根据标题初始化titleView中的每一个title视图, 下面简单的使用for循环创建,可以根据实际需求创建
        //TitleView 是每个title的自定义视图, 继承自HLLTitleView
        for (index, _) in titles.enumerated() {
            let tView = TitleView(frame: CGRect(x: 0, y: 0, width: 90, height: 40))
            tView.isRightHidden = index % 2 == 0
            ts.append(tView)
        }
      	  scrollView?.scrollTitleView.titleView = ts
      	  return titles
    	}

*	自定义rightView的方式如下:
 
>	      let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
	     btn.setImage(#imageLiteral(resourceName: "增加-4"), for: .normal)
	     btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
	     //sView是HLLScrollView的实例
	     sView.scrollTitleView.rightView = btn

###  联系方式

*	email: objc_china@163.com