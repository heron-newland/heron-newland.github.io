---
layout: post
title:  "Jekyll使用gitment集成评论功能"
date:   2015-08-04 19:52:13 +0800
categories:
 - Turorial
tags:
 - Jekyll
---


国内的几个第三方评论系统或者不能用了或者使用条件限制都不好用，如“多说”，“畅言”，“友言”，“新浪云跟贴”：

<!--more-->

- 多说，曾经较火的评论系统，网上介绍文章比较多，但已关闭，无法再用了
- 畅言，sohu旗下的，但是需要个人博客备案后才能使用，但github pages个人博客感觉备案比较难
- 友言，jiaThis旗下的，由于时http请求，github pages现在都是https了， 在https站点无法调用http请求，故也无法使用
- 网易云跟贴，曾被当作“多说”的替代品，可惜官方通报说也将在2017.08.01关闭了
- [Gitment](https://github.com/imsun/gitment)，一款由国内大神imsun开发的基于github issues的评论系统, 具体介绍请看项目主页( github.com/imsun/gitment ).

## 集成gitment步骤如下

### 申请一个Github OAuth Application

- Github头像下拉菜单 > Settings > 左边Developer settings下的OAuth Application > Register a new application，填写相关信息：

- Application name, Homepage URL, Application description 都可以随意填写.

- Authorization callback URL 一定要写自己Github Pages的URL.

- 填写完上述信息后按Register application按钮，得到Client ID和Client Secret.

### 在jekyll中配置gitment

找到_layout/post.html文件, 添加一下代码:

	<div id="gitmentContainer"></div>
	<!-- 汉化 -->
	<link rel="stylesheet" href="https://billts.site/extra_css/gitment.css">
	<script src="https://billts.site/js/gitment.js"></script>
	
	<!-- <link rel="stylesheet" href="https://imsun.github.io/gitment/style/default.css">
	<script src="https://imsun.github.io/gitment/dist/gitment.browser.js"></script> -->
	<script>
	var gitment = new Gitment({
		id: '<%= page.title %>',
	    owner: 'xxxxx',
	    repo: 'xxxxx',
	    oauth: {
	        client_id: 'xxxxx',
	        client_secret: 'xxxxx',
	    },
	});
	gitment.render('gitmentContainer');
	</script>

- client_id: Register application完成后得到的id
- client_secret: Register application完成后得到的secret
- repo: 自己博客的仓库地址
- owner: 所有者名称

### 汉化评论

按照本文配置好之后就已经汉化过了, 如果你按照其他文章配置可能是没有汉化的, 如果你需要汉化, 将`_layout/post.html`文件中的如下代码

	<link rel="stylesheet" href="https://imsun.github.io/gitment/style/default.css">
	<script src="https://imsun.github.io/gitment/dist/gitment.browser.js"></script> 
	
替换成如下汉化代码即可:

	<link rel="stylesheet" href="https://billts.site/extra_css/gitment.css">
	<script src="https://billts.site/js/gitment.js"></script>


## 为每篇博文初始化评论系统

由于gitment的原理是为每一遍博文以其URL作为标识创建一个github issue， 对该篇博客的评论就是对这个issue的评论。因此，我们需要为每篇博文初始化一下评论系统， 初始化后，你可以在你的github上会创建相对应的issue。

接下来，介绍一下如何初始化评论系统：

上面第2步代码添加成功并上传后，你就可以在你的博文页下面看到一个评论框，还 有看到以下错误未初始化评论(`Error: Comments Not Initialized`)，提示该篇博文的评论系统还没初始化, 此时你是无法再评论框输入评论的。你只需按如下步骤即可初始化

- 点击登录(`Login with GitHub`)后，使用自己的`github`账号登录后，就可以在上面错误信息 处看到一个**初始化评论**(`Initialize Comments`)的按钮。

- 点击**初始化评论**(`Initialize Comments`)按钮后，就可以开始对该篇博文开始评论了， 同时也可以在对应的github仓库看到相应的issue。

> 括号中的提示时英文提示, 没有汉化就是英文, 汉化之后就是中文提示


## Gitment坑点小结

- Error: Not Found问题

owner或者repo配置错误了，注意名字和仓库名字的大小写。

- Error: Comments Not Initialized  可能是如下两点问题

	1. 在注册OAuth Application这个步骤中，给Authorization callback URL指定的地址错了

	2. 还没有在该页面的Gitment评论区登陆GitHub账号

- Error：validation failed

	issue的标签label有长度限制！labels的最大长度限制是50个字符。
	
	id: '页面 ID', // 可选。默认为 location.href
	
	这个id的作用，就是针对一个文章有唯一的标识来判断这篇本章。
	
	在issues里面，可以发现是根据网页标题来新建issues的，然后每个issues有两个labels（标签），一个是gitment，另一个就是id。
	
	所以明白了原理后，就是因为id太长，导致初始化失败，现在就是要让id保证在50个字符内。
	
	issue的标签label有长度限制！labels的最大长度限制是50个字符。需要修改前面插入的gitment的html代码：

		id用文章的title
		id: '<%= page.title %>'
	
	如果用网页标题也不能保证在50个字符！
	最后，我用文章的时间，这样长度是保证在50个字符内，完美解决！（避免了文章每次更新标题或路径时，会重新创建一个issue评论的问题。）

		id用文章的时间
		id: '<%= page.date %>'


- owner: 'Your GitHub ID'

		owner: '你的 GitHub ID'
		
		可以是你的GitHub用户名，也可以是github id，建议直接用GitHub用户名就可以。


- repo: 'The repo to store comments

		repo: '存储评论的 github repo'
		这个是你要存储评论内容的仓库名，可以与博客下的仓库，也可以新建一个仓库专门存储评论内容的。

 最后我们看一张成品图片吧, 效果还是很不错的, 除了评论完还有喜欢, 以及喜欢别人的评论的功能:
 
 ![图片](/assets/images/jekyll/comment.png)
## 联系方式

objc_china@163.com

