+++
categories = ["Tech"]
date = "2017-10-01T22:27:25+09:00"
tags = ["Ubuntu","Linux","mysql"]
title = "Ubuntu 16.04にmysqlをインストールする"

+++

aptで適当にインストールすれば使えると思っていたが、意外と手間取ったので、手順を書いておく。

<!--more-->

## install
ここは簡単。

```bash
sudo apt install mysql-server mysql-client
```

こんだけ。ただ、既に別のバージョンのものが入っていたりするので、キレイにしたい場合は、
先に以下のコマンドを送る。別バージョンのmysqlを削除することで、色々動かなくなる可能性もあるので注意。

```bash
sudo dpkg -l | grep mysql
```

でインストール済みのmysqlを確認して、

```bash
sudo apt remove --purge mysql*
```

こんな感じで、消していく。`--purge`オプションは、関連する設定ファイルも一緒に削除するのもので、
この後の再インストール後に悪さしないためにも指定しておいたほうがよい。


## rootパスワード設定

```bash
mysql -uroot
```

で入ろうとしたら、`ERROR 1698 (28000): Access denied for user 'root'@'localhost'`と怒られた。
初期パスワードは無かったと思ってたが、仕様が変わったらしい。

で色々やってみたんだけど、実はやっぱり初期パスワードは設定されていなくて、`sudo`つければいいだけだった。
ということで、改めて

```bash
sudo mysql -uroot
```

これでOK。
