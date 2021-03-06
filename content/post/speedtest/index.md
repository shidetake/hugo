---
title: "スピードテストを定期的に実行して回線速度の推移を見る"
date: 2017-10-16T22:43:05+09:00
categories:
- Tech
tags:
- cron
- Raspberry Pi
- network
thumbnailImage: /img/speedtest.png
---

自宅の回線速度が遅いので、なんとか改善できないか考えている。
まずは、現状把握ということで、スピードテストを実施した。
常に遅いのか、時間によって遅いのかなどがわかれば改善の手がかりになるかもしれないと考え、
cron定期的に実行してくれるようにした。

Raspberry Piで動作する。

<!--more-->

## 実行結果
まずは作成したスクリプトで取得したデータを載せる。
csv形式で左からping値 [ms]、Download [Mbit/s], Upload [Mbit/s], 実行日時。

```csv
167.908,2.23,5.37,2017/10/16 00:00:39
129.306,7.82,5.82,2017/10/16 01:00:41
88.187,18.31,19.27,2017/10/16 02:00:36
87.879,24.88,21.74,2017/10/16 03:00:36
156.129,26.47,16.25,2017/10/16 04:00:41
75.103,25.61,21.42,2017/10/16 05:00:36
94.37,26.99,21.17,2017/10/16 06:00:40
76.879,24.55,21.35,2017/10/16 07:00:38
71.107,24.72,21.67,2017/10/16 08:01:39
254.614,19.98,16.24,2017/10/16 09:00:37
81.341,23.46,18.63,2017/10/16 10:00:37
89.473,23.30,17.17,2017/10/16 11:00:38
275.777,23.40,10.58,2017/10/16 12:00:38
110.481,22.26,17.16,2017/10/16 13:00:36
149.522,25.06,18.38,2017/10/16 14:00:36
82.292,17.59,8.26,2017/10/16 15:00:38
202.99,17.83,4.05,2017/10/16 16:00:38
102.178,17.50,4.52,2017/10/16 17:00:37
114.628,14.78,16.30,2017/10/16 18:00:38
102.745,12.89,13.11,2017/10/16 19:00:39
1795.938,11.67,1.76,2017/10/16 20:00:51
699.312,6.57,3.20,2017/10/16 21:00:52
352.963,3.47,0.98,2017/10/16 22:00:47
480.408,3.98,2.48,2017/10/16 23:00:47
```

ついでにグラフ化。
![image](/img/speedtest.png)

昼間は25Mbpsくらい出ているらしい。15時以降から下がりだして、21時から25時までは1桁というありさま。


## speedtest-cli
### インストール
スピードテストをCUIで行う場合は、恐らくspeedtest-cli一択。
`pip`で入れるので、Pythonのインストールから。

```bash
sudo apt install python
```

続いて

```bash
pip install speedtest-cli
```

### 使い方
一番シンプルなのは

```bash
speedtest
```

これだけ。`speedtest-cli`でも同じ結果が得られる。

データ収集には不要な出力が多いのと、サーバーをping値で自動選択してしまうので、
以下のように使うことにする。

```bash
speedtest --server 6476 --simple
```


## シェルスクリプト
### 1ライン化
上のコマンドをベースに、`cron`で実行するシェルスクリプトを作成する。
1行にping, download, uploadをまとめたいので`tr`でカンマと置換する。
また、速度以外は不要なので`awk`を使って、以下のように書く。

```bash
/usr/local/bin/speedtest --server 6476 --simple | awk '{print $2}' | tr '\n' ',' >> ~/tmp/speedtest.log
```

`cron`ではコマンドを絶対パスで指定する必要があるので、絶対パスで書いている。

### 実行日時を追加
```bash
date "+%Y/%m/%d %H:%M:%S" >> ~/tmp/speedtest.log
```

### リトライ機能を追加
ここまででほぼ完成だけど、結構な頻度で失敗してたのでリトライ機能を追加した。
`cron`でリトライしてくれればいいのに。
以下が完成形。

```bash
#!/bin/bash

command="/usr/local/bin/speedtest --server 6476 --simple"

NEXT_WAIT_TIME=0
until RET=`$command` || [ $NEXT_WAIT_TIME -eq 4 ]; do
  sleep $(( (NEXT_WAIT_TIME++) * 60 ))
done
echo "$RET" | awk '{print $2}' | tr '\n' ',' >> ~/tmp/speedtest.log
date "+%Y/%m/%d %H:%M:%S" >> ~/tmp/speedtest.log
```

4回までリトライする。リトライ間隔は、1分、2分、3分、4分と伸ばしていくようにした。


## cron
上のシェルスクリプトを`cron`に登録する。

```bash
crontab -e
```

すると、エディタが立ち上がる（もしくはエディタ選択画面になるので選ぶ）ので、
以下のように1時間毎に実行するように設定する。

```bash
0 * * * * /usr/local/bin/speedtest_cron.sh
```

これで完成。


## 注意点
実行環境はRaspberry Piを想定しているが、場合によってはRaspberry Pi自体がボトルネックとなって、
正しい速度が取れないので注意。うちの場合はMac Book Airを有線でつないで測定してもだいたい同じような値が取れることを確認している。

## 関連ポスト
[マンション付属の光回線が早くなった話](../ebroad/)
