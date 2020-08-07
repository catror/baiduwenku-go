# 百度文档免积分下载

### 百度文库前端已更新，暂时不可用。

### 介绍

已上云，demo：http://175.24.33.33:9999/baiduspider

支持两种下载方式：①基于爬虫的非源文件下载方式	②基于vip账号共享的源文件下载方式。

第一种下载方式存在公式无法提取、word中图片无法提取、少部分文档排版丑陋、ppt只能转码为多张图片打包的zip格式等问题，经过我多番的调整，大部分word文档的格式已经能够得到百分之八九十的还原，但依旧推荐使用第二种方式下载。

第二种下载方式下载文件为源文件，与百度文库保存的文件一致。原理较简单，就是我服务器利用我自费的vip账号帮你下载，然后再传给你。

为了防止接口被人滥用，遂采用了需要注册登录才能使用的方式。目前**对所有人开放注册**，但仅利用**智慧华中大邮箱**注册的用户可以**不限次数**下载，其他邮箱注册用户每天仅有**3次下载机会**且无专享vip文档下载特权。百度文库的文档有两种类型：普通vip型，专属vip型。对于智慧华中大邮箱注册的用户来说，普通vip文档能够实现完美不限量下载，专属vip型文档每个vip账号每月有下载数量限制(百度原因，并非本人限制)，demo中的vip账号剩余下载数目已经在网页中给出，所有人共用完只能等下月。

### 如何运行

#### ①原生应用安装方式

配置`config.json`，以下参数均需自行设置：

```shell
"DB_NAME": "",			//mysql数据库
"DB_CONN":"", 			//数据库连接形如"用户名:密码@tcp(IP:端口)/数据库?charset=utf8"
"DOMAIN": "",			//自己服务器的域名或公网IP或回环地址127，非广播地址0.0.0.0
"LISTEN_ADDRESS":"", 		//server服务器监听地址
"LISTEN_PORT": "", 		//server服务器监听端口
"IMAP_PORT": ,		 	//IMAP服务端口，如465
"IMAP_SERVER": "", 		//IMAP服务的服务器地址，如smtp.qq.com
"IMAP_EMAIL": "", 		//提供IMAP服务的具体邮箱
"IMAP_PASSWORD": "", 		//提供IMAP服务邮箱的IMAP授权码
"BDUSS": "",			// 一个vip账号的cookie
"REGEXP":"" 			//正则匹配规则，符合该规则的邮箱有下载专享文档的权限，如.*@hust.edu.cn只许智慧华中大邮箱,.*为允许所有邮箱。
```

本地跑项目把`DOMIN`和`LISTEN_ADDRESS`都设为`127.0.0.1`即可。

关于`IMAP`的配置，可参考[IMAP](https://service.mail.qq.com/cgi-bin/help?subtype=1&id=28&no=331)。

关于`BDUSS`cookie获取：

在浏览器中登录百度文库(必须是会员账号)，利用浏览器的开发者工具获取cookie。

`chrome`：F12->Application->cookies

![GLQT__@EB9N67Z`_L@JJ_CE.png](https://i.loli.net/2020/05/13/WHwFa4kmsvlzLgN.png)

`firefox`：F12->Storage->cookies

![LT553244YT9E___WJZ3RUZN.png](https://i.loli.net/2020/05/13/gncU7tZIm1dhEzx.png)

安装mysql，并建表。

```sql
create table hustusers(	
id int primary key auto_increment,
emailadd  varchar(40) not  null unique,
password varchar(20) not null,
permissioncode tinyint default 1,
remain tinyint default 3
);

create table hustsessions(
emailadd varchar(40) not null primary key,
sessionid varchar(100)  not null 
);
```

安装第三方go依赖，编译并运行程序

```go
go mod tidy
go build main.go
./main
```

#### ②docker安装方式

请自行下载安装`docker`以及`docker-compose`。克隆整个项目，进行初始配置：

对`config.json`，标为`无需配置`的地方不应修改 ：

```shell
"DB_NAME": "mysql",			//无需配置
"DB_CONN":"root:123456@tcp(mysql:3306)/wenkudb", //无需配置
"DOMAIN": "",				//自己服务器的域名或公网IP或回环地址127，非广播地址0.0.0.0
"LISTEN_ADDRESS":"0.0.0.0", 		//服务地址，调试可以改成127.0.0.1
"LISTEN_PORT": "9898", 			//无需配置
"IMAP_PORT": , 				//IMAP服务端口，如465
"IMAP_SERVER": "", 			//IMAP服务的服务器地址，如smtp.qq.com
"IMAP_EMAIL": "", 			//提供IMAP服务的具体邮箱
"IMAP_PASSWORD": "", 			//提供IMAP服务邮箱的IMAP授权码
"BDUSS": "" 				// 一个vip账号的cookie，不进行设置则只能利用爬虫解析方式下载
"REGEXP":""				//同上
```

服务默认监听端口为80，如需修改监听端口则对`docker-compose.yml`进行修改：

![TIM图片20200714053915.png](https://i.loli.net/2020/07/14/znJwWlB3PkVbXfO.png)

服务启动：

```shell
chmod 755 start.sh
./start.sh
```

服务停止：

```shell
docker stop wenku
```

删除所有用户数据：

```shell
#容器中mysql的数据是挂载在项目目录下的mysql文件夹中
rm -rf ./mysql
```

若更改了配置，为使配置生效都应该执行`./start.sh`。

手动管理容器中mysql方法：

```shell
docker exec -it mysql bash
#进入容器bash后即可操纵mysql
#mysql用户名root，密码为123456，数据库名为wenkudb，两张表hustsessions以及hustusers
#exit退出容器
```

