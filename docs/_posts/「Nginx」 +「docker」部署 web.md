「Nginx」 +「docker」部署 web



#### [部署Docker](https://help.aliyun.com/document_detail/51853.html)

本节主要介绍手动安装Docker的操作步骤，您也可以在[云市场](https://market.aliyun.com/software)购买相应镜像，一键部署云服务器。

1. 远程连接ECS实例。连接方式请参见[连接方式概述](https://help.aliyun.com/document_detail/71529.htm#concept-tmr-pgx-wdb)。

2. 依次运行以下命令添加yum源。

   - 更新yum源。

     ```
     yum -y update
     ```

   - 安装epel源。

     ```
     yum install -y epel-release 
     ```

   - 清除yum缓存。

     ```
     yum clean all
     ```

   **说明** 您可以运行命令**yum list**查看所有可安装的包。

3. 安装并运行Docker。

   ```
   yum install docker-io -y
   systemctl start docker
   ```

4. 查看Docker版本信息，确认是否成功安装Docker。

   ```
   docker --version
   ```




### Docker常用命令:

1. 进入对应的docker容器目录中

   ```
   docker exec -it containerid bash
   ```

### 阿里云使用sz,rz上传和下载文件

1. 安装lrzsz

   ```
   yum -y install lrzsz
   ```

2. 现在就可以正常使用rz、sz命令上传、下载数据了。

   ```
   rz filename
   sz filename
   ```

   

   

   ### 阿里云在docker容器中安装vim

   ```
   apt-get update
   
   apt-get install vim
   ```

   

   ### 问题:

1. 如果部署之后无法通过外网访问, 需要通过设置阿里云控制台里面的[安全组](https://ecs.console.aliyun.com/?accounttraceid=f79add2aba82499885b358ff48ef2458klia#/securityGroup/region/cn-shanghai),开放外网方位与服务的权限,详情参考里面的教程

2. 网站跨域问题:

   解决办法:修改nginx的配置如下:

   ```javascript
   location / {  
       add_header Access-Control-Allow-Origin *;
       add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
       add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
   
       if ($request_method = 'OPTIONS') {
           return 204;
   }
   proxy_pass http://192.168.12.1:8081;
   } 
   ```



add_header Access-Control-Allow-Origin 'http://u9qg4ksg.lc-cn-n1-shared.com';
add_header Access-Control-Allow-Headers 'Origin, X-Requested-With, Content-Type, Accept,User-Agent';

nginx服务目录: 2d1a02fe52e8:/usr/share/nginx/html

```
containerID:/usr/share/nginx/html

2d1a02fe52e8:/data
```

### [Nginx配置ssl证书](https://help.aliyun.com/document_detail/98728.htm?spm=a2c4g.11186623.2.7.284e60e0VZW2g5#concept-n45-21x-yfb)

```
server {
    listen 443 ssl;
    server_name doja.top; #需要将yourdomain.com替换成证书绑定的域名。
    root html;
    index index.html index.htm;
    ssl_certificate cert/5687798_doja.top.pem;
    ssl_certificate_key cert/5687798_doja.top.key;
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-		 			SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; 
    ssl_prefer_server_ciphers on;
    location / {
        root html;  #站点目录。
        index index.html index.htm;
    }
}
```

### 域名备案查询:

https://beian.aliyun.com/?spm=5176.14418478.J_1164210480.1.12e46415FdIO1y

### [添加ftp服务](https://help.aliyun.com/document_detail/60152.html?spm=a2c4g.11186623.6.590.7177507bK8LXLs)



### 附录:

#### ip:47.102.200.145

#### ftp:

用户名:heron

密码:helong123

#### lnmt:

栈资源名称:LNMT_20210521

实例密码:Helong123

数据库名称:MyDatabase

数据库用户名:heron

数据库密码:Helong123

数据库管理员用户密码:rootHelong123

mysql数据库账号密码:root@localhost: T0SLWk,rTwO7

