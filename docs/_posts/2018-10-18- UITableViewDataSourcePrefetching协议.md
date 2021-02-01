---
layout: post
title:  "UITableViewDataSourcePrefetching协议"
date:   2018-10-18 10:10:03
categories:
 - UITableView
tags:
 - Swift
---


iOS 应用的目标都是让 UI 跑满60帧， 以达到一个完全平滑滚动的效果。任何帧数明显低于标准值的情况，都会通过掉帧和迟钝的表现性能展示出来。

<!--more-->

如果你处理绘制 UITableView 时用的数据源速度不够快的话，60fps 相当于每帧16.67ms 的时间并不是很充足。获得高性能的诀窍是让 cellForRowAtAtIndexPath 方法尽快的返回一个 cell，但这可能并不容易。比如异步加载图片这样的技术会有一些帮助，但并足以称之为灵丹妙药。Pre-Fetching API对于提高UICollectionView的性能提升是很有帮助的，而且并不需要加入太多的代码。加入少量的代码就可以获得巨大的性能提升！

UICollectionView和UITableView都有类似的协议, 使用方式完全一致.



### 使用方法

使用方法和UITableView的其他代理一样, 都是遵循代理, 实现代理.

#### 实现预加载功能

预加载通过 `tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath])`  方法实现，这里参数传递了一个 NSIndexPaths 数组，包含了每一个即将显示的 cell 所对应的索引路径。
你要做的就是对整个数组进行遍历，然后相应地更新数据源

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
        //更新数据源
            dataSource[indexPath.row] = recievedData
        }
    }

这里有两点需要着重注意：

* 第一点是你应该只更新的底层数据源，而不直接返回任何数据。这可以向更新一个字符串数组一样简单(如上)，或者更复杂一些，比如更新一个 CoreData 或者 Realm Model。

* 第二点要牢记的是，在预加载开始之后，谁也不能保证接收的数据何时或是否会被使用。TableView的滚动速度可能会降下来；或者滚动方向完全相反。

出于这个原因，对于时间敏感的数据可能在它显示的时候已经过时了。你是否需要考虑这个因素当然取决于将要显示的这个数据的性质。

#### 实现取消预加载功能

从一定角度来看，预加载请求只是试图优化未来不确定状态的一种猜测，这种状态可能并不会真实发生。例如，如果滚动速度放缓或者完全反转方向，那些已经请求过的预加载 cell 可能永远都不会确切地显示。
在这种情况下，任何正在执行的预加载操作都将会是白费力气。与其做一些冗余的请求，UITableViewDataSourcePrefetching 协议直接定义了 `tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath])` 这个方法来取消还未完成的请求。
这个方法将在判断当前预加载操作是冗余优化任务时被调用。它用一个参数来传递 NSIndexPaths 数组 ，然后由你来遍历这些数组并取消任何有必要结束的请求。

	 func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
	        //取消一些不会发生的任务
	    }
	    

### 使用注意事项

1. 在我们使用Pre-Fetching API的时候，我们一定要保证整个预加载的过程都放在后台线程中进行。合理使用GCD 和 NSOperationQueue处理好多线程。


2. ，Pre-Fetching API是一种自适应的技术。何为自适应技术呢？当我们滑动速度很慢的时候，在这种“安静”的时期，Pre-Fetching API会默默的在后台帮我们预加载数据，但是一旦当我们快速滑动，我们需要频繁的刷新，我们不会去执行Pre-Fetching API。
3. 用cancelPrefetchingAPI去迎合用户的滑动动作的变换，比如说用户在快速滑动突然发现了有趣的感兴趣的事情，这个时候停下来滑动了，甚至快速反向滑动了，或者点击了事件，进去看详情了，这些时刻我们都应该开启cancelPrefetchingAPI。





