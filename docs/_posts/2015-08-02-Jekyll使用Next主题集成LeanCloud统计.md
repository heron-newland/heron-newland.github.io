---
layout: post
title:  "Jekyll使用Next主题集成LeanCloud统计"
date:   2015-08-01 19:52:13 +0800
categories:
 - Turorial
tags:
 - Jekyll
---

 Jekyll有很多的主题,[jekyll-theme-next](https://github.com/simpleyyt/jekyll-theme-next)就是一个很不错的主题，今天就讲解使用jekyll如何集成LeanCloud来统计博客的浏览量。

<!--more-->


## 配置LeanCloud

使用LeanCloud实现浏览量的统计只用到LeanCloud的数据存储功能, 相当于在LeanCloud云数据库中建一张表,每次用户点击一篇文章就会根据文章的url更新浏览量的这张表中.

### 注册LeanCloud账号

注册[LeanCloud](https://leancloud.cn/)账号有多种方式,本人直接用github账号授权登录.

### 创建应用

注册号之后直接点击创建应用, 如下图, 输入应用名之后, 选择开发版(默认选中的为开发板),然后点击创建即可.

![图片](/assets/images/jekyll/creat.png)

### 创建Class

应用创建好之后如下图:

![图片](/assets/images/jekyll/app.png)

点击存储或者点击右上角的设置进入应用控制台如下图所示:

![图片](/assets/images/jekyll/console.png)

然后点击存储, 点击创建Class, 会弹出如下图窗口:

![图片](/assets/images/jekyll/class.png)

class名称固定填写Counter(Next主题中js代码中是通过Counter这个表名来查询和修改浏览量的, 如果使用其他主题可以查看其对应的表名), ACL权限勾选无限制, 点击创建 Class, 配置之后如下图: 

![图片](/assets/images/jekyll/classOk.png)

### 安全配置

点击应用控制面板左侧最下方的设置, 然后选中安全中心

- 服务开关: 建议只打开数据存储, 其他都关掉(安全起见)
- Web安全域名, 将自己的博客域名填写进去

然后点击保存, 配置好之后的图片如下图

![图片](/assets/images/jekyll/secrue.png)

### 获取应用Key

点击应用控制面板左侧最下方的设置, 然后选中应用Key, 你就能看到应用的 AppID 和 App Key, 后面再配置jekyll的时候会用到.

## 配置jekyll

打开博客根目录/_config.yml，查找`leancloud_visitors`，填写复制来的App ID和App Key，然后使用git命令

	git add .
	git commit -m"des"
	git push
	
提交修改到github远程仓库

配置成功之后使用效果如下:


![图片](/assets/images/jekyll/demo.png)

## 附言:

- 初始的文章统计量显示为0。在配置好阅读量统计服务之后，第一次打开博文时，会自动向服务器发送数据，该数据会被记录在对应的应用的Counter表中。

- 在LeanCloud控制台修改Counter表中的time字段的数值，可以修改文章的访问量。双击具体的数值，修改之后回车即可保存。


## 联系方式

objc_china@163.com

