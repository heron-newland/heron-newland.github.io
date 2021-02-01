---
layout: post
title:  "UICollectionViewCell的移动, 删除, 插入"
date:   2018-04-12 10:32:03
categories:
 - Skills
tags:
 - Swift
---




 UICollectionView中cell的增加, 删除, 移动

<!--more-->

#### 删除和移动使用API很简单,如下
	*	deleteItems(at: [IndexPath])//删除
	* 	insertItems(at: [IndexPath])//增加

使用的具体步骤:

	//删除对应数据源
	dataSource.remove(at: indexPath.item)
	//删除cell				
	deleteItems(at: [indexPath])
	//不需要reload()
	
<b style = "color: red">注意事项: 如果同时存在增加和删除(也就是使用这两个API实现移动), 一定要先删除完成之后再添加, 切记不能先一起删除数据源, 再一起操作items,会挂</b>

<mark>正确方式如下<mark>:

	//先执行完删除操作
	//删除对应数据源
	dataSource.remove(at: indexPath.item)
	//删除cell				
	deleteItems(at: [indexPath])

	//再执行插入操作
	//插入数据源
	dataSource.insert(selected, at: count)
	//插入
	insertItems(at: [IndexPath(item: count, section: 0)])
	
<mark>错误方式如下<mark>:

	//先操作数据源
	dataSource.remove(at: indexPath.item)
	dataSource.insert(selected, at: count)
	
	//再操作item
	deleteItems(at: [indexPath])
	insertItems(at: [IndexPath(item: count, section: 0)])

#### cell的拖动
实现步骤:

*	1. 给`collectionview`添加长按手势

(`UILongPressGestureRecognizer`)来触发拖动.
* 	2. 实现长按手势的事件, 根据长按手势后的移动轨迹移动cell


*  3.设置collectionview能移动cell

			func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		        return true
		    }
		    
		    
*	4.移动cell后跟新数据源


	    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
	        //在此更新数据源, 
	        //从数据源中移除起点数据, 将cell移动到终点位置的数据插入到数据源中
	    }
	    
根据上面的步骤, 主要代码如下:

数据源结构如下:

	  //数据源
	    var data = [["title":"sectionA(长按拖动可以调整顺序)","section":                          ["A","B","C","D","E","F","G","H","I","J","K"]], ["title":"sectionB(点击可以添加到主视图)","section": ["1","2","3","4","5"]], ["title":"sectionC","section":["a","b","c","d","e","f","g"]]]


-	1.给`collectionview`添加长按手势

		 //给collectionview添加长按手势,用来触发移动cell
     	 addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:))))
     	 
-	2.实现长按手势的事件, 根据长按手势后的移动轨迹移动cell

	    //MARK: - 长按手势事件***************************
	    @objc func longPress(sender: UILongPressGestureRecognizer) {
	        var fromPoint: CGPoint, movementPoint: CGPoint
	        switch sender.state {
	        case .began:
	            //起点
	            fromPoint = sender.location(in: sender.view)
	            //找到起点对应的cell的indexPath
	            let indexPath = indexPathForItem(at: fromPoint)
	            //限定只有第一个section能够拖动(第二个section只能点击)
	            guard let index = indexPath else{return}
	            //开始拖动
	            beginInteractiveMovementForItem(at: index)
	        case .changed:
	            //拖动过程轨迹点
	            movementPoint = sender.location(in: sender.view)
	            //轨迹点所在的cell的indexPath
	            let indexPath = indexPathForItem(at: movementPoint)
	            //只能在第一个section里面拖动, 如果超出第一个section就取消cell的移动
	            if let index = indexPath {
	                if index.section > 0 {cancelInteractiveMovement()}
	            }
	            if (sender.view?.point(inside: movementPoint, with: nil))! {
	                //更新被拖动的cell到指定的坐标
	                updateInteractiveMovementTargetPosition(movementPoint)
	            }
	            
	        case .ended:
	            //手势结束时完成cell的移动
	            endInteractiveMovement()
	            
	        case .cancelled , .failed:
	            //手势取消或者失败便取消cell的移动
	            cancelInteractiveTransition()
	        default: break
	        }
	    }
	    
-  3.设置collectionview能移动cell

		func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		        return true
		    }
		    
-	4.移动cell后跟新数据源

	    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
	        //在此更新数据源
	        //1,起始位置更新数据源
	        var sourceDataArr = data[sourceIndexPath.section]["section"] as! [Any]
	        let from = sourceDataArr[sourceIndexPath.item]
	        sourceDataArr.remove(at: sourceIndexPath.item)
	        data[sourceIndexPath.section]["section"] = sourceDataArr
	        
	        //2,结束位置更新数据源
	        var destinationDataArr = data[destinationIndexPath.section]["section"] as! [Any]
	        destinationDataArr.insert(from, at: destinationIndexPath.item)
	        data[destinationIndexPath.section]["section"] = destinationDataArr
	
	    }
	    
demo参考[EditableCollectionView](/Users/bochb/Heron/Test/EditableCollectionView)