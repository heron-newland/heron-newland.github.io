---
title: DNS解析中的A记录、AAAA记录、CNAME记录、MX记录、NS记录、TXT记录、SRV记录、URL转发
layout: post
date: 2019-08-10 10:10:03
categories:
 - Skills
tags:
 - UI
---

本文做一些DNS的扫描知识点介绍。

### A

A记录： 将域名指向一个IPv4地址（例如：100.100.100.100），需要增加A记录

### NS

NS记录： 域名解析服务器记录，如果要将子域名指定某个域名服务器来解析，需要设置NS记录

### SOA

SOA记录： SOA叫做起始授权机构记录，NS用于标识多台域名解析服务器，SOA记录用于在众多NS记录中标记哪一台是主服务器

### MX

MX记录： 建立电子邮箱服务，将指向邮件服务器地址，需要设置MX记录。建立邮箱时，一般会根据邮箱服务商提供的MX记录填写此记录

### TXT

TXT记录： 可任意填写，可为空。一般做一些验证记录时会使用此项，如：做SPF（反垃圾邮件）记录


```linux shell cmd:
dig www.baidu.com -t a 
dig www.baidu.com -t aaa
dig www.baidu.com -t cname
dig www.baidu.com -t txt
dig www.baidu.com -t mx
dig www.baidu.com -t ns
dig www.baidu.com -t soa
dig www.baidu.com -t srv

```

[dig 命令设置指定的DNS服务器](https://blog.hackroad.com/operations-engineer/basics/13255.html)

 

> 域名注册完成后首先需要做域名解析，域名解析就是把域名指向网站所在服务器的IP，让人们通过注册的域名可以访问到网站。IP地址是网络上标识服务器的数字地址，为了方便记忆，使用域名来代替IP地址。域名解析就是域名到IP地址的转换过程，域名的解析工作由DNS服务器完成。DNS服务器会把域名解析到一个IP地址，然后在此IP地址的主机上将一个子目录与域名绑定。域名解析时会添加解析记录，这些记录有：A记录、AAAA记录、CNAME记录、MX记录、NS记录、TXT记录、SRV记录、URL转发。

### 1. DNS域名解析中添加的各项解析记录

- A记录： 将域名指向一个IPv4地址（例如：100.100.100.100），需要增加A记录

- CNAME记录： 如果将域名指向一个域名，实现与被指向域名相同的访问效果，需要增加CNAME记录。这个域名一般是主机服务商提供的一个域名

- MX记录： 建立电子邮箱服务，将指向邮件服务器地址，需要设置MX记录。建立邮箱时，一般会根据邮箱服务商提供的MX记录填写此记录

- NS记录： 域名解析服务器记录，如果要将子域名指定某个域名服务器来解析，需要设置NS记录

- TXT记录： 可任意填写，可为空。一般做一些验证记录时会使用此项，如：做SPF（反垃圾邮件）记录

- AAAA记录： 将主机名（或域名）指向一个IPv6地址（例如：ff03:0:0:0:0:0:0:c1），需要添加AAAA记录

- SRV记录： 添加服务记录服务器服务记录时会添加此项，SRV记录了哪台计算机提供了哪个服务。格式为：服务的名字.协议的类型（例如：_example-server._tcp）。

- SOA记录： SOA叫做起始授权机构记录，NS用于标识多台域名解析服务器，SOA记录用于在众多NS记录中那一台是主服务器

- PTR记录： PTR记录是A记录的逆向记录，又称做IP反查记录或指针记录，负责将IP反向解析为域名

- 显性URL转发记录： 将域名指向一个http(s)协议地址，访问域名时，自动跳转至目标地址。例如：将www.liuht.cn显性转发到www.itbilu.com后，访问www.liuht.cn时，地址栏显示的地址为：www.itbilu.com。

- 隐性UR转发记录L： 将域名指向一个http(s)协议地址，访问域名时，自动跳转至目标地址，隐性转发会隐藏真实的目标地址。例如：将www.liuht.cn显性转发到www.itbilu.com后，访问www.liuht.cn时，地址栏显示的地址仍然是：www.liuht.cn。

### 2. DNS解析中一些问题

#### 2.1 A记录与CNAME记录

A记录是把一个域名解析到一个IP地址，而CNAME记录是把域名解析到另外一个域名，而这个域名最终会指向一个A记录，在功能实现在上A记录与CNAME记录没有区别。

CNAME记录在做IP地址变更时要比A记录方便。CNAME记录允许将多个名字映射到同一台计算机，当有多个域名需要指向同一服务器IP，此时可以将一个域名做A记录指向服务器IP，然后将其他的域名做别名(即：CNAME)到A记录的域名上。当服务器IP地址变更时，只需要更改A记录的那个域名到新IP上，其它做别名的域名会自动更改到新的IP地址上，而不必对每个域名做更改。

#### 2.2 A记录与AAAA记录

二者都是指向一个IP地址，但对应的IP版本不同。A记录指向IPv4地址，AAAA记录指向IPv6地址。AAAA记录是A记录的升级版本。

#### 2.3 IPv4与IPv6

IPv4，是互联网协议（Internet Protocol，IP）的第四版，也是第一个被广泛使用的版本，是构成现今互联网技术的基础协议。IPv4 的下一个版本就是IPv6，在将来将取代目前被广泛使用的IPv4。

IPv4中规定IP地址长度为32位（按TCP/IP参考模型划分) ，即有2^32-1个地址。IPv6的提出最早是为了解决，随着互联网的迅速发展IPv4地址空间将被耗尽的问题。为了扩大地址空间，IPv6将IP地址的长度由32位增加到了128位。在IPv6的设计过程中除了一劳永逸地解决了地址短缺问题以外，还解决了IPv4中的其它问题，如：端到端IP连接、服务质量（QoS）、安全性、多播、移动性、即插即用等。

#### 2.4 TTL值

TTL－生存时间（Time To Live），表示解析记录在DNS服务器中的缓存时间，TTL的时间长度单位是秒，一般为3600秒。比如：在访问www.itbilu.com时，如果在DNS服务器的缓存中没有该记录，就会向某个NS服务器发出请求，获得该记录后，该记录会在DNS服务器上保存TTL的时间长度，在TTL有效期内访问www.itbilu.com，DNS服务器会直接缓存中返回刚才的记录。

### 下面就简要的介绍下 DNS 的 SOA记录：

在任何 DNS 记录文件（Domain Name System (DNS) Zone file）中， 都是以SOA（Start of Authority）记录开始。SOA 资源记录表明此 DNS 名称服务器是为该 DNS 域中的数据的信息的最佳来源。SOA 记录与 NS 记录的区别:简单讲，NS记录表示域名服务器记录，用来指定该域名由哪个DNS服务器来进行解析;SOA记录设置一些数据版本和更新以及过期时间的信息.

下面用我的 DNS 的 SOA 记录为例来说明其结构：


```The SOA record is:
Primary nameserver: ns51.domaincontrol.com
Hostmaster E-mail address: dns.jomax.net
Serial #: 2010123100
Refresh: 28800
Retry: 7200
Expire: 604800 1 weeks
Defa
ult TTL: 86400
```

#### 源主机（Primary nameserver）：

DNS记录文件所在的主机位置。

#### 联系邮箱（Hostmaster E-mail address）：

记录主机管理员的联系方式，其中第一个点表示的是@。

#### 序列号（Serial）：

格式为yyyymmddnn，nn代表这一天是第几次修改。辅名字服务器通过比较这个序列号是否加载一份新的区数据拷贝。

#### refresh（刷新）：

告诉该区的辅名字服务器相隔多久检查该区的数据是否是最新的。

#### retry（重试）：

如果辅名字服务器超过刷新间隔时间后无法访问主服务器，那么它就开始隔一段时间重试连接一次。这个时间通常比刷新时间短，但也不一定非要这样。

#### expire（过期或期满）：

如果在期满时间内辅名字服务器还不能和主服务器连接上，辅名字服务器就使用这个我失效。这就意味着辅名字服务器将停止关于该区的回答，因为这些区数据太旧了，没有用了。设置时间要比刷新和重试时间长很多，以周为单位是较合理的。

#### 否定缓存TTL（生存期）：

这个值对来自这个区的权威名字服务器的否定响应都适用。

一个Microsoft DNS服务器的SOA记录的数据结构如下：


```
@   IN  SOA     nameserver.place.dom.  postmaster.place.dom. (
                               1            ; serial number
                               3600         ; refresh   [1h]
                               600          ; retry     [10m]
                               86400        ; expire    [1d]
                               3600 )       ; min TTL   [1h]
```