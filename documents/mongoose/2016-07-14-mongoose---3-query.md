---
layout: post
title: "Mongoose - 3 Query"
keywords: [""]
description: ""
category: "nodejs"
tags: [nodejs, mongoose, mongodb, nosql]
---
{% include JB/setup %}

### 一 两种查询
* `JSON DOC`
* `QUERY BUILDER`

```javascript
// With a JSON doc
Person
  .find({
    occupation: /host/,
    'name.last': 'Ghost',
    age: { $gt: 17, $lt: 66},
    likes: { $in: ['vaporizing', 'talking'] }
  })
  .limit(10)
  .sort({ occupation: -1 })
  .select{ name: 1, occupation: 1 }
  .exec(callback);

// Using query builder
Person
  .find({ occupation: /host/ })
  .where('name.last').equals('Ghost')
  .where('age').get(17).lt(66)
  .where('likes').in(['vaporizing', 'talking'])
  .limit(10)
  .sort('-occupation')
  .select('name occupation')
  .exec(callback);
```

### 二 查询API(Query)

|Query Builder| Javascript |
|:------------|:-----------| | |
| $where(js) | $where |
| all([path], val) | $all |
| and(array) | $and |
| batchSize(val) | _ |
| box(val, Upper) | _ |
| cast(model, [obj]) | _ |
| catch([reject]) | _ |
| center() | _ |
| centerSphere([path], val) | $centerSphere |
| circle([path], area) | $center / $centerSphere / $geoWithin |
| comment(Number) | _ |
| count([criteria], [callback]) | _ |
| cursor([options]) | QueryCursor |
| distinct([field], [criteria], [callback]) | _ |
| elemMatch(path, criteria) | $elemMatch |
| equals(val) | _ |
| exec([option], [callback]) | _ |
| exists([path], val) | $exists |
| find([criteria], [callback]) | _ |
| findOne([criteria], [projection], [callback]) | - |
| findOneAndRemove([conditions], [options], [callback]) | - |
| findOneAndUpdate([query], [doc], [options], [callback]) | - |
| geometry(object) | - |
| getQuery() | - |
| getUpdate() | - |
| gt([path], val) | $gt|
| gte([path], val) | $gte |
| hint(val) | $hint |
| in([path], val) | $in |
| intersects([arg]) | $geometry |
| lean(bool) | - |
| limit(val) | - |
| lt([path], Number) | $lt |
| lte([path], Number) | $lte |
| maxDistance([path], val) | $maxDistance |
| maxScan() | - |
| maxScan(val) | - |
| merge(source) | - |
| mod([path], Number) | $mod |
| ne([path], Number) | $ne |
| near([path], Object) | _ |
| nearSphere() | _ |
| nin([path], Number) | $nin |
| nor(array) | $nor |
| or(array) | $or |
| polygon | $polygon |
| populate(path, [select], [model], [match], [options]) | _ |
| read(pref, [tags]) | _ |
| regex([path], Number) | $regex |
| remove([criteria], [callback]) | remove |
| select(<Object, String>) | _ |
| selected() | _ |
| selectedExclusively() | _ |
| selectedInclusively() | _ |
| setOptions(options) | _ |
| size([path], Number) | $size |
| skip(Number) | cursor.skip |
| slaveOk(Boolean) | slaveOk |
| slice([path], Number) | $slice |
| snapshot() | cursor.snapshot |
| sort(<Object, String>) | cursor.sort |
| stream([options]) | QueryStream |
| tailable(bool, [opts], [opts.numberOfRetries], [opts.tailableRetryInterval]) | _ |
| then([resolve], [reject]) | Promise |
|toConstructor() | _ |
| update([criteria], [doc], [options], [callback]) | _ |
| where([path], [val])| _ |
| within() | $polygon / $box / $geometry / $center / $centerSphere |
| use$geoWithin | _ |
