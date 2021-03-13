---
title: "WindowsでもLinuxでも動くMakefileを書く"
date: 2017-11-05T08:38:17+09:00
categories:
- Tech
tags:
- Makefile
- Windows
- Linux
---

シェルのコマンドが異なるので、両方に対応するのは意外とめんどくさい。
今回はシンボリックリンクを作成するコマンドを例にして説明する。

Windowsの`make`はMinGWのものを想定している。

<!--more-->

## Linux専用

```make
install:
    ln -s ~/dotfiles/.vimrc ~/.vimrc;
```

シンボリックリンクを作るコマンドをそのまま書いただけ。


## Windows専用

```make
install:
    cmd.exe /C mklink $(HOME)\.vimrc $(HOME)\dotfiles\.vimrc
```

Windowsのコマンドを使う場合は、`cmd.exe /C`を接頭語のように付ける。
これで、`mklink`コマンドが使えるようになる。

Linux用と比べて以下の点が異なっている

- sourceとtargetの順番が逆
- パスのディレクトリ区切りがバックスラッシュ
- ホームディレクトリの指定がチルダではなく`$(HOME)`
    - 環境変数`HOME`をあらかじめ指定する必要があるかも

## 両対応版
愚直に書くと以下のようになる。
`ifeq ($(OS),Windows_NT)`でWindowsかどうかを分岐させている。

```make
install:
ifeq ($(OS),Windows_NT)
    ln -s ~/dotfiles/.vimrc ~/.vimrc;
else
    cmd.exe /C mklink $(HOME)\.vimrc $(HOME)\dotfiles\.vimrc
endif
```

この書き方だと、シンボリックリンクを張るファイルが増えると、Linux用とWindows用のそれぞれに追記する必要がある。
以下のように書くとスマート。

```make
install:
	make link SOURCE:=$(HOME)/dotfiles/.vimrc TARGET:=$(HOME)/.vimrc

link:
ifeq ($(OS),Windows_NT)
    cmd.exe /C mklink $(subst /,\,$(TARGET)) $(subst /,\,$(SOURCE))
else
    ln -s $(SOURCE) $(TARGET)
endif
```

`link`というターゲットを用意して、関数のように使っている。
`link`の中でOSを分岐させることで、それを呼び出す側を統一できるというわけ。

`subst`というのは`make`の文字列置換関数。スラッシュをバックスラッシュに置き換えるために使っている。


## おまけ
ここまででほぼ完成。

最後に鬱陶しい出力を抑えるために、`--no-print-directory`したり、シンボリックリンクが既に存在している場合にはコマンドをスキップする仕組みを入れたものを載せる
（解説は割愛）。

```make
MAKEFLAGS += --no-print-directory

install:
	make link SOURCE:=$(HOME)/dotfiles/.vimrc TARGET:=$(HOME)/.vimrc

link:
ifeq ($(OS),Windows_NT)
	@cmd.exe /C if not exist $(subst /,\,$(TARGET)) \
		cmd.exe /C mklink $(subst /,\,$(TARGET)) $(subst /,\,$(SOURCE))
else
	@if [ ! -e $(TARGET) ]; then\
		ln -s $(SOURCE) $(TARGET);\
	fi
endif
```
