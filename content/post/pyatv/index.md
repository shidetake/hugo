---
title: "Apple TVをRaspberry Piで操作"
date: 2018-01-26T22:28:20+09:00
categories:
- Tech
tags:
- Apple TV
- Raspberry Pi
- Smart home
---

スマートホーム化のために、いろんな家電をRaspberry Piで動かせるようにしている。
テレビはほとんどApple TVのために存在しているので、これを動かしてみた。

使ったのは、`pyatv`というツール。

<!--more-->

[postlund/pyatv](https://github.com/postlund/pyatv)にインストール方法から使い方まで書いてあるが、
一部わかりにくいところがあったので、そこだけ説明する。

## 初期設定
`pip install pyatv`したあと、ペアリングが必要。
iTunesのホームシェアリングを有効にしている場合はいらないようだけど、
無効の場合は、

```bash
atvremote pair
```

して、Apple TV側で、設定 > リモコンとデバイス > Remote Appとデバイス と進み、pyatvを選択して、pinに1234と入力すればよい。


## 動作確認

```bash
atvremote -a menu
```

これでMENUボタンを押したときと同じように動けばOK。
