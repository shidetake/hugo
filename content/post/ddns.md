+++
categories = ["Tech"]
date = "2017-09-18T21:51:18+09:00"
tags = ["Raspberry Pi"]
title = "DDNSでLANの外から自宅のRaspberry PiにSSH接続する"

+++

普通のインターネット回線では、グローバルIPが定期的に変わってしまうため、
自宅に置いたRaspberry Piなんかをサーバー代わりに使うには不便。

かといって、固定グローバルIPアドレスを貰うには月1000円くらい払う必要がある。

そこで、Dynamic DNS (DDNS) というサービスを利用することにする。

<!--more-->

## DDNSとは
Domain Name System (DNS) は、ドメイン名とIPアドレスを紐付けるシステムのこと。
サーバーへのアクセスは通常、IPアドレスによって対象サーバーを判別するが、
IPアドレスは数値の羅列で人間には覚えにくいので、ドメイン名という覚えやすい名称に変換する。

Dynamic DNSというのは、その紐付けをDynamicに、つまり動的に行う。
グローバルIPが変化しても、ドメイン名との紐付けを再度行うことで、ドメイン名の固定ができるというわけ。

世の中にはこんな便利なサービスを無料で提供してくれる人たちがいる。

## 登録
いくつか選択肢はあるが、今回は[no-ip](https://www.noip.com)というサービスを使うことにした。
なぜなら、[raspberryPi にnoipでDDNSの設定をする方法](http://portaltan.hatenablog.com/entry/2017/02/07/092205)というサイトを参考にしたため。

登録・設定から自動実行まで、ほぼほぼこの手順でいける。

ただ、Dynamic Domain Update Client (DUC) の自動起動の設定だけは、少し好みではなかったのでアレンジした。

## DUCの自動起動設定
`/etc/init.d/noip2`を以下のように書き換えた。
自動起動の設定を先頭に追加しただけ。これにより、わざわざrc.localに起動のためのコマンドを書かなくとも、
自動で起動してくれる。

```bash
#! /bin/sh
# /etc/init.d/noip2.sh
### BEGIN INIT INFO
# Provides:          noip2
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
### END INIT INFO

# Supplied by no-ip.com
# Modified for Debian GNU/Linux by Eivind L. Rygge <eivind@rygge.org>
# corrected 1-17-2004 by Alex Docauer <alex@docauer.net>

# . /etc/rc.d/init.d/functions  # uncomment/modify for your killproc

DAEMON=/usr/local/bin/noip2
NAME=noip2

test -x $DAEMON || exit 0

case "$1" in
    start)
    echo -n "Starting dynamic address update: "
    start-stop-daemon --start --exec $DAEMON
    echo "noip2."
    ;;
    stop)
    echo -n "Shutting down dynamic address update:"
    start-stop-daemon --stop --oknodo --retry 30 --exec $DAEMON
    echo "noip2."
    ;;

    restart)
    echo -n "Restarting dynamic address update: "
    start-stop-daemon --stop --oknodo --retry 30 --exec $DAEMON
    start-stop-daemon --start --exec $DAEMON
    echo "noip2."
    ;;

    *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac
exit 0
```

## 動作確認
自動起動するかどうか、実際に再起動して確かめる。

```bash
sudo reboot
```

からの、

```bash
sudo /usr/local/bin/noip2 -S

Process 445, started as noip2, (version 2.1.9)
Using configuration from /usr/local/etc/no-ip2.conf
Last IP Address set 0.0.0.0
Account hogehoge@gmail.com
configured for:
	host  hogehoge.ddns.net
Updating every 30 minutes via /dev/wlan0 with NAT enabled.
```

とすると、なんとIPアドレスが0になってしまっている。
失敗か？と思ったが、特に問題なくつながる。
30分後に再度確認したら正しいIPアドレスがセットされていた。どうやら起動後1発目のIPアドレスセットの内容は反映されないらしい。
Last IP Addressとあるので、初回より前のアドレスを出そうとしているのだろうか。
