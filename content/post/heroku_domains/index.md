---
title: "Herokuの公開URLをコマンドで確認する"
date: 2018-03-10T15:37:24+09:00
categories:
- Tech
tags:
- Heroku
---

最近、[Ruby on Railsチュートリアル](https://railstutorial.jp)を進めているんだけど、
その中でHerokuを使うことになる。で、途中まで進めて、別の日に続きをやろうとすると、作っているWebサービスのURLがわからなくなり、
いちいちHerokuにログインして確認するという手間が発生する。

たぶん`heroku`コマンドにあるだろうと思って探したらあったので、備忘録的に残しておく。

<!--more-->

```bash
$ heroku domains
```

これだけ。
