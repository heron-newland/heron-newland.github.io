---
layout: post
title:  "map, flatMap, compactMap, filter, reduce的使用"
date:   2018-05-11 10:10:03
categories:
 - Skills
tags:
 - Swift
---

map, flatMap,compactMap, filter, reduce都是针对集合类型的操作(比如数组和字典).这几个函数我们经常用到, 但是刚开始使用的同学们可能会傻傻分不清楚, 这篇文章会详细介绍他们的区别以及用法.

<!--more-->

## map
#### 	字典使用map有两种方式.

方式一: 只改变字典的value

```c
let dict0 = ["a":"1","b":"2"]
//字典的key不变, 根据闭包的规则改变value
let dict1 = dict0.mapValues { value -> Int in
return Int(value)!
}
```
结果如下:

```c
["b": 2, "a": 1]
```

方式二: 将字典变成字典数组, 原来字典中的每一个元素成为数组的一个元素

```c

let dict0 = ["a":"1","b":"2"]
//将字典变成一个字典数组, 每个键值对成为一个数组元素
let dict1 = dict0.map { (a,b) -> [String: String] in
    return [a:b]
}
        
```

结果如下

```c
[["b": "2"], ["a": "1"]]
```

#### 数组使用map的主要用途是遍历数组中的元素, 并对每个元素做变化, 然后返回新的数组

```c
//遍历数组中的每个元素, 并将每个元素和自身相加作为新数组的一个元素
let arr0 = [0,4,1,2,3]
let arr1 = arr0.map { (a) -> Int in
    return a + a
}

```

结果如下:

```c
[0, 8, 2, 4, 6]
```

>同样是实现上面的功能, 我们逐步将map的实现过程简化
未简化前:

```c
let arr1 = arr0.map { (a) -> Int in
    return a + a
}
```

简化一:省略参数a的括号和返回值

```c
let arr1 = arr0.map { a in
    return a + a
}
```

简化二:单行表达式. 如果闭包中时单行表达式, 那么可以写成一行

```c
let arr1 = arr0.map { a in return a + a }
```

简化三: 单行表达式可以进一步简化, 省略return

```c
let arr1 = arr0.map { a in a + a }
```

简化四:参数名称缩写（Shorthand Argument Names），由于Swift自动为内联闭包提供了参数缩写功能，你可以直接使用$0,$1,$2...依次获取闭包的第1，2，3...个参数。

```c
let arr1 = arr0.map { $0 + $0}
```

#### 注意事项
*	 map是对集合元素中每一个元素进行变换, 变换之后集合中元素的个数不会改变,举个栗子

```c
let arr0 = [0,4,1,2,3]
let arr1 = arr0.map {$0 > 3}
```

这段代码很容易误解成, 找出arr0中大于3的元素, 并认为输出结果是[4]. 其实不然, 上面说过, map不会改变集合元素的个数, 只会对集合中元素进行变换, 包括元素类型的变换. `$0 > 3`返回的是bool值, 所以数组中的元素全部变为bool, 那么正确的结果是 `[false, true, false, false, false]`

*	**集合中的元素(不是集合类型)**为可选类型, map后返回的还是可选类型

```c
let arr0: [String?] = ["a","b",nil]
let arr1 = arr0?.map{ $0 + $0}
```

结果如下:

```c
[Optional("a"), Optional("b"), nil]
```

## compactMap
compactMap和map的用法一样, 却别就是compactMap会解包可选类型, 如下
案例一:

```c
let arr00: [String?] = ["aa",nil]
let arr11 = arr00.compactMap{$0}
let arr22 = arr00.map{$0}
print(arr11)
print(arr22)
```
结果如下

```c
["aa"]//compactMap会解包
[Optional("aa"), nil]//map不会解包
```

案例二:
```c
let arr000 = ["1", "2", "three"]
let arr111 = arr000.compactMap{Int($0)}
let arr222 = arr000.map{Int($0)}
print(arr111)
print(arr222)
```

结果如下;

```c
[1, 2]
[Optional(1), Optional(2), nil]
```
通过以上两个简单的案例, 自己就能总结出区别.

## flatMap


flatMap参数为 (Wrapped) -> U?)闭包。对于可选值， flatMap 对于输入一个可选值时应用闭包返回一个可选值，之后这个结果会被压平，也就是返回一个解包后的结果。本质上，相比 map,flatMap也就是在可选值层做了一个解包。

## flatMap的主要作用有2个

*   解包可选类型

集合中的类型为可选类型时, 通过flatMap后会对集合中的类型解包, 剔除为nil的元素. 

例如:
```c
let arr0: [String?] = ["a","b",nil]
let arr1 = arr00.flatMap{$0}
```
结果如下(会将可选类型解包):

```c
["a", "b"]
```

*	扁平化二维数组, 超过二维的数组无法扁平成一维数组

```c
let arr0 = [["a","b"],[1,2]]
let arr1 = arr0.flatMap{$0}
```

结果如下:

```c
["a", "b", 1, 2]
```


## filter
filter的功能很简单, 遍历集合中的每个元素, 经过闭包中的表达式计算时候返回一个bool值. 如果bool为true,那么会将此时遍历的元素添加到新的数组中返回, 如果为false将此元素丢弃.

案例一:找出数组中的偶数
```c
let arr0 = [1,2,3,4,5,6,7,8]
let arr1 = arr0.filter { (a) -> Bool in
    return a % 2 == 0
}
print(arr1)
```

结果如下

```c
[2, 4, 6, 8]
```

## reduce
reduce有两个函数
#### 第一个reduce函数
```c
/*
** initialResult 出入的初始值, 
** nextPartialResult block操作
*/
public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result
 ```  
这个函数的作用时将集合元素以一个初始值(传入的参数), 按照传入的block进行变换返回一个值

案例一: 将字符串数组按一定规则连成一个字符串

```c
let arr00 = ["1","2","3"]
let result = arr00.reduce("") { (res, element) -> String in
		if res == "" {
		    return element
		}
	return res + "." + element
}
print(result)
```

结果入下

```c
1.2.3
```

案例二: 求Int数组的和, 使用上面的简化写法如下

```c
let arr000 = [1,2,3,4,5,6,7,8]
let result = arr000.reduce(0) {$0 + $1}
print(result)
```

第二个reduce函数

```c
 public func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Character) throws -> ()) rethrows -> Result
```
案例三:将 `"abcd"`按照要求转化成一定的字典格式

```c
let letters = "abcd"

let letterCount = letters.reduce(into: [:]) { counts, letter in
    counts[letter, default: 10] += 1
}
print(letterCount)
```

代码解释
`into: [:]` -> 指定变换后返回值的格式为字典类型
`counts` -> 
`counts[letter, default: 10]` -> 

结果入下

```c
["b": 11, "a": 11, "d": 11, "c": 11]
```

