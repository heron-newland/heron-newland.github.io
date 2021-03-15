---
layout: post
title:  "NSScanner"
date:   2018-10-28 10:10:03
categories:
 - Skills
tags:
 - Swift
---


Scanner(OC中是NSScanner)继承自NSObject，遵守NSCopying协议。是一个用于扫描字符串的抽象类。Scanner是一个类簇，它管理着很多可以从NSString中扫描出数字值或字符值的私有类。通常拿Scanner对字符串进行比较简单的扫描来获取指定内容（数字值或字符值）。

<!--more-->

### 扫描规则
<mark>**scanner的每个扫描方法都返回是否成功，如果返回成功则scanLocation会往前移动相对应的位置（就是扫出来的内容的长度）,如果返回NO则scanLocation不会变化**。</mark>

### 案例

#### 判断给定扫描的字符串的int值是不是整型
判断给定扫描的字符串的int值是不是整型,可以理解成Int(a)的结果是不是整形, 比如:111返回111, 111e返回111, 1e11返回1
	
	var str1 = "1e118o"
	let scanner1 = Scanner(string: str1)
	var res1:Int = 0
	scanner1.scanInt(&res1)

其他几个类似的Api意思差不多,例如 scanDouble, scanHexFloat等

#### 给定一个字符串，从扫描的字符串中找出相同的

	var str4 = "0x11ikio"
	let scanner4 = Scanner(string: str4)
	var res4:NSString? = nil
	while !scanner4.isAtEnd {
	
	    if scanner4.scanString("k", into: &res4) {//找到了
	
	        break
	    }
	    //没找大小标手动+1
	    scanner4.scanLocation += 1
	}


#### 给定一个集合，从扫描的字符串中找出相同的

	var str5 = "我的体重70KG, 哈哈7K👌gkkkkkkkkkk0"
	let scanner5 = Scanner(string: str5)
	scanner5.caseSensitive = true
	var res5:NSString? = nil
	while !scanner5.isAtEnd {
	    if scanner5.scanCharacters(from: CharacterSet(charactersIn: "我"), into: &res5) {
	        print(res5)
	        print(scanner5.scanLocation)
	        break
	    }
	        scanner5.scanLocation += 1
	}

#### 扫描到给定的字符串后，将从一开始扫描位开始的地方开始截取,并且去掉指定的string(第一个参数);或者是到扫描结束，将字符串末尾往前直到碰到--为止的字符串截取下来。

	var str6 = "我lk-jlk的-体重70KG, 哈-哈7K👌g0"
	//前面加一个特殊字符, 不让其第一个就找到, 因为第一个就找到要特殊处理
	let scanner6 = Scanner(string: "*" + str6)
	scanner6.caseSensitive = true
	var res6:NSString? = nil
	while !scanner6.isAtEnd {
	   let boo = scanner6.scanUpTo("我", into: &res6)
	        if boo {//找到了
	            print(scanner6.scanLocation)
	            print(res6)
	        }
	        //没找到, 下标加1接着找
	         scanner6.scanLocation += 1
	        
	}


<mark>注意事项:要找的字符串在被找的字符串的第一个的时候,会返回false,返回false之后根据扫描规则scanLocation是不会自动加1,所以为了扫描的准确性,我们可以在被扫描字符串的开始添加一个在要找的字符中没有的特殊字符, 让其第一个永远找不到即可</mark>

#### 扫描到给定的字符串后，将从一开始扫描位开始的地方开始截取,并且去掉指定的string(第一个参数);或者是到扫描结束，将字符串末尾往前直到碰到--为止的字符串截取下来。(与scanUpTo(_ string: String, into result: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool 一样)

	var str7 = "我lk-jlk的-体重70KG, 哈-哈7K👌g0"
	let scanner7 = Scanner(string: str7)
	var res7:NSString? = nil
	while !scanner7.isAtEnd {//一直找到结束位置
	    print("开始找:\(scanner7.scanLocation)")
	    //返回扫描结果, 成功scanLocation+1, 失败scanLocation不变
	   let boo = scanner7.scanUpToCharacters(from: CharacterSet(charactersIn: "70"), into: &res7)
	    print("是否找到:\(boo)")
	    print(scanner7.scanLocation)
	    if boo {//找到了
	        
	    }
	    //没找到, 下标加1接着找
	     scanner7.scanLocation += 1
	    print(res7)
	}