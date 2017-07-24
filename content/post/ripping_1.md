+++
categories = []
date = "2017-07-03T22:08:55+09:00"
draft = false
tags = []
thumbnail = ""
title = "HandBrakeCLIによるDVDリッピング 1"

+++

DVDのリッピングというのは、設定が異常に多い。

まず大きいところで、コーデック。汎用性の高いH.264にするのか、先を見越してH.265にするのか。
コンテナはどうする？mp4なんかはよく見るし汎用性ありそう。でも字幕や音声を切り替えるならmkvを選んだ方がいい。
フレームレートは？ノイズ除去フィルタの種類や強さも決めなきゃ。  

と言った具合に無数に決めることがあり、それをいちいち設定してたら何十枚もあるDVDをリッピングするのにどれだけ時間がかかるかわからない。
しかも、今回設定した内容を次に覚えてないとまたノイズフィルタのかかり具合を見極める作業を繰り返すことになる。

そういった面倒なことを避けるために、DVDをドライブに挿入したら、あとはコマンドを一発送るだけでいつもの設定でリッピングできるようにした。

## HandBrakeCLI
今回使ったのは、有名なリッピングソフトであるHandBrakeのCUIバージョンであるHandBrakeCLI。
Homebrewにはなかったので公式サイトからダウンロードしてインストールする。

## ISOイメージからの変換
まずはISOイメージから適当な設定で変換する。

```bash
HandBrakeCLI -i hoge.iso -o hoge.mkv
```

こんな感じ。デフォルトのオプションがどうなってるかはhelpに書いてあるとは思うが長すぎて読んでられない。


## もう少しちゃんとした変換
完全にマニュアルでオプションを設定するより、プリセットオプションと組み合わせたほうがよい。
以下のコマンドで、プリセットオプションの一覧が出てくる。
```bash
HandBrakeCLI -z
```

画質重視＋音声や字幕の切り替えがしたいのでmkv形式のH.265 MKV 1080p30にしてみる。

```bash
HandBrakeCLI -Z 'H.265 MKV 1080p30' -i hoge.iso -o hoge.mkv
```

せっかく音声と字幕の切り替えができるmkv形式にしたのに、このままでは1種類しか取り込んでくれないので、
`--all-audio`オプションと`-s`オプションを使って

```bash
HandBrakeCLI -Z 'H.265 MKV 1080p30' --all-audio -s '1,2,3,4,5,6' -i hoge.iso -o hoge.mkv
```

こんな感じ。
DVDからの取り込みやチャプター分割など、もう少し突っ込んだ内容は[次回](../ripping_2)以降。


## お約束
違法なリッピングを推奨しているわけではないので注意。
コピーガードされたDVDをリッピングするのはダメ。ぜったい。