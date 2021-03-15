---
layout: post
title:  "React Cocoa简单使用手册"
date:   2017-08-25 17:32:53 +0800
categories:
 - React
tags:
 - OC
---

在绘制UI时，我们常希望能够直接获取所需数据，但大多数情况下，数据需要经过多个步骤处理后才可使用，好比UI使用到的数据是经过流水线加工后最后一端产出的成品。众所周知，流水线是由多个片段管线组成，上端管线处理后的已加工品成为下端管线的待加工品，每段管线都有对应的管线工人来完成加工工作，直至成品完成。

<!--more-->

RAC则为我们提供了构建数据流水线的能力，通过组合不同的加工管线来导出我们想要的数据。想要构建好RAC的数据流水线，我们需要先了解流水线中的组成元素——RAC管线。RAC管线的运作实质上就是RAC中一个信号被订阅的完整过程。下面我们来分析下RAC中一个完整的订阅过程，并由此来了解RAC中的核心元素。



RAC核心是Signal，对应的类为RACSignal。它其实是一个信号源，Signal会给它的订阅者（Subscriber）发送一连串的事件，一个Signal可比作流水线中的一段管线，负责决定管线传输什么样的数据。Subscriber是Signal的订阅者，我们将Subscriber比作管线上的工人，它在拿到数据后对其进行加工处理。数据经过加工后要么进入下一条管线继续处理，要么直接被当做成品使用。

[关于ReactiveCocoa信号订阅的基本过程的具体信息参见美团技术博客文章](https://tech.meituan.com/ReactiveCocoaSignalFlow.html)

###使用pod管理 OC版本和Swift版本
- 纯OC使用 2.1.8
- 纯Swift 使用最新版本,注意与Swift版本兼容问题
- OC和Swift混编, 分别pod OC和Swift版本到项目中

###  下面先从几个UI控件使用RAC入手, 简单介绍一下RAC, 后面会有RAC高级用法
 
###UIButton使用RAC
UIButton有两种使用RAC的方法:

####方式一:此种方式能控制按钮的状态, 而且状态也是一个信号

	
    /**
     enable表示按钮是否可用,
     */
    RACCommand *btnSignal = [[RACCommand alloc] initWithEnabled:nil signalBlock:^RACSignal *(UIButton *input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //按钮点击事件
             NSLog(@"clicked===%@",input);
            //模拟延时
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //点击事件处理完毕调用, 恢复按钮可点击的状态
                [subscriber sendCompleted];
            });
            
            return [RACDisposable disposableWithBlock:^{
               //点击事件全部处理完成之后,释放资源
                NSLog(@"release");
            }];
        }];
    }];
    
    [btn setRac_command:btnSignal];
    
####方式二:
-  使用RAC UIControl的分类


		[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
         NSLog(@"clicked===%@",x);
  		  }];
    
    
###UITextField
- 方式一:监听RAC给UITextField添加的分类属性, 来监听文字的变化

  		//检测文字的变化1
  	 	 [field.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
   		 }];

- 方式二:使用RAC UIControl的分类,来监听

 		[[field rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField *field) {
        NSLog(@"%@",field.text);
 		   }];	
 		   
- 方式三:rac实现协议的方法

	    //rac实现协议的方法
	    //设置代理, 必须设置
	    field.delegate = self;
	    //rac信号绑定
	    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
	        UITextField *t = x[0];
	          NSLog(@"%@",t.text);
	    }] ;
	    
###UIAlertView

	- (void)alertViewRAC{
	    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
	    [alert show];
	    [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *buttonIndex) {
	        //根据按扭点击索引, 实现按钮的点击事件
	        NSLog(@"%@",buttonIndex);
	        if (buttonIndex.integerValue == 0) {//取消
	            
	        }
	        if (buttonIndex.integerValue == 1) {//确定
	            
	        }
	    }];
	}
	
###KVO
- 直接实现

		  //KVO监听
		    [[self rac_valuesForKeyPath:@"text" observer:nil] subscribeNext:^(id x) {
		        NSLog(@"%@",x);
		        
		    }];
	    
- 使用宏RACObserve实现KVO

		 [RACObserve(self, text) subscribeNext:^(id x) {
		           NSLog(@"%@",x);
		    }];
		    
		    

###多信号合并combine 和 merge的区别
- combine:所有信号都完成(至少发送过一次sendNext:)之后将结果合并成一个tuple返回, 使用方法如下:

		  [[RACSignal combineLatest:@[signal1, signal2]] subscribeNext:^(id x) {
		        NSLog(@"%@",x);
		    }];
    
- merge:只要有一个信号完成, 就将结果返回

		 [[RACSignal merge:@[signal1, signal2]] subscribeNext:^(id x) {
		        NSLog(@"%@",x);
		    }];
	
###RAC同步和异步执行
- 同步执行

		 [[signal1 concat:signal2] subscribeNext:^(id x) {
		        NSLog(@"%@",x);
		    }];
    

- 异步执行

		 [[RACSignal merge:@[signal1, signal2]] subscribeNext:^(id x) {
		        NSLog(@"%@",x);
		    }];
	    
###RAC中的常用宏

- RACObserve

		//观察self中text属性的变化,		
		 [RACObserve(self, text) subscribeNext:^(id x) {
		           NSLog(@"%@",x);
		    }];
- RAC 

	     //将self的text属性和文本框的信号绑定, 只要文本框的文本发生变化, 那么就会将文本框的值赋值给self的text属性     
		 RAC(self, text) = field.rac_textSignal;

- RACChannelTo: 实现绑定的一种方式

		//将A的text属性的值与B的text绑定
		RACChannelTo(_textA, text) = [_textB rac_newTextChannel];
###@weakify() 和 @strongify()
RAC的所有block中使用self都会出现循环引用, 所有要使用@weakify和@strongify来防止循环引用, 使用方法如下:

	 weakify(self);
	    self.foo = ^{
	        strongify(self)
	        self.text = @"";
	    };
			    
###RAC的副作用以及冷热信号
副作用的产生和冷信号有关, 下面先介绍一下冷信号, 和热信号.详细介绍参见美团技术团队的技术博客:

1. [细说ReactiveCocoa的冷信号与热信号(一)](https://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-1.html)
1. [细说ReactiveCocoa的冷信号与热信号(二):儿什么要区分冷信号和热信号](https://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-2.html)
1. [细说ReactiveCocoa的冷信号与热信号(三):怎么处理冷信号和热信号](https://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-3.html)
 
这里我简单的总结一下:
##### 冷信号
1. 在被订阅后才会发送信号, 没有订阅者不会发送信号.(被动)
2. 冷信号有多个订阅者时, 消息是重新, 完整的发生一遍.
3. 订阅者都能收到完整的信息,也就是说订阅者能收到其订阅此信号前和订阅此信号后的全部消息.
4. 除了**RACSubject及其子类**的信号都是冷信号.

##### 热信号
1. 不被订阅也会主动发送信号.(主动)
1. 有多个订阅者时, 是多个订阅者共享消息
1. 订阅者只能收到订阅后的信息
1. **RACSubject及其子类**的信号都是热信号.

所以subject类似“直播”，错过了就不再处理。而signal类似“点播”，每次订阅都会从头开始。所以我们有理由认定subject天然就是热信号。

#### 冷信号转化成热信号: publish, multicast, replay, replayLast, replayLazily
冷信号转成热信号的原理是使用hotSignal(RACSubject)订阅coldSignal(冷信号), 然后在订阅此hotsignal信号, 就能将coldSignal转化成hotSignal.有如下一系列的API能完成此功能:
    
`- (RACMulticastConnection *)publish;`

`- (RACMulticastConnection *)multicast:(RACSubject *)subject;`

`- (RACSignal *)replay;`

` - (RACSignal *)replayLast;`

` - (RACSignal *)replayLazily;`

>每次订阅一个信号, 信号里面的代码就会重复执行一次,可能得到意想不到的错误信息, 当然副作用页可以加以利用


* 解决副作用的方法很简单, 只要在信号后加上 replyLast, 代码如下:

		//重复订阅一个信号会重复执行信号里的内容
		- (void)sideEffect {
		    __block NSInteger a = 1;
		    RACSignal *signal1 = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		            a++;
		            [subscriber sendNext:@(a)];
		            [subscriber sendCompleted];
		        });
		        return [RACDisposable disposableWithBlock:^{
		            NSLog(@"release");
		        }];
		    }] replayLast];//解决副作用的方法replayLast
		    
		    [signal1 subscribeNext:^(id x) {
		        NSLog(@"%@",x);
		    }];
		    [signal1 subscribeNext:^(id x) {
		        NSLog(@"%@",x);
		    }];
		    [signal1 subscribeNext:^(id x) {
		        NSLog(@"%@",x);
		    }];
		}
	
* 解决方法二

		 - (void)RACMulticastConnectionAction{
		    __block int a = 0;
		   RACSignal *s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		       a++;
		        [subscriber sendNext:@(a)];
		        //完成后才会执行concat, 否则不执行
		        [subscriber sendCompleted];
		        return nil;
		    }];
		   RACMulticastConnection *connect = [s1 multicast:[RACReplaySubject subject]];
		    [connect connect];
		    [connect.signal subscribeNext:^(id x) {
		          NSLog(@"%@",x);
		    }];
		    [connect.signal subscribeNext:^(id x) {
		        NSLog(@"%@",x);
		    }];
		}	
###定时器事件
- 延时执行

		 //延时执行
		    [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
		        NSLog(@"3 delays");
		    }];
		    
- 定时执行
1. 
		   //定时执行
		    //takeUntil方法, 防止控制器pop之后定时器仍然执行
		    [[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
		        NSLog(@"每两秒一次");
		    }];
		    
		    
### 双向绑定
- 方式一:最笨, 也是最安全的方式.

		   RACChannelTerminal *Asignal = [_textA rac_newTextChannel];
		    RACChannelTerminal *Bsignal = [_textB rac_newTextChannel];
		    [Asignal subscribe:Bsignal];
		    [Bsignal subscribe:Asignal];
		    
- 方式二:推荐的方式:

	    RACChannelTo(_textA, text) = [_textB rac_newTextChannel];
	    RACChannelTo(_textB, text) = [_textA rac_newTextChannel];
	    
- 方式三:最优雅但是会有漏洞的方法.因为RAC是完全基于KVO的, 而有UI控件不支持KVO, 所以会有漏洞. 如果双向绑定与UI没有关系,那么推荐使用此方法.    
`RACChannelTo(_textA, text) = RACChannelTo(_textB, text)`	

>如果使用此方法将两个UI控件绑定, 那么在UI界面中, 改变其中一个文本框的值另一个文本框是不会跟着改变的, 这也就是我上面提到的bug, 但是如果使用代码修改文本框的值, 那么另一个文本款的值会跟随前面的改变

		RACChannelTo(_textA, text) = RACChannelTo(_textB, text);
		//_textB.text = @"aaaq";
		
### RACChannelTerminal



### replay, replayLast, replayLazily
>ReactiveCocoa提供了这三个简便的方法允许多个订阅者订阅一个信号，却不会重复执行订阅代码，并且能给新加的订阅者提供订阅前的值。replay和replayLast使信号变成热信号，且会提供所有值(-replay) 或者最新的值(-replayLast) 给订阅者。 replayLazily返回一个冷的信号，会提供所有的值给订阅者。

#### replay
>- 当源信号被订阅时，会立即发送给订阅者全部历史的值，不会重复执行源信号中的订阅代码，不仅如此，订阅者还将收到所有未来发送过去的值。那么能接受到的值就是<b style="color: red">历史信息的所有值和所有未来值</b>

#### replayLast
>当源信号被订阅时，会立即发送给订阅者***最新的值***，不会重复执行源信号中的订阅代码。订阅者还会收到信号未来所有的值。那么能接受到的值就是<b style="color: red">历史信息的最新值和所有未来值</b>

#### replayLazily
>这replayLazily方法返回一个新的信号，当源信号被订阅时，会立即发送给订阅者全部历史的值，不会重复执行源信号中的订阅代码。跟replay不同的是，replayLazily被订阅生成新的信号之前是不会对源信号进行订阅的（原文写的有点绕，简单来讲 直到订阅时候才真正创建一个信号，源信号的订阅代码才开始执行）。那么能接受到的值就是<b style="color: red">没搞明白, 慎用</b>


语法如下, 以replay为例, 其他一样

	/**
	 防止重复订阅产生副作用,当一个信号被多次订阅,反复播放内容
	 */
	- (void)replayAction{
	    __block int a = 10;
	   RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	        a++;
	        [subscriber sendNext:@(a)];
	       
	        return [RACDisposable disposableWithBlock:^{
	            NSLog(@"dealloc");
	        }];
	    }] replay];
	    //多次订阅 a的值都为11, 不会一直垒加
	    [signal subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	    [signal subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	    [signal subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	}

### retry
>***只要失败, 或者在调用[subscriber sendCompleted]之前***，就会重新执行创建信号中的block,直到成功或者完成.

	- (void)retryAction{
	    __block int count = 0;
	    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	        if (count < 10) {
	            count ++;
	            NSLog(@"failed");
	            [subscriber sendError:nil];
	        }else{
	            NSLog(@"after 10 failure");
	            [subscriber sendNext:nil];
	            [subscriber sendCompleted];
	        }
	        return [RACDisposable disposableWithBlock:^{
	            NSLog(@"dealloc");
	        }];
	    }] retry] subscribeNext:^(id x) {
	         NSLog(@"successed");
	    }];
	}

### throttle节流
>throttle节流: 当某个信号发送比较频繁时，可以使用节流.如果发送信号的时间间隔小于throttle的时间间隔, 那么信号不会被发送, 如果信号信号发送之间的时间间隔大于throttle的时间, 信号就会被立即发送, 并且发送的是最新的那一条信号的信息。

	 //以文本框的输入为例子.
	 //以文本框的输入为例, 如果用户的输入两个字符之间的时间间隔小于2秒, 那么不会发送信号
	 //如果用户输入两个字符之间的时间间隔大于2秒, 那么会立即将最新的信息发送.
    [[self.text.rac_textSignal throttle:2] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
	[[self.text.rac_textSignal throttle:2] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];

> throttle 带条件的方法:- (RACSignal *)throttle:(NSTimeInterval)interval valuesPassingTest:(BOOL (^)(id next))predicate;

	//当valuesPassingTest的返回值为yes才会执行throttle的间隔, 否则立马发送信号
	 [[self.text.rac_textSignal throttle:2 valuesPassingTest:^BOOL(id next) {
	        return [next floatValue] > 5000;
	    }] subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];

### timeout
可以让一个信号在一定的时间后，自动报错

	- (void)timeOutAction {
	    RACSignal *s = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	        [subscriber sendNext:@"1"];
	//        [subscriber sendCompleted];
	        return [RACDisposable disposableWithBlock:^{
	            NSLog(@"dealloc");
	        }];
	    }] timeout:3 onScheduler:[RACScheduler mainThreadScheduler]];
	    [s  subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	    [s subscribeError:^(NSError *error) {
	        NSLog(@"%@",error);
	    }];
	}

### interval
每隔一段时间发出信号, 定时器

	- (void)intervalAction{
	    RACSignal *s = [[RACSignal  interval:2 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal];
	    [s subscribeNext:^(id x) {
	         NSLog(@"%@",x);
	    }];
	}


### delay
延时发送next

	- (void)delayAction {
	    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	        [subscriber sendNext:@"1"];
	        return [RACDisposable disposableWithBlock:^{
	            NSLog(@"dealloc");
	        }];
	    }] delay:2] subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	}


### filter
filter:过滤信号，使用它可以获取满足条件的信号.

	// 每次信号发出，会先执行过滤条件判断.
	[_textField.rac_textSignal filter:^BOOL(NSString *value) {
	       return value.length > 3;
	}];


### ignore
ignore:忽略完某些值的信号.

	   // 内部调用filter过滤，忽略掉ignore的值,如果发送的值和忽略的值相等, 订阅者不会收到信息
	   [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	        [subscriber sendNext:@"10"];
	        return [RACDisposable disposableWithBlock:^{
	            NSLog(@"dealloc");
	        }];
	    }] ignore:@"10"] subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];


### distinctUntilChanged
当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。

	//举个栗子:你在文本框中输入'aaa', 然后再通过代码设置文本框的text为'aaa', 那么订阅则不会受到任何信息
	[[[_text.rac_textSignal merge:RACObserve(_text, text)] distinctUntilChanged] subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];

### take
从开始起一共取n次的信号

	- (void)takeAction{
	    RACSubject *sub = [RACSubject subject];
	    [[sub take:2] subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	    [sub sendNext:@"0"];
	    [sub sendNext:@"1"];
	}

### takeLast
取最后N次的信号,<b style="color:red">前提条件，订阅者必须调用完成</b>，因为只有完成，就知道总共有多少信号.

	- (void)takeLastAction {
	    RACSubject *sub = [RACSubject subject];
	    //取最后两次的信号
	    [[sub takeLast:2] subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	    [sub sendNext:@"0"];
	    [sub sendNext:@"1"];
	    [sub sendNext:@"2"];
	    //一定要调用完成, 因为只有调用完成才知道哪个才是最后的信号
	    [sub sendCompleted];
	}


### takeUntil
一直获取信号直到某个信号执行完成

	- (void)takeUntilAction {
	    [[_text.rac_textSignal takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	}

### skip
从开始跳过几个信号, 然后才开始监听

	/**
	 从开始跳过几个信号, 然后才开始监听
	 */
	- (void)skipAction {
	    RACSubject *sub = [RACSubject subject];
	    //跳过前两次的信号
	    [[sub skip:2] subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	    [sub sendNext:@"0"];
	    [sub sendNext:@"1"];
	    [sub sendNext:@"2"];
	}


### flatten
只能用于信号中的信号, 订阅者能获取信号中的信号的所有信息.

	- (void)flattenAction {
	        RACSubject *sub1 = [RACSubject subject];
	        RACSubject *sub2 =  [RACSubject subject];
	        RACSubject *signalOfSignal = [RACSubject subject];
	    //flatten能获取信号中的信号的所有信息, 也就是sub1,sub2发送的信息, @"4","1"
	        [[signalOfSignal flatten] subscribeNext:^(id x) {
	            NSLog(@"%@",x);
	        }];
	        //信号发送信号(称之为信号的信号)
	        [signalOfSignal sendNext:sub1];
	        [signalOfSignal sendNext:sub2];
	        [sub2 sendNext:@"4"];
	        [sub1 sendNext:@"1"];   
	}


### switchToLatest
 switchToLatest只能用于signalOfSignals（信号的信号），switchToLatest的作用就是<b style="color:red">获得信号中的信号的最新信号所发的信息(一个信号订阅了多个信号之后, 将多个信号中的最后一个信号的信息发送给下一个订阅者). switchToLatest必须用于信号中的信号, 否者会崩溃.</b> switchToLatestatten和flatten的作用都是获取信号中的信号, 区别就是前者是获取信号中的信号的最新信号的信息, 后者是获取信号中的信号的所有信息
 
	 /**
	 switchToLatestAction
	 
	 用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号
	 */
	- (void)switchToLatestAction {
	    RACSubject *sub1 = [RACSubject subject];
	    RACSubject *sub2 = [RACSubject subject];
	    RACSubject *signalOfSignal = [RACSubject subject];
	    [[signalOfSignal switchToLatest] subscribeNext:^(id x) {
	         NSLog(@"%@",x);
	    }];
	    //信号又发送了两个信号:sub1和sub2(称之为信号的信号), 那么信号中的信号的最新信号就是sub2
	    //信号中的信号的最新信号所发的信息就是@"4",经过switchToLatest之后订阅者获得信息就是@"4"
	    [signalOfSignal sendNext:sub1];
	    [signalOfSignal sendNext:sub2];
	    [sub2 sendNext:@"4"];
	    [sub1 sendNext:@"1"];
	}
 




###  combineLatest
combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。

### zipWith
把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件

	/**
	 只有所有zip中的所有信号都发送消息之后才会调用zip后的block, 可用于多个网络请求完成之后再做另一件事的场景
	 */
	- (void)zipAction {
	    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	            
	            //延时发送信号, 只有这个信号发送后才会调用zip后的信号block
	            [subscriber sendNext:@"1"];
	        });
	        return nil;
	    }];
	    
	    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	        [subscriber sendNext:@"2"];
	        return nil;
	    }];
	    
	    [[signal1 zipWith:signal2] subscribeNext:^(id x) {
	         NSLog(@"%@",x);
	    }];
	}


### merge
把多个信号合并为一个信号，任何一个信号有新值的时候就会调用

	  // 合并信号,任何一个信号发送数据，都能监听到.
	    RACSignal *mergeSignal = [signalA merge:signalB];


### then
用于连接两个信号，当<b style="color:red">第一个信号完成，才会连接then返回的信号</b>
then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号.
使用then连接信号，<b style="color:red">之前信号的值会被忽略掉, 只会返回then的信号值</b>.

	/**
	 只有第一个信号完成, 才会执行then的信号, 并且执行then后会丢弃前面的信号,只能订阅到then之后的信号
	 */
	- (void)thenAction {
	    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	        [subscriber sendNext:@"0"];
	        //完成后才会执行then, 否则不执行
	        [subscriber sendCompleted];
	        return nil;
	    }] then:^RACSignal *{
	        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	            [subscriber sendNext:@"2"];
	            return nil;
	        }];
	    }] subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	}



### concat
concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号
注意: <b style="color:red">使用concat连接的信号和使用then连接的信号都是要在前一个信号发送完毕之后(sendCompleted),才会执行concat或者then后的信号</b>

	- (void)concatAction {
	    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	        [subscriber sendNext:@"0"];
	        //完成后才会执行concat, 否则不执行
	        [subscriber sendCompleted];
	        return nil;
	    }] concat:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	            [subscriber sendNext:@"2"];
	        [subscriber sendCompleted];
	            return nil;
	        }]
	    ] subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	}

### map, flattenMap
flattenMap，Map用于把源信号内容映射成新的内容    
FlatternMap和Map的区别

1.FlatternMap中的Block返回信号。    
2.Map中的Block返回对象。    
3.开发中，如果信号发出的值不是信号，映射一般使用Map    
4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。    


### scanWithStart
常用于信号输出值的聚合处理,也就是将上一次的输出结果, 当做参数传入下一次处理中.应用场景举例:没有做本地保存的下拉刷新和上拉加载更多可以使用scanWithStart将数据进行连接

	- (void)scanWithStartAction {
	    //数组转化成RACSequence
	    RACSequence *squ = @[@1,@2,@3,@4].rac_sequence;
	    //runing中的值就是上次return的结果, 第一次running的值就是start的值
	    RACSequence *squ2 = [squ scanWithStart:@0 reduce:^id(id running, id next) {
	        return @([running integerValue] + [next integerValue]);
	    }];
	    //遍历RACSequence
	    for (NSNumber *nun in squ2.objectEnumerator) {
	        NSLog(@"%@",nun);
	    }
	    //订阅RACSequence的信号
	    [squ2.signal subscribeNext:^(id x) {
	        NSLog(@"%@",x);
	    }];
	}
`输出的结果为1,3,6,10`


### deliverOnMainThread, deliverOn 和 subscribeOn
都是将信号发送到所需的线程.前两者就是讲信号的结果传递到所需的线程中, 但是副作用还是在原来的线程中, 而subscribeOn是将信号的订阅过程都放在所需的线程中, 自然副作用也是在所需的线程中.(所需的线程是开发者根据需求指定的线程)


###综合案例(来自美团技术博客):
>
需求: 用户在searchBar中输入文本，当停止输入超过0.3秒，认为seachBar中的内容为用户的意向搜索关键字searchKey，将searchKey作为参数执行搜索操作。搜索内容可能是多样的，也许包括搜单聊消息、群聊消息、公众号消息、联系人等，而这些信息搜索的方式也有不同，有些从本地获取，有些是去服务器查询，因此返回的速度快慢不一。我们不能等到数据全部获取成功时才显示搜索结果页面，而应该只要有部分数据返回时就将其抛到主线程渲染显示。在这个需求中，从数据输入到最后搜索数据的显示可以具象成一条数据流，数据流中各处对于数据的操作都可以使用上面提到的RAC Operation来完成，通过组合Operation完成以下RAC数据流图

####实现方法:

	[[[self.searchBar rac_textSignal]
	throttle:0.3]
	subscribeNext:^(NSString*keyString) {
	    RACSignal *searchSignal = [self.viewModel createSearchSignalWithString:keyString];
	
	    [[[searchSignal
	    scanWithStart:[NSMutableArray array] reduce:^NSMutableArray *(NSMutableArray *running, NSArray *next) {
	        [running addObjectsFromArray:next];
	        return running;
	    }]
	    deliverOnMainThread]
	    subscribeNext:^(id x) {
	        // UI Processing
	    }];
	}];   
   
   
   
### RACCommond                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
### RACDisposable

### RACScheduler

### RACMulticastConnection

### RACReplaySubject

### RACSubject的使用方法
>1. 创建一个RACSubject的实例；
>2. 订阅subject的dealloc信号，在subject被释放的时候会发送完成信号；
>3. 订阅subject；
>4. 使用subject发送一个值。

	- (void)viewDidLoad {
	    [super viewDidLoad];
	    RACSubject *subject = [RACSubject subject]; //1
	    [subject.rac_willDeallocSignal subscribeCompleted:^{ //2
	        NSLog(@"subject dealloc");
	    }];
	    [subject subscribeNext:^(id x) { //3
	        NSLog(@"next = %@", x);
	    }];
	    [subject sendNext:@1]; //4
	}

#### RACSignal和RACSubject虽然都是信号，但是它们有一个本质的区别：
>RACSubject会持有订阅者（因为RACSubject是热信号，为了保证未来有事件发送的时候，订阅者可以收到信息，所以需要对订阅者保持状态，做法就是持有订阅者），而RACSignal不会持有订阅者。    

#### RACSignal的引用图如下
![RACSignal](/Users/bochb/Downloads/3.png)

#### RACSubject的引用图如下
![RACSubject](/Users/bochb/Downloads/4.png)

### [RAC内存泄露和解决方案](https://tech.meituan.com/potential-memory-leak-in-reactivecocoa.html)
#### - flatmap, map,RACObserver都会隐式的持有self, 所以在block中使用上面这些放方法的时候一定要使用weakSelf解决循环引用的问题.使用方法如下:

	- (void)viewDidLoad
	{
	    [super viewDidLoad];
	    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
	        GJModel *model = [[GJModel alloc] init];
	        [subscriber sendNext:model];
	        [subscriber sendCompleted];
	        return nil;
	    }];
	    @weakify(self); //
	    self.signal = [signal flattenMap:^RACStream *(GJModel *model) {
	        @strongify(self); //
	        return RACObserve(model, title);
	    }];
	    [self.signal subscribeNext:^(id x) {
	        NSLog(@"subscribeNext - %@", x);
	    }];
	}
	
#### -RACSubject造成block不被释放的解决办法

>其实在ReactiveCocoa的实现中，几乎所有的操作底层都会调用到bind这样一个方法，包括但不限于：
`map、filter、merge、combineLatest、flattenMap ……`

>所以在使用ReactiveCocoa的时候也一定要仔细，**对信号操作完成之后，记得发送完成信号**，不然可能在不经意间就导致了内存泄漏。

>RACSubject就是一个比较典型直接的例子。除此之外，如果在对一个信号进行类似***replay***这样的操作之后，也**一定要保证源信号发送完成**；不然，也是会有内存泄漏的。




## RAC使用注意事项
### rac_textSignal监听文本框的text, 通过代码改动text的值不会调用block的值

	[_text.rac_textSignal subscribeNext:^(id x) {
	            NSLog(@"%@",x);
	        }];
	        
> 原因: 看看源码实现可知此方法主要是实现textfield的代理方法, 所有用代码修改text的值是不会触发代理方法的

然而, 使用RACObserve只能监听通过代码改动的变化, 所以最佳的解决方案是将两者合并:

	 [[_text.rac_textSignal merge:RACObserve(_text, text)] subscribeNext:^(id x) {
	         NSLog(@"%@",x);
	    }];
	    
	    
## RAC语录
- 任何信号的转换都是对原有信号进行订阅,从而产生新的信号.

## 参考资料

[美团ReactiveCocoa专题](https://tech.meituan.com/tag/ReactiveCocoa)