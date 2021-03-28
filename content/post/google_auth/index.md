---
title: "任意のGoogle APIをRubyで使うときの手順"
date: 2019-12-22T17:53:28+09:00
categories:
- Tech
tags:
- Ruby
- API
---

GmailのAPIについては[以前記事にした](../gmail_api_1.md)が、
別のAPI使うときにどうするのか、毎回悩むので汎用的な部分はここにまとめることにした。

<!--more-->

今回使いたくなったのはGoogle Photos APIsなのでこれを例に進めるが、
汎用的に使えるように書く。

# APIの有効化
Gmailのときと同じく、[Google API Console](https://console.developers.google.com/)で使いたいAPIを有効化する。
ライブラリからAPIの検索ができる。今回は'Photo'で検索すると、Photos Library API[^a]が出てくるので、
選択して、'有効にする'をクリック。

[^a]: ここでの名前はPhotos Library APIだけど、ドキュメントにはGoogle Photos APIsと出る

このページにドキュメントへのリンクがあるので、開いておく（あとで使う）。

続いて、Google API Consoleのトップに戻ってから、認証情報に進む。

認証情報を作成 -> OAuthクライアントID -> その他

で認証情報を作成して、JSONファイルをダウンロードする。

# Scopeの取得
APIのドキュメントにScopeが書かれているので、それを探す。
Photos Library APIの場合は、Overviewの中のAuthorizationにScope記載ページへのリンクがあった。
ここから、必要な権限を取れるScopeを選ぶ。

ちなみにGmailとかDriveだとgoogle-api-clientというgemにScopeのパスを定義した定数があるので、それを使うことが多い。
[ここ](https://github.com/googleapis/google-api-ruby-client/tree/master/generated/google/apis)に使いたいAPIがあればそれを使うと良い。


# Access Tokenの取得
googleauthというgemを使う。

```bash
$ gem install googleauth
```

からの

```ruby
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"
require "json"

class Auth
  OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
  CREDENTIALS_PATH = "credentials.json".freeze
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  TOKEN_PATH = "token.yaml".freeze
  SCOPE = ['https://www.googleapis.com/auth/photoslibrary.readonly']

  def initialize
    authorize
  end

  private

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize
    client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts "Open the following URL in the browser and enter the " \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
      )
    end
    credentials
  end
end

Auth.new
```

ここで、CREDENTIALS_PATHはダウロードしたJSONファイル。これはrbファイルと同じ場所に置いている前提。
また、SCOPEには取得したScopeを書く。

このスクリプトを実行すると、初回はAccess Tokenを取得するためのページへのURLが表示される。
ブラウザでここを開くと、アクセス権限を渡してよいか聞かれるのでOKを押すと、コードが表示されるので、それをターミナルに貼り付けてエンターキーを押すと、
Access Tokenが取得できる。
