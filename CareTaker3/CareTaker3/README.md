#  ビルドに必要な準備

## Firebaseの設定
次のファイルを Firebaseアプリケーションからダウンロードして、xcodeプロジェクトルートに保存してください。
```GoogleService-Info.plist```

## Yahoo POIサービス利用の設定
Private.plistファイルを新規作成して、xcodeプロジェクトルートに保存してください。
内容は次のとおりです。

ルート名は、Root：Dictionary　です。

|  Key  |  Type  |  Value |
| ---- | ---- |
|  YahooPoiApplicationId  |  String  | xx99xxXxXXXxxxXXXx9XXxXXXxXxXXXxxxX9xXXxx9XxxxX9Xxx9Xxx- |
| PoiPattern | String | https://map.yahooapis.jp/search/local/V1/localSearch?output=json&appid=@SECRET@&query=@KEYWORD@&lat=@LAT@&lon=@LON@&dist=@Rkm@ |

Yahoo POIサービスの詳細は次のURLからご確認ください。
https://developer.yahoo.co.jp/webapi/map/
