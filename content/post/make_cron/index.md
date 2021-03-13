---
title: "Makefileでcronを登録する"
date: 2017-12-17T11:18:31+09:00
categories:
- Tech
tags:
- cron
- Makefile
---

主に重複登録をしないようにするためのtipsを紹介する。

<!--more-->

## cron登録コマンド

```bash
echo "0 9,18 * * * /usr/local/bin/example.sh" | crontab
```

こんな感じ。とても簡単。
ただ、これは設定を上書きするという非常に危険なコマンド。
通常は以下のように使う。

```bash
(crontab -l; echo  "0 9,18 * * * /usr/local/bin/example.sh") | crontab
```

## Makefile化

```make
install:
    (crontab -l; echo  "0 9,18 * * * /usr/local/bin/example.sh") | crontab
```

そのまんま。これで、`make install`すれば`cron` に登録される。
これの問題点は、重複登録してしまうこと。

以下のように書くことで、重複登録が防げる。

```make
install:
	crontab -l | grep example.sh || \
		(crontab -l; echo  "0 9,18 * * * /usr/local/bin/example.sh") | crontab
```

`||`でつなぐことで、最初のコマンドが失敗したときだけ、次のコマンドを実行するようになる。
ここでは、既に登録されている`cron`を`grep`して、登録しようとしているスクリプトがあれば何もせず終了、
なければ登録する。

## uninstall
おまけ。uninstallは以下のように書けば良い。

```make
uninstall:
	crontab -l | grep -v example.sh | crontab
```
