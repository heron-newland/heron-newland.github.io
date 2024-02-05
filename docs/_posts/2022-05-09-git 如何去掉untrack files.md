---
layout: post
title:  "git 如何去掉untrack files "
date:   2022-05-09
categories:
 - Turorial
tags:
 - Skills
---


### git 如何去掉untrack files 

执行以下命令可以清空 untracked files：

```text
git clean -f
```

该命令会删除当前工作目录下所有未被跟踪的文件。如果需要删除特定的文件或目录，可以使用 `git clean` 命令的其他选项和参数。例如：

删除指定目录下的 untracked files：

```text
git clean -f path/to/directory
```

删除 untracked files 和 untracked directories：

```text
git clean -f -d
```

显示将要删除的 untracked files 和 directories：

```text
git clean -n
```
