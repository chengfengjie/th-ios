# 一个阅读类app的iOS客户端,功能模块如下

* 首页: 此模块主要推荐一些文章   
* 同城: 主要是当前城市的一些文章   
* Qing聊: 此模块主要是话题相关，用户可以随意发布话题，也可以对已经发布的话题进行评论和回复等操作   
* 个人中心: 个人资料的维护，个人对文章和话题操作的记录，例如:关注，回复等等    

---

### 一、获取代码并且运行项目

```
$ git clone https://github.com/chengfengjie/th-ios.git
$ pod install
```

项目用CocoaPods管理第三方库，如果您对CocoaPods还不够了解，请先学习如何用CocoaPods管理iOS第三方库

### 二、项目目录结构

**Resource:** 项目资源目录，例如：plist, 字体文件等等  
**Api:** 项目Api接口的封装  
**Base:** 项目视图层的基础类  
**Controller:** 项目业务逻辑视图控制器  
**Utils:** 工具类    
**Style:** 项目样式配置(临时方案，可能后续会取消)   

