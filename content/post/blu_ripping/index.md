---
title: "MakeMKVとHandBrakeによるBlu-lay Discリッピング"
date: 2019-11-10T17:00:51+09:00
categories:
- Tech
tags:
- Ripping
- shell
---

DVDのリッピングについて[以前](../ripping_1/)書いたが、ブルーレイに未対応だったので対応した。

<!--more-->

# 概要
HandBrakeではBlu-rayをそのままリッピングできないので、MakeMKVというソフトを使う。
mkv形式にしてくれるので、これだけでリッピング完成としてもいいが、
ほとんど圧縮かけてないようなので、HandBrakeを使って圧縮する。ついでに必要に応じてチャプター毎に分割する。

# MakeMKVのインストール
Homebrewには無いので[公式サイト](https://makemkv.com/download)からインストーラーを使う。

# MakeMKVの使い方
GUIもあるが、ここでは`makemkvcon`というCUIを使う。
おそらく`/Applications/MakeMKV.app/Contents/MacOS/makemkvcon`にあるので、ここにパスを通す。

```bash
makemkvcon mkv dev:/dev/disk2 all ~/dist
```

こんな感じ。`/dev/disk2`にはBlu-lay Discを入れたドライブを環境に応じて設定する。
`~/dist`にファイルが出力される。

# HandBrakeによる加工
このままだとかなり重たいファイルなのと、場合によってはチャプターごとにファイルを分けたいので、
HandBrakeを使って加工する。
これについては[DVDリッピングのとき](../ripping_1/)と同じ（入力ファイルをisoでもDVDドライブでもなくMakeMKVで出力したmkvにするだけ）
なので割愛する。

# お約束
違法なリッピングを推奨しているわけではないので注意。
コピーガードされたBlu-rayをリッピングするのはダメ。ぜったい。
