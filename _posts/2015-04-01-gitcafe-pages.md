---
layout: post
category: git
tags: [git, gitcafe, blog, gitcafe-pages, github.io]
---

## 将博客搬到 gitcafe
* 1. 在gitcafe创建一个项目: 和用户名一样, 我的是 whatwewant
* 2. 必须提交到GitCafe的 gitcafe-pages分支:
    * git push -u origin master:gitcafe-pages
* 3. 访问: whatwewant.gitcafe.io 即可

## 一个项目同时使用两个或多个远程仓库
* `建议把国内的放前边, 在国内github已经离死不远`

```bash
[remote "origin"]
    fetch = +refs/heads/*:refs/remotes/origin/*
    url = git@gitcafe.com:whatwewant/whatwewant.git@gitcafe-pages
[remote "origin"]
    fetch = +refs/heads/*:refs/remotes/origin/*
    url = git@github.com:whatwewant/whatwewant.github.io.git
```
* `git push -u origin master`

* 或者修改名字，分别提交
```bash
[remote "gitcafe"]
    fetch = +refs/heads/*:refs/remotes/gitcafe/*
    url = git@gitcafe.com:whatwewant/whatwewant.git
[remote "github"]
    fetch = +refs/heads/*:refs/remotes/github/*
    url = git@github.com:whatwewant/whatwewant.github.io.git
```
* `git push -u gitcafe master:gitcafe-pages`
* `git push -u github master`
