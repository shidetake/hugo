+++
categories = ["Tech"]
date = "2017-06-26T22:44:57+09:00"
tags = ["API","Ruby"]
title = "RubyでGmail本文を取得する 2"

+++

[前回](../gmail_api_1/)はアクセストークンを取得して、メール本文を取得することに成功した。
ただしアクセストークンには期限があり、取得しなおさなくてはならない。
今回はリフレッシュトークンを使うことで、これを解決する。

<!--more-->

## リフレッシュトークンの取得
前回のアクセストークン取得の項に記載の通り。


## リフレッシュトークンを使ったメールの取得
前回からの差分

```diff
require 'google/api_client'
require 'json'

-ACCESS_TOKEN     = 'YourAccessToken'
+CLIENT_ID        = 'YourClientID'
+CLIENT_SECRET    = 'YourClientSecret'
+REFRESH_TOKEN    = 'YourRefreshToken'
APPLICATION_NAME = 'YourApplicationName'

# APIクライアントの準備
client = Google::APIClient.new(application_name: APPLICATION_NAME)
-client.authorization.access_token = ACCESS_TOKEN
+client.authorization = Signet::OAuth2::Client.new(
+  token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
+  audience:             'https://accounts.google.com/o/oauth2/token',
+  scope:                ['https://www.googleapis.com/auth/drive.file'],
+  client_id:     CLIENT_ID,
+  client_secret: CLIENT_SECRET,
+  refresh_token: REFRESH_TOKEN,
+)
+
+client.authorization.refresh!
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

これでこのシリーズは終わり。
