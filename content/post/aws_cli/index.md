---
title: "AWSのRDSインスタンスをCLIで操作"
date: 2018-05-13T17:45:37+09:00
categories:
- Tech
tags:
- AWS
- API
---

AWSのRDSは使っていないときは停止しないともったいない。
とは言え、毎回ブラウザでログインして操作するのはかったるいので、コマンドラインで操作できるようにした。
`aws`コマンドは既に導入しているという前提。

<!--more-->

# インスタンス名の取得
操作するインスタンスの名前を取得する。
自分で名前を付けているので、わざわざ取得しなくても知っていると思うが。
飛ばして次に進んでも良い。

```bash
$ aws rds describe-db-instances
```

とすると、ずらずらとインスタンスの情報が出てくる。
`DBInstanceIdentifier`という項目に名前がある。

# 停止
以下のコマンドで停止できる。

```bash
$ aws rds stop-db-instance --db-instance-identifier $instance
```

# 開始
以下のコマンドで開始できる。

```bash
$ aws rds start-db-instance --db-instance-identifier $instance
```

GitHubに[簡単に操作するためのシェルスクリプト](https://github.com/shidetake/aws/blob/master/aws_rds.sh)を置いたので、参考にして欲しい。
インスタンスの名前と状態のリスト表示、全インスタンスの開始、全インスタンスの停止ができる（はず）。
手元の環境だと1インスタンスしかないので、複数インスタンスがある場合のテストはしていない。

# 参考
[RDS の停止機能を使ってコストを半分まで削減してみた](https://blog.manabusakai.com/2017/06/stopping-rds/)
