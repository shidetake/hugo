---
title: "素のRubyで日時を扱う"
date: 2019-12-16T23:07:30+09:00
categories:
- Tech
tags:
- Ruby
#thumbnailImage: //example.com/image.jpg
---

Railsではなく素のRubyで日時を扱うときのベストプラクティスについて。
毎回悩むのでここに書いておく。

<!--more-->

Timeを使うか、Dateを使うか、DateTimeを使うか。
それについては
[RubyとRailsにおけるTime, Date, DateTime, TimeWithZoneの違い](https://qiita.com/jnchito/items/cae89ee43c30f5d6fa2c)
に従ってTimeを使う。

これで間に合う場合は終わり。

ただ、ちょっと計算したいとなったときには、やはりActiveSupportを使うのがよい。
ActiveSupportを使うかどうか迷うポイントとして、一部の機能しか使わないのに、
あんなに巨大なライブラリを使ってしまっていいのだろうか…という罪悪感があると思う（あるよね？）。

その罪悪感を小さくするために、ActiveSupportには一部の機能だけをrequireできるようになっている。
本当のミニマリストは使う機能だけをrequireするのかもしれないが、ここは少し妥協して、日時系の機能全般をrequireすることにする。

```ruby
require 'active_support/time'
```

これで大抵の機能が使えるようになる。

https://github.com/rails/rails/blob/master/activesupport/lib/active_support/time.rb  
を見るとわかるが、このファイルは正にそのためのものだ。
