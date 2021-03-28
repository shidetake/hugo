---
title: "Heroku上のRailsアプリのDBをリセットする"
date: 2018-10-28T11:15:57+09:00
categories:
- Tech
tags:
- heroku
- rails
---

HerokuでホスティングしているRailsアプリのDB構造を変えて、
`rails db:migrate:reset`したくなったんだけど、そのままのコマンドではだめだったので調査した。

<!--more-->

失敗したときのログがこちら

```bash
rails aborted!
ActiveRecord::ProtectedEnvironmentError: You are attempting to run a destructive action against your 'production' database.
If you are sure you want to continue, run the same command with the environment variable:
DISABLE_DATABASE_ENVIRONMENT_CHECK=1
```

どうやら、productionのDBを破壊するようなコマンドはそのままでは通らないらしい。
ということで、ここに書かれているように、`DISABLE_DATABASE_ENVIRONMENT_CHECK=1`にして実行する。以下にようにコマンドに続けて環境変数をセットするだけ。

```bash
$ heroku run rails db:migrate:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1
```

ちなみに、このようにコマンドに続けて環境変数をセットしただけだと、一時的に環境変数を変えるだけなので安心。
常に`DISABLE_DATABASE_ENVIRONMENT_CHECK=1`にしておきたい場合は、

```bash
$ heroku config:set DISABLE_DATABASE_ENVIRONMENT_CHECK=1
```

とすればよいが、危険なので推奨しない。
