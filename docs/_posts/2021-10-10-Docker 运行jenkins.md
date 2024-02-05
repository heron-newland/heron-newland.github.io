---
layout: post
title:  "Docker运行jenkins"
date:   2022-10-10
categories:
 - Turorial
tags:
 - Skills
---

### Docker运行jenkins

### 使用docker安装jenkins

1. 稳定版本:`docker pull jenkins/jenkins`

2. 最新版本: `docker pull jenkins/jenkins:lts-jdk11`

### Docker启动jenkins

1. 根据上面安装的版本启动, 以启动最新版本为例:

```
docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11
```

2. 执行上述命令之后会进行下载对应的文件, 然后文件, 然后启动, 控制台会输出进入jenkins的秘钥, 格式如下:

`c955f65477724ba295d0e7ae71a14bff`,可保存起来, 当然也可以在`/var/jenkins_home/secrets/initialAdminPassword`路径下找到

3. 在浏览器中输入`localhost:8080` 会打开jenkins, 输入上面的秘钥, 然后安装相应的插件, 不知道安装什么就选推荐安装即可

#### 创建任务

1. 选择创建一个 `freestyle project` 任务
2. 配置源码管理, 以git为例, 输入仓库地址: `https://git仓库用户名:git仓库密码@git.jc-ai.cn/print/chenyin/marian/print_chenyin-flutter.git`
3. 配置凭据, 我们以git仓库的用户名和ssh key的私钥(SSH User name and private key)为例, 需要在本地 `~/.ssh`目录中找到 `id_rsa` (如果本地没有,可以参考[生成教程](https://git.jc-ai.cn/help/ssh/README#generating-a-new-ssh-key-pair))然后将其内容复制进去, 并且git仓库已经配置过该秘钥对应的公钥.



注意: docker运行jenkins打包iOS项目需要准备flutter 和 xcode的环境,比较麻烦

----------------------我是分隔线--------------------------

### brew运行jenkins

[安装方法](https://www.jenkins.io/download/)

配置jenkins:  [jenkins配置文件.zip](assets/jenkins配置文件.zip) 

### jenkins问题:

1. 执行pod命名, 报错  command not found
   - 终端执行``echo $PATH` 查看本机的环境变量, 然后复制
   - 把服务器的环境变量添加到jenkins: `系统管理 -> 系统设置 -> 全局属性 -> 环境变量` 添加键值对, 键为固定为`path`, 值为刚复制的内容,然后保存即可

2. CocoaPods requires your terminal to be using UTF-8 encoding.

   - 终端打开`~/.bash_profile (open ~/.bash_profile)`
   - 编辑并添加 `export LANG=en_US.UTF-8`
   - 退出并保存,执行`source  ~/.bash_profile`
   - 运行 `echo $LANG` 命令以查看变量是否已正确配置。

   **注意:如果以上方法不行,那么直接在jenkins构建脚本中执行pod命令之前加上`export LANG=en_US.UTF-8` 即可**.

   

   
