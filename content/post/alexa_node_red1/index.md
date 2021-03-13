---
title: "AlexaとNode-REDを利用したスマートホームスキル作成時の注意"
date: 2018-01-28T07:56:05+09:00
categories:
- Tech
tags:
- Smart home
- Apple TV
- systemd
thumbnailImage: /img/alexa_node_red1.png
---

最近、AlexaとNode-REDを連携してスマートホームスキルを作っている。
[前回のApple TVを操作するスクリプト](../pyatv/)もその一環だったのだが、うまく動かなかったのでその対処法を書く。

<!--more-->

## AlexaとNode-REDの連携
[Amazon Echoとラズパイで、音声で照明をon/offする](https://qiita.com/kikuzo/items/753b5065dde9633bda18)という記事を参考にした。

丁寧に書いてあって、補足する必要が全く無いので、連携についてはこちらの記事を読むといい。


## execにpyatvを設定

![image](/img/alexa_node_red1.png)

こんな感じで、「Alexa, テレビつけて」でmenuボタンを押すようにしたんだけど、うまく動かない。
よく見ると、`atvremote`コマンドが見つからないというエラーが出ていた。

systemdで起動しているサービスは、ユーザーの環境変数を読み込まないらしい。
systemdについては[前にも書いた](../dasher_systemd/)が、絶対パスで書かないといけないとか、いろいろ作法があって面倒くさい。

## systemdの設定変更
`pyenv`を使って導入したソフトをsystemdで使う場合の注意点は[`pyenv`の公式に記載があった](https://github.com/pyenv/pyenv/wiki/Deploying-with-pyenv)のでこれを参考にした。

まず以下のコマンドでNode-REDのサービスファイルの場所を調べる。

```
sudo systemctl status nodered
```

たぶん `/lib/systemd/system/nodered.service`にある。
これを書き換える。

```bash
Environment="PI_NODE_OPTIONS=--max_old_space_size=256"
Environment="PATH=/home/user_name/.pyenv/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
```

`PI_NODE_OPTIONS`という環境変数を設定しているところの下に、`PATH`の設定を追加する。
デフォルトでは、`/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`が`PATH`に設定されているようなので、
そこに追加する形。

ちなみに環境変数の展開もできないので、こんな書き方はNG。ホントに面倒くさい。

```bash
Environment="PATH=/home/user_name/.pyenv/shims:$PATH"
```
