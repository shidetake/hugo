+++
categories = ["Tech"]
date = "2017-07-19T22:36:23+09:00"
tags = ["Ripping"]
title = "HandBrakeCLIによるDVDリッピング 3"

+++

[前回](../ripping_2/)からの続き。
これまではisoファイルからリッピングする形だったが、DVDドライブから直接リッピングする。

<!--more-->

## DVDドライブのパスを取得
`diskutil`コマンドを使う（たぶんmacOSでしか使えない）。
DVDをドライブに入れた状態で、

```bash
diskutil list
```

すると、HDD含め、OSが認識しているディスクのパーティション一覧が出てくる。
NAMEの部分に入れたDVDの名前が表示されているのがあるはず。
例えば以下のような感じ。

```bash
/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:                            VIBY_521               *2.0 GB     disk2
```

この場合、`/dev/disk2`を入力として指定することでDVDから直接リッピングが可能になる。

```bash
HandBrakeCLI -Z 'H.265 MKV 1080p30' --all-audio -s '1,2,3,4,5,6' -c 1 -i /dev/disk2 -o hoge_1.mkv
```

前回の最後のスクリプトと組み合わせて、

```bash
chapter_num=`lsdvd /dev/disk2 | grep Chapters | awk '{gsub(/,/,""); print $6}'`
for ((i = 1; i <= $chapter_num; i++)); do
  HandBrakeCLI -Z 'H.265 MKV 1080p30' --all-audio -s '1,2,3,4,5,6' -c $i -i /dev/disk2 -o hoge_$(printf %02d $i).mkv
done
```

ここまでで、かなり形になったので今回でラストとする。
ただ、実はこれだけだと使えないタイプのDVDがある。
そのあたりは、そのうち載せようと思う。スクリプトを少し整理してGitHubで公開する予定。


## お約束
違法なリッピングを推奨しているわけではないので注意。
コピーガードされたDVDをリッピングするのはダメ。ぜったい。
