+++
categories = []
date = "2017-07-10T22:41:58+09:00"
draft = false
tags = []
thumbnail = ""
title = "HandBrakeCLIによるDVDリッピング 2"

+++

[前回](../ripping_1/)からの続き。

## チャプター分割
チャプター毎にファイルを分割してリッピングしたい場合は`-c`オプションを使って
```bash
HandBrakeCLI -Z 'H.265 MKV 1080p30' --all-audio -s '1,2,3,4,5,6' -c 1 -i hoge.iso -o hoge_1.mkv
HandBrakeCLI -Z 'H.265 MKV 1080p30' --all-audio -s '1,2,3,4,5,6' -c 2 -i hoge.iso -o hoge_2.mkv
HandBrakeCLI -Z 'H.265 MKV 1080p30' --all-audio -s '1,2,3,4,5,6' -c 3 -i hoge.iso -o hoge_3.mkv
```

いちいちチャプター数だけ繰り返すのはバカらしいので、
for文を使って以下のように書く。

```bash
for ((i = 1; i <= 3; i++)); do
  HandBrakeCLI -Z 'H.265 MKV 1080p30' --all-audio -s '1,2,3,4,5,6' -c $i -i hoge.iso -o hoge_$(printf %02d $i).mkv
done
```

3の部分を変数にして、引数として渡してやれば、任意のチャプター数に対応できる。


## チャプター数の取得
いちいち、チャプター数を指定するのは面倒なので、
`lsdvd`を使ってチャプター数を取得する。

```bash
brew install lsdvd
```

からの

```bash
lsdvd hoge.iso
```

これでチャプター数を含む標準出力が得られる。
あとは適当に文字列を抜き出して使えば良い。
以下に`awk`を使った例を示す。

```bash
lsdvd hoge.iso | grep Chapters | awk '{gsub(/,/,""); print $6}'
```

先ほどのfor文と組み合わせて

```bash
chapter_num=`lsdvd hoge.iso | grep Chapters | awk '{gsub(/,/,""); print $6}'`
for ((i = 1; i <= $chapter_num; i++)); do
  HandBrakeCLI -Z 'H.265 MKV 1080p30' --all-audio -s '1,2,3,4,5,6' -c $i -i hoge.iso -o hoge_$(printf %02d $i).mkv
done
```

長くなってきたので、いったんここまで。
[次回](../ripping_3/)はisoファイルではなく、DVDドライブから直接mkvに変換する方法。


## お約束
違法なリッピングを推奨しているわけではないので注意。
コピーガードされたDVDをリッピングするのはダメ。ぜったい。
