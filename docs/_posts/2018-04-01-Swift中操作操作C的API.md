---
layout: post
title:  "Swift中操作操作C的API"
date:   2018-04-01 20:32:03 +0800
categories:
 - Tutorial
tags:
 - Swift
---


就像大多数现在的变成语言一样，在 Swfit 中你就像生活在一个幸福的世界中，这里的内存被额外的部分所管理，而像这样的内存管理语言的编译和运行要么就像 Swift 一样，要么他运行的好坏取决于他的垃圾回收机制。而这些我们所提到的这些隐藏在编程语言中的，你不必要去或者很少的情况下你需要去思考这些问题。

<!--more-->

然而由于 Swift 的多样性的特点，你可能需要调用一个危险的 C 的 Api 比如说 OpenGL 或者 POSIX 中的函数，在这些情况下你可能需要处理一些让我们头疼的情况。没错，我说的就是指针和手动在堆中申请内存空间。

在 Swift 3.0 以前，Swift 的不安全的 API 有点混乱，你可以通过好几个方法来达到相同的结果，但是那只是你从 stackoverflow 上复制、粘贴来的，但是你没有彻底的理解真正发生了什么。在 Swift 3.0 中所有事物都发生了改变，而且他变得更容易理解。

在这篇文章中，我不会告诉你如何将代码从 Swift 2.x 迁移到 Swift 3.0。反而我将会告诉你这些事情在 Swift 3.0 中如何工作，因为<mark>通常造成不安全的引用的主要原因是与 C 的底层 API 的交互<mark>。

让我们从最简单的操作开始——开辟内存空间来存储一个整型变量。

在 C 中，你将会写下下面这样的代码

```c

int *a = malloc(sizeof(int));
*a = 42;
	
printf("a's value: %d",*a)
	
free(a)

```

而这在 Swift 在这么实现的：

```c

let a = UnsafeMutablePointer<Int>.allocate(capacity: 1)
a.pointee = 42
	
print("a's value: \(a.pointee)") //42
	
a.deallocate(capacity:1)

```

<mark>第一类我们所看到的是 Swift 中的 UnsafeMutablePointer<T> ,这普通的结构体相当于一个 T 的指针，正如你所示的，他有一个静态函数， allocate 将会开辟需要的内存空间。<mark>

正如你所想的，这个 UnsafeMutablePointer 还有一个变形—— UnsafePointer ，这个类型不允许你修改指针的值，此外不可修改的 UnsafePointer 甚至没有 allocate 方法。

在 Swift 中，你还有另外一个方法来创建一个 Unsafe[Mutable]Pointer 方法，那就是使用 & 操作。当传一个 block 或者函数，你可以使用一个 & 来传入一个指针。让我们来看下面这个例子

```c
 
func receive(pointer:UnsafePointer<Int>){
  print("param value is:\(pointer.pointee)")    //42
}
	
var a:Int = 42
receive(pointer: &a)

```

& 操作需要一个 var 变量，但是这个将会提供给你你所需要解决的各种情况。比如说，你可以使用可修改的引用（mutable reference），甚至修改它，比如说：

```c

func receive(mutablePointer:UnsafeMutablePointer<Int>){
  mutablePointer.pointee *= 2
}
	
var a = 42
receive(mutablePointer:&a)
print("A's value has changed in the function:\(a)") //84

```
这个例子和前面那个例子有重要的区别。在前面的例子中，我们需要手动开辟内存空间（我们需要在创建好后手动分配内存空间），同时在这个简单的例子中的函数中，我们快速的创建了一个指向内存的指针。明显的，管理内存并且使用指针指向他是2个不同的话题，在接下来的例子中，我们将会聊一聊如何管理内存空间。

但是我们如何在Swift中如何在不创建一个函数的情况下，调用指针。为了达到这种目的，我们需要使用 withUnsafeMutablePointer ，他将会调用一个 Swift 的引用类型和一个有参数的 block ，让我们来看看下面这个例子。

```c
	var a = 42
	withUnsafeMutablePointer(to: &a){ $0.pointee *= 2}
	print("a's value is: \(a)") //84
```

现在我们知道了这个方法，现在我们调用 C 中那些有指针的 API ，让我们看来看下下面这个 POSIX 的打开读取路径并获取其中内容的当前地址的方法。

````c
var dirEnt: UnsafeMutablePointer<dirent>?
var dp:UnsafeMutablePointer<Dir>?
	
let data = ".".data(using:ascii)
data?.withUnsafeBytes({(ptr:UnsafePointer<Int8>) in
    dp = opendir(ptr)
})
	
repeat{
  dirEnt = readdir(dp)
  if let dir = dirEnt{
    withUnsafePointer(to:&dir.pointee.d_name,{ ptr in
      let ptrStr = unsafeBitCase(ptr,to:UnsafePointer<CChar>.self)
      let name = String(cString:ptrStr)
      print("\(name)")
    })
  }
}
	
while dirEnt != nil

````
#### 指针转换

当处理 C 的 API 的时候，你有时候需要将指向结构体的指针转换为不同的结构体。对于 C 的 API 的处理很简单（同时也是十分危险并且容易出现报错）的，就像你在 Swift 中所看到的，所有指针的类型是被固定的，这意味着一个 UnsafePointer<Int> 的指针不能再用在需要 UnsafePointer<UInt8> 的地方，这使得能够更好的编写出更加安全的代码，但是同样意味着你不能在你需要的时候随意转换指针类型。比如说 socket 中的 bind() 方法比如说这些情况下，我们将会使用 withMemoryRebound 这个我们用来将一个指针类型转换为另一个指针类型的方法。让我们来看看我们是如何使用角色转换，在 bind 函数中当你创建一个 sockaddr_in 结构体转换为 sockaddr

```c
var addrIn = sockaddr_in()
// Fill sockaddr_in fields 
withUnsafePointer(to: &addrIn) { ptr in
    ptr.withMemoryRebound(to: sockaddr.self, capacity: 1, { ptrSockAddr in
        bind(socketFd, UnsafePointer(ptrSockAddr), socklen_t(MemoryLayout<sockaddr>.size))
    })
}
```

这个一个用来转变指针类型的特别的方法，一些 C 的 API 需要传一个 void* 指针。在 Swift 3.0 以前，你可能需要使用 UnsafePointer<Void> 。然而在3.0中有一个新的类型来处理这些指针： <mark>UnsafeRawPointer</mark> 。这个结构体和普通的结构体不同，所以这意味着他不会将其中的信息绑定到任何指定的类型中，这另我们的编码过程变得很简单。为了创建一个 UnsafeRawPointer 指针，我们只需要调用它的创建函数来包裹我们所需要的那个指针。如果我们想要用另外的方法，来将这个 UsafeRawPointer 的指针转化为其他类型的指针的时候，我们需要使用 withMemoryRebound 的上一个版本的方法，在这里他叫做 assumingMemoryBound 。

```c
let intPtr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
let voidPtr = UnsafeRawPointer(intPtr)
let intPtrAgain = voidPtr.assumingMemoryBound(to: Int.self)
```

#### 数组指针

到这里，我们我们已经学会了一些指针的基本使用方法，同时你可以处理大多数的 C 的 API 调用。然而指针使用的地方还有很多，比如说遍历内存块，这对于程序员来说是我们可以获得很多重要信息。在 Swift 中我们有一些方法来做这些事情，比如说 UnsafePointer 有提供了一个方法 advanced(by:) 来遍历内存，这个方法返回了另一个 UnsafePointer ，这样我们就可以读写那个内存区域里面的内容。

```c
let size = 10
var a = UnsafeMutablePointer<Int>.allocate(capacity: size)
for idx in 0..<10 {
    a.advanced(by: idx).pointee = idx
}
a.deallocate(capacity: size)
```

另外， Swift 还有一个 UnsafeBufferPointer 的结构体来更方便的实现这个需求。这个结构体是一个Swift数组和指针的桥梁。如果我们使用 UnsafePointer 来作为变量从而调用创建函数创建一个 UnsafeBufferPointer ，我们将能够使用大多数的Swift原生的数组（Array）方法，因为 UnsafeBufferPointer 遵守并实现了 Collections ， Indexable 和 RandomAccessCollection 协议。所以我们可以像这样遍历内存：

```c
// Using a and size from previous code 
var b = UnsafeBufferPointer(start: a, count: size)
b.forEach({
    print("\($0)" // Prints 0 to 9 that we fill previously 
)})
```

当我们提到 UnsafeBufferPointer 的是一个Swift中数组的桥梁的时候，这也意味着我们很容易使用 UnsafeBufferPointer 来调用一个已经存在的数组，比如说下面这个例子：

```c
var a = [1, 2, 3, 4, 5, 6]
a.withUnsafeBufferPointer({ ptr in
    ptr.forEach({ print("\($0)") }) // 1, 2, 3... 
})
```

#### 内存管理带来的危害

我们已经看到了很多方法来引用原始内存，但是我们不能忘记我们正在进入一个危险区域。可能重复 Unsafe 单词可能会提醒我们要小心的使用它们。然而我们我们是使用 unsafe 引用来混合两个世界（不需要内存管理和手动内存管理）。让我们来看看他在我们灵活使用中所带来的危害。

```c
var collectionPtr: UnsafeMutableBufferPointer<Int>?
	
func duplicateElements(inArray: UnsafeMutableBufferPointer<Int>) {
    for i in 0..<inArray.count {
        inArray[i] *= 2
    }
}
	
repeat {
    var collection = [1, 2, 3]
    collection.withUnsafeMutableBufferPointer({ collectionPtr = $0 })
} while false

duplicateElements(inArray: collectionPtr!) // Crash due to EXC_BAD_ACCESS 
```

虽然这个简单的例子我们不会真正的碰到，但是实际在快速创建变量的过程中我们会碰到和他类似但是比他更加复杂的代码。在这里， collection 在一个 block 中被创建，同时在 block 结束后引用被释放。我们有意的在调用 collection 后将引用保存在了 collectoinPtr 中，然后在原始的 collection 不在存在后继续调用，所以程序在调用 duplicateElements(inArray:) 后崩溃了，<mark>如果我们想要使用指针来快速创建变量，我们需要确定这些变量能够在我们需要使用它们的时候可用</mark>。注意ARC将在每个变量离开他的作用于的时候为每个变量添加 release 方法，如果这个变量没有被强引用的话，他就会被释放。

一个解决方法是不适用 Swift 的内存管理方法而是我们自己手动开辟内存空间，就像我们文章中所提到的那些简单的代码一样，这就解决了访问无效引用的问题，但是这引入了另一个问题。如果我们没有手动释放内存，那么就会存在内存泄漏问题。

#### 使用 bitPattern 来修改指针的值

为了更好地完成这篇文章，在这我将介绍一些 Swift 中指针的用法。 第一个就是在使用C的API的时候使用 void* 方法而不是使用内存地址。通常这会发生在一个函数接受不同类型的参数，并简单的将参数打包成 void* 类型，就像下面这个例子一样：

```c
void generic_function(int value_type, void* value);
	
generic_function(VALUE_TYPE_INT, (void *)2);
struct function_data data;
generic_function(VALUE_TYPE_STRUCT, (void *)&data);
```

如果我们想要在 Swift 中调用第一个函数，我们需要使用特别的构造函数，这会创建一个特殊的地址的。所有这些函数将不会改变允许你改变内存地址中变量的值，所以我们将会在这种情况下使用 UnsafePointer(bitPattern:)。

```c
generic_function(VALUE_TYPE_INT, UnsafeRawPointer(bitPattern: 2))
var data = function_data()
withUnsafePointer(to: &data, { generic_function(VALUE_TYPE_STRUCT, UnsafeRawPointer($0)) } )
```

#### 透明指针

在这篇文章的最后我想说的就是如何使用 Swift 中的透明指针。在C的 API 中我们经常会调用用户数据，而用户的数据将会成为一个 void* 指针，该用户数据将是一个 void * 指针，他将保存在一个任意内存中。一个通用的使用方法是当处理函数并设置回调方法的时候，事件将会被调用。在这种情况下，传入一个引用到一个 Swift 对象中，然后我们就可以在 C 的回调函数中调用指针的方法。

我们能够使用 UnsafeRawPointer 就像我们曾在这篇文章中的其他例子中所看到的。然而正如我们所看到的，这些调用在内存管理中有一定的问题，当我们传入一个指针到 C 中来指向一个我们没有 retain 的变量的时候，这个对象将被释放，同时这个程序将会崩溃。

Swift 有一个实用的方法来根据我们是否真的需要，从而决定指向这个对象的指针是否进行 retain 。这就是 Unmanaged 结构体的一个静态函数。使用 passRetained() 我们将会创建一个被 retained 的指向这个对象的指针，那么我们就能保证当他在 C 中被调用的时候他仍旧在那。当这个对象已经在回调函数中被 retianed 的时候我们可以使用 passUnretained() 。这两个方法将会产生 Unmanaged 的实例变量，这个实例变量将会通过调用 toOpaque() 方法转换为 UnsafeRawPointer

在另一方面我们可以将 UnsafeRawPointer 通过相反的 API fromOpaque() 和 takeRetained() 转换为一个类或者结构体

```c
void set_callback(void (*functionPtr)(void*), void* userData));

struct CallbackUserData {
    func sayHello() { print("Hello world!" ) }
}
	
func callback(userData: UnsafeMutableRawPointer) {
    let callbackUserData = Unmanaged.fromOpaque(userData).takeRetainedValue()
	
    callbackUserData.sayHello() // "Hello world!" 
}
	
var userData = CallbackUserData()
let reference = Unmanaged.passRetained(userData).toOpaque()
set_callback(callback, reference)
```

#### 总结

正如你所看到的，调用 C 的代码在 Swift 是可行的，同时知道了有这些方法使得我们不需要用大量的代码就能实现我们想要的效果。不安全和非管理的 API 在本文中被大量的提到，但是我希望这是一个很好的进行深入了解的机会，从而你可以对他感兴趣或者能够真正的使用它。

