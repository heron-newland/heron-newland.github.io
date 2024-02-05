---
layout: post
title:  "go build打包生成不同系统下的运行可执行文件exe"
date:   2022-01-16
categories:
 - Turorial
tags:
 - Skills
---

### go build打包生成不同系统下的运行可执行文件exe


Mac下编译Linux, Windows平台的64位可执行程序

```
CGO_ENABLED=0  GOOS=linux    GOARCH=amd64 go build main.go
CGO_ENABLED=0  GOOS=windows  GOARCH=amd64 go build main.go

```

Linux下编译Mac, Windows平台的64位可执行程序

```
CGO_ENABLED=0  GOOS=darwin   GOARCH=amd64 go build main.go
CGO_ENABLED=0  GOOS=windows  GOARCH=amd64 go build main.go

```

Windows下编译Mac, Linux平台的64位可执行程序

```
SET CGO_ENABLED=0  SET GOOS=darwin3 SET GOARCH=amd64 go build main.go
SET CGO_ENABLED=0  SET GOOS=linux   SET GOARCH=amd64 go build main.go
```

