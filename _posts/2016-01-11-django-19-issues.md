---
layout: post
title: "Django 1.9 Issues"
keywords: [""]
description: ""
category: "python"
tags: ["django", "python", "web"]
---
{% include JB/setup %}

### Issue #1 Django MySQLdb
* Detail:
    * `No module named 'MySQLdb'`
* Solved:
    * `pip install mysqlclient` [github](https://github.com/PyMySQL/mysqlclient-python)
