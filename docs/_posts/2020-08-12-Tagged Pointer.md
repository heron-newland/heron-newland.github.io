---
layout: post
title: Tagged Pointer
date:  2020-07-25 10:10:03
categories:
 - tutorial
tags:
 - Skills
---

在调试程序或者反编译App时,经常可以看到"NSTaggedPointerString"这个东西,经过查阅发现从64bit开始，iOS引入了Tagged Pointer技术，用于优化`NSNumber`、`NSDate`、`NSString`等小对象存储,在没有使用`Tagged Pointer`之前，`NSNumber`等对象需要动态分配内存、维护引用计数等，`NSNumber`指针存储的是堆中`NSNumber`对象的地址值.使用`Tagged Pointer`之后，`NSNumber`指针里面存储的数据变成了：`存储数据+TaggedPoint标识`，也就是将数据直接存储在了指针中，`Tagged Pointer`指针的值不再是地址了，而是真正的值。所以，实际上它不再是一个对象了，它只是一个披着对象皮的普通变量而已。所以，它的内存并不存储在堆中，也不需要malloc和free。在内存读取上有着3倍的效率，创建时比以前快106倍。不但减少了64位机器下程序的内存占用，还提高了运行效率。完美地解决了小内存对象在存储和访问效率上的问题。当指针不够存储数据时，才会使用动态分配内存的方式来存储数据.

我们对比一下,使用`Tagged Pointer`与否时内存布局:

**没使用`Tagged Pointer`时**

![tagged_pointer1](/Users/longhe/Documents/Blog/heron-newland.github.io/docs/assets/images/tagged_pointer1.png)

**使用`Tagged Pointer`时**

![tagged_pointer2](/assets/images/tagged_pointer2.png)

简单的说,在64位系统中，一个指针为8字节，当指针关联的值小于8位的时候，系统会将指针转化成Tagged Pointer，并在最后一个bit位加入TaggedPoint标识，这个指针的结构就变成了“0x存储数据+TaggedPoint标识”的结构。看下面的例子就能明白:

```objectivec
NSNumber *number1 = @1;
NSLog(@"number1 pointer is %p", number1);
//打印结果如下
number1 pointer is 0xb000000000000012
```

可以看出取消最前面的`0xb`以及最后一位`TaggedPoint`标记`2`, 那么剩下的就是`number1`的值,正好是`1`.

