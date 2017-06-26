+++
categories = []
date = "2017-06-20T22:55:21+09:00"
draft = false
tags = []
thumbnail = ""
title = "RubyでGmail本文を取得する 1"

+++

GmailのAPIをRubyで使う方法を何回かに分けて書く。

## API準備
まずはAPIを使うための準備。https://console.developers.google.com/ にアクセスして、プロジェクトを作成する。
それから、Gmail APIを有効にし、認証情報を追加する。

- 使用するAPI => Gmail API
- APIを呼び出す場所 => その他のUI
- アクセスするデータの種類 => ユーザーデータ

あとは適当に選んで進めると、クライントIDとクライアントシークレットが取得できる。


## Access Tokenの取得
取得したクライアントIDとクライアントシークレットから、
以下のスクリプトでアクセストークンとリフレッシュトークンを取得できる。

```ruby
require 'net/http'
require 'uri'
require 'oauth2'
require 'launchy'

CLIENT_ID     = 'YourClientID'
CLIENT_SECRET = 'YourClientSecret'

client = OAuth2::Client.new(
  CLIENT_ID, CLIENT_SECRET,
  :site => "https://accounts.google.com",
  :token_url => "/o/oauth2/token",
  :authorize_url => "/o/oauth2/auth")
auth_url = client.auth_code.authorize_url(
  :redirect_uri => 'urn:ietf:wg:oauth:2.0:oob',
  :scope => 'https://www.googleapis.com/auth/gmail.readonly')
 
# 表示されるURLをブラウザで開く
Launchy.open auth_url
 
print "authorization code:"
authorization_code = gets.chomp

res = Net::HTTP.post_form(URI.parse('https://accounts.google.com/o/oauth2/token'),
                          {'client_id'     => CLIENT_ID,
                           'client_secret' => CLIENT_SECRET,
                           'redirect_uri'  => 'urn:ietf:wg:oauth:2.0:oob',
                           'grant_type'    => 'authorization_code',
                           'code'          => authorization_code})
puts res.body
```

## メールの取得
取得したアクセストークンを以下のように使って、Gmail APIが使える。
以下は、auto-confirm@amazon.co.jpからの受信メールを取得するスクリプト。

```ruby
require 'google/api_client'
require 'json'

ACCESS_TOKEN     = 'YourAccessToken'
APPLICATION_NAME = 'YourApplicationName'

# APIクライアントの準備
client = Google::APIClient.new(application_name: APPLICATION_NAME)
client.authorization.access_token = ACCESS_TOKEN
gmail = client.discovered_api('gmail')

# query
res = client.execute(
  api_method: gmail.users.messages.list,
  parameters: {'userId' => 'me', 'q'=>'from:auto-confirm@amazon.co.jp'},
)

# parse
if res.status == 200
  json = JSON.parse(res.body)
  json['messages'].each do |mail_ids|
    mail = client.execute(
      api_method: gmail.users.messages.get,
      parameters: {'userId' => 'me', 'id'=>mail_ids['id']},
    )
    p mail.body
  end
else
  puts 'error'
end
```

## 今後
アクセストークンには期限があり、一定時間経過すると使えなくなってしまう。
これを解決するのがリフレッシュトークンを使った方法。[次回](../gmail_api_2/)はこれを使っていつでもAPIを利用できるようにする。
