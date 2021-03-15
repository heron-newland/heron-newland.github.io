---
layout: post
title:  "iOS数据库-SQLite"
date:   2019-04-18 10:10:03
categories:
 - Data base
tags:
 - iOS
---



SQLite是一个进程内的库，实现了自给自足的、无服务器的、零配置的、事务性的 SQL 数据库引擎。它是一个零配置的数据库，这意味着与其他数据库一样，您不需要在系统中配置。
就像其他数据库，SQLite 引擎不是一个独立的进程，可以按应用程序需求进行静态或动态连接。SQLite 直接访问其存储文件。

<!--more-->

### 为什么要用 SQLite？

* 不需要一个单独的服务器进程或操作的系统（无服务器的）。
* SQLite 不需要配置，这意味着不需要安装或管理。
* 一个完整的 SQLite 数据库是存储在一个单一的跨平台的磁盘文件。
* SQLite 是非常小的，是轻量级的，完全配置时小于 400KiB，省略可选功能配置时小于250KiB。
* SQLite 是自给自足的，这意味着不需要任何外部的依赖。
* SQLite 事务是完全兼容 ACID 的，允许从多个进程或线程安全访问。
* SQLite 支持 SQL92（SQL2）标准的大多数查询语言的功能。
* SQLite 使用 ANSI-C 编写的，并提供了简单和易于使用的 API。
* SQLite 可在 UNIX（Linux, Mac OS-X, Android, iOS）和 Windows（Win32, WinCE, WinRT）中运行。

### SQLite 局限性

在 SQLite 中，SQL92 不支持的特性如下所示：

特性|描述
----|----
RIGHT OUTER JOIN	|只实现了 LEFT OUTER JOIN
FULL OUTER JOIN	|只实现了 LEFT OUTER JOIN。
ALTER TABLE	|支持 RENAME TABLE 和 ALTER TABLE 的 ADD COLUMN variants 命令，不支持 DROP COLUMN、ALTER COLUMN、ADD CONSTRAINT。
Trigger 支持|	支持 FOR EACH ROW 触发器，但不支持 FOR EACH STATEMENT 触发器。
VIEWs	|在 SQLite 中，视图是只读的。您不可以在视图上执行 DELETE、INSERT 或 UPDATE 语句。
GRANT 和 REVOKE	|可以应用的唯一的访问权限是底层操作系统的正常文件访问权限。

### SQLite 命令
与关系数据库进行交互的标准 SQLite 命令类似于 SQL。命令包括 CREATE、SELECT、INSERT、UPDATE、DELETE 和 DROP。这些命令基于它们的操作性质可分为以下几种：
#### DDL - 数据定义语言
命令	|描述
---|---
CREATE	|创建一个新的表，一个表的视图，或者数据库中的其他对象。
ALTER	|修改数据库中的某个已有的数据库对象，比如一个表。
DROP	|删除整个表，或者表的视图，或者数据库中的其他对象。
#### DML - 数据操作语言
命令|	描述
---|---
INSERT	|创建一条记录。
UPDATE	|修改记录。
DELETE	|删除记录。
#### DQL - 数据查询语言
命令 | 描述
----|----
SELECT	| 从一个或多个表中检索某些记录


### SQLite 数据类型
SQLite 数据类型是一个用来指定任何对象的数据类型的属性。SQLite 中的每一列，每个变量和表达式都有相关的数据类型。
您可以在创建表的同时使用这些数据类型。SQLite 使用一个更普遍的动态类型系统。在 SQLite 中，值的数据类型与值本身是相关的，而不是与它的容器相关。
### SQLite 存储类
每个存储在 SQLite 数据库中的值都具有以下存储类之一：

存储类	|描述
---|---
NULL	|值是一个 NULL 值。
INTEGER	|值是一个带符号的整数，根据值的大小存储在 1、2、3、4、6 或 8 字节中。
REAL	|值是一个浮点值，存储为 8 字节的 IEEE 浮点数字。
TEXT	|值是一个文本字符串，使用数据库编码（UTF-8、UTF-16BE 或 UTF-16LE）存储。
BLOB	|值是一个 blob 数据，完全根据它的输入存储。

### SQLite 创建数据库

SQLite 的 sqlite3 命令被用来创建新的 SQLite 数据库。您不需要任何特殊的权限即可创建一个数据。
语法
sqlite3 命令的基本语法如下：
`$sqlite3 DatabaseName.db`

通常情况下，数据库名称在 RDBMS 内应该是唯一的。

如果您想创建一个新的数据库 <testDB.db>，SQLITE3 语句如下所示：

	$sqlite3 testDB.db
	SQLite version 3.7.15.2 2013-01-09 11:53:05
	Enter ".help" for instructions
	Enter SQL statements terminated with a ";"
	sqlite>

上面的命令将在当前目录下创建一个文件 testDB.db。该文件将被 SQLite 引擎用作数据库。如果您已经注意到 sqlite3 命令在成功创建数据库文件之后，将提供一个 sqlite> 提示符。
一旦数据库被创建，您就可以使用 SQLite 的 .databases 命令来检查它是否在数据库列表中，如下所示：

	sqlite>.databases
	seq  name             file
	---  ---------------  ----------------------
	0    main             /home/sqlite/testDB.db

您可以使用 SQLite .quit 命令退出 sqlite 提示符，如下所示：

	sqlite>.quit


#### .dump 命令

您可以在命令提示符中使用 SQLite .dump 点命令来导出完整的数据库在一个文本文件中，如下所示：

	$sqlite3 testDB.db .dump > testDB.sql

上面的命令将转换整个 testDB.db 数据库的内容到 SQLite 的语句中，并将其转储到 ASCII 文本文件 testDB.sql 中。您可以通过简单的方式从生成的 testDB.sql 恢复，如下所示：

	$sqlite3 testDB.db < testDB.sql
