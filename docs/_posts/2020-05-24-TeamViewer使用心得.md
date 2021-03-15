---
layout: post
title: TeamViewer使用心得
date: 2020-05-23 22:56:14
categories: Skills
tags: Tools
---

今天打开 Teamviewer for MAC检测到商业用途，每次远程连接使用5分钟就会自动断开，下一次连接要2分钟后，真是太麻烦了！

#### 解决办法 

1. 修改Teamviewer页面上显示的ID，脚本来自[Heron](https://github.com/heron-newland/teamviewer)。
2. 下载脚本到本地,可以直接下载zip文件,或者 git clone,仓库中有 `TeamViewer-id-changer_14_lower` 和 `TeamViewer-id-changer_14_or_higher`, 分别适用于 `Teamviewer 14` 以下和`Teamviewer 14`及以上版本.
3. 退出Teamviewer
4. 在终端执行以下命令：`sudo python TeamViewer-id-changer_14_lower.py`(***根据自己Teamviewer的版本执行对应的脚本***) 然后输入root密码，回车继续执行。
5. 提示“ID changed sucessfully.”后，千万不要打开Teamviewer，要先重启电脑！！！

