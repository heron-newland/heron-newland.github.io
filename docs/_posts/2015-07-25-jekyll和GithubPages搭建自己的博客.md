---
layout: post
title: jekyll和GithubPages搭建自己的博客
date:  2015-07-25 10:10:03
categories:
 - tutorial
tags:
 - Skills
---

Jekyll 是一个简单的博客形态的静态站点生产机器。它有一个模版目录，其中包含原始文本格式的文档，通过一个转换器（如 [Markdown](http://daringfireball.net/projects/markdown/)）和我们的 [Liquid](https://github.com/Shopify/liquid/wiki) 渲染器转化成一个完整的可发布的静态网站，你可以发布在任何你喜爱的服务器上。Jekyll 也可以运行在 [GitHub Page](http://pages.github.com/) 上，也就是说，你可以使用 GitHub 的服务来搭建你的项目页面、博客或者网站，而且是**完全免费**的。下面简单介绍一下[jekyll](http://jekyllcn.com)和[GithubPages](https://pages.github.com)搭建自己的博客

### 安装jekyll

~~`gem install jekyll bundler`~~

请注意：由于`GithubPages`版本所支持的`jekyll`最高版本为`3.9`，但是以上命令安装的`jekyll`为`4.2.0`，所以会存在兼容性问题，所以建议安装`3.9`版本的`jekyll`（如果已经安装的可以使用`gem uninstall jekyll`卸载现有版本）。安装方式如下：

`sudo gem install jekyll -v "3.9"`

需要半个多小时才能安装完毕。 使用 `jekyll -v`查看是否安装成功， 接下来我们测试一下`jekyll`大致使用流程：

1. 使用`jekyll new my-awesome-site `命令来创建一个`jekyll`项目，创建好以后里面的`.gitignore`等都会被一并创建好
2. `cd my-awesome-site` 切换到项目目录
3. `bundle install`
4. `bundle exec jekyll serve`执行此步骤可能会报如下错误：
   - `Could not find gem 'minima (~> 2.5)' in any of the gem sources listed in your Gemfile.`， 解决方式为：`sudo gem install minima --verbose` 
5. 打开浏览器` http://localhost:4000`如果能访问成功，那么恭喜你，jekyll的环境已经搭建好了，接下来我们就来看看GithubPages。

### 创建GithubPages仓库

详细步骤可以参考`github-pages`的[官方教程](https://docs.github.com/en/github/working-with-github-pages/creating-a-github-pages-site-with-jekyll#creating-your-site)，里面写的什么详细。需要注意一点的就是执行到第11步（使用 `bundle exec jekyll serve`本地测试）的时候会报如下错：

`Could not find gem 'github-pages' in any of the gem sources listed in your Gemfile.`

解决办法也很简单，使用`sudo gem install github-pages`命令安装`github-pages`即可.

### 使用jekyll发布站点

二者都准备好之后如何将其结合呢？首先要修改一下本地仓库中的`Gemfile`(Gemfile管理jekyll的依赖)，添加如下内容

```ruby
require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

gem 'github-pages', versions['github-pages'], group: :jekyll_plugins


```

将内容提交到远程仓库之后，自己的博客就基本搭建完毕了。 首先我们执行 `bundle exec jekyll serve`,然后在浏览器中通过 `127.0.0.1:4000`查看网站的效果。也可以通过`https://userName.github.io`(userName为自己的github名称)查看发布的静态博客。

### jekyll编写博客

撰写博客的教程在jekyll官方教程上写的十分详细，博客主要有两部分组成：头部信息和[博客内容](http://jekyllcn.com/docs/posts/)， 头部信息的格式是固定的，详情请点击头[部信息详解](http://jekyllcn.com/docs/frontmatter/)查看。

### jekyll主题配置

上面我们搭建的博客默认是`minima`， 本人比较喜欢`next`这个主题，所以我们就以`next`主题的配置展开来看：

下载` NexT` 主题：

```
$ git clone https://github.com/Simpleyyt/jekyll-theme-next.git
$ cd jekyll-theme-next
```

安装依赖：

```
$ bundle install
```

运行 `Jekyll`：

```
$ bundle exec jekyll server
```

此时即可使用浏览器访问 `http://localhost:4000`，检查站点是否正确运行。如果可以运行，那么next主题就安装成功了， 但是安装成功以后如何移植到自己的项目中来呢？可以直接将我们上面的`docs`目录中的所有文件替换问`next`主题的文件夹中的内容



### 常见问题：

1. GithubPages搭建的博客经常无法访问，大多数都是由于dns服务器的原因，配置电脑的dns服务器为：`114.114.114.114`即可

