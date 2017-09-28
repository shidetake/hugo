+++
categories = ["Tech"]
date = "2017-09-26T23:42:10+09:00"
tags = ["Raspberry Pi","Amazon Dash Button"]
title = "Raspberry PiでSystemdを使ってdasherをサービス化"

+++

[Amazon Dash Buttonを使ってLINEに通知する方法](../dash_button)を以前書いた。
記事には記載していないが、このときは、init.dを使って自動起動するように設定していた。

最近はinit.dは古くて、Systemdが推奨されているようなので、これに書き換えることにした。

<!--more-->

## サンプルソース
[GitHubのWiki](https://github.com/maddox/dasher/wiki/Running-Dasher-on-a-Raspberry-Pi-at-startup)
にサンプルソースがあったのでそのまま記載する。

```bash
[Unit]
Description=Dasher
After=network.target

[Service]
Type=simple
#user with access to dasher files
User=root
WorkingDirectory=/home/pi/dasher
#use command "which npm" to determine correct location of NPM
ExecStart=/usr/local/bin/npm run start
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
```

### Unitセクション
SystemdではUnitという単位で処理を管理する。
init.dで言うサービスに当たる概念のようだ。

ここではdasherが1つのUnitということになる。

#### Description
Unitの説明を書く。

#### After
このUnitが起動するタイミングを記述する。
ここではnetwork.targetの後に実行することになる。

.targetというのは今回のように順序関係や依存関係を定義する際に、複数のUnitをグループ化するために使われる。
network.targetの実体は、`/lib/systemd/system/network.target`にあるが、内容を確かめずとも、ネットワーク関連のUnit群であることがわかる(のでこれ以上詳しくは見ない)。

ちなみにSystemdの起動時にはdefault.targetというUnitが有効化されることになっており、これに依存するUnitがまとめて有効化されていく。

### Serviceセクション
このセクションはUnitの種類によって異なる。
デーモンを起動する場合には.serviceなのでServiceセクションとなる。他にも上に出てきた.targetや.deviceなどいくつかの種類がある。

#### Type
サービスプロセスの起動完了の判定方法。
`simple`を指定すると、`ExecStart`で指定したコマンドを実行したタイミングで起動完了とみなす。

起動完了をどう使うかは未調査。上述のAfterなど順序関係のためだろうか。

#### User
実行ユーザを指定する。rootで実行することになる。

#### WorkingDirectory
実行時のカレントディレクトリを指定する。
ここではpiユーザーのhomeにdasherを取得したことになっている模様。
通常はセキュリティの観点からもpiユーザー以外にしているはずなので、ここは変更必須。

#### ExecStart
サービスを起動するコマンド。フルパスじゃないとダメらしい。
このタイミングではまだパスが通ってないのだろうか？

#### Restart
再起動条件を指定する。`on-failure`は終了コード0以外で停止した場合に再起動する設定。
ようするに異常終了した時は再起動してねってこと。

#### RestartSec
再起動する前の待ち時間。Restartの設定と合わせて読むと、異常終了を検知したら10秒後に再起動してねってこと。

#### KillMode
サービス停止時にプロセスが残っていた場合の処理を指定する。
`process`はメインプロセスが残っていたらkillする設定。

### Installセクション
systemctl enable/disableに関する設定群

#### WantedBy
init.dで言うrunlevelの指定に相当する。
`multi-user.target`はrunlevel 3に相当するので、CUIでログインすると起動することになる。


## セットアップ
上の設定を
`/etc/systemd/system/dasher.service`に置いて、

```bash
systemctl list-unit-files --type=service | dasher
```

すると、dasher.serviceがサービスとして認識されていることがわかる。
この時点ではdisable状態。

続いて自動起動を有効化する。

```bash
sudo systemctl enable dasher
```

してから、先程のコマンドを再送すると、enableに変わっているはず。
この状態で再起動する。そして、

```bash
sudo systemctl status dasher
```

でactive状態になっていればOK
