//　Yahoo
//  PoiClient.swift
//  CareTaker3
//
//  Created by Manabu Tonosaki on 2021/12/29.
//

import Foundation

class PoiClientYahoo {
    struct ResultInfo : Decodable {
        var Count: Int
        var Total: Int
        var Start: Int
        var Status: Int
        var Description: String?
        var Copyright: String?
        var Latency: Double
    }
    struct Geometry : Decodable {
        var Coordinates: String
    }
    struct Property : Decodable {
        var Yomi: String?
        var Address: String?
        var Tel1: String?
    }
    struct Feature : Decodable {
        var Id: String
        var Gid: String?
        var Name: String?
        var Geometry: Geometry?
        var Property: Property?
    }
    struct JsonItem : Decodable {
        var ResultInfo: ResultInfo?
        var Feature: [Feature]?
    }
    
    let urlPattern: String
    
    init() {
        let path = Bundle.main.path(forResource: "Private", ofType: "plist")
        let configurations = NSDictionary(contentsOfFile: path!)
        guard let property = configurations as? [String : Any] else {
            fatalError("Private.plistがロードできませんでした")
        }

        // https://map.yahooapis.jp/search/local/V1/localSearch
        //      ?appid=@SECRET@
        //      &query=@KEYWORD@
        //      &lat=@LAT@
        //      &lon=@LON@
        //      &dist=@Rkm@
        guard let url = property["PoiPattern"] as? String else { fatalError() }
        guard let sec = property["YahooPoiApplicationId"] as? String else { fatalError() }
        urlPattern = url.replacingOccurrences(of: "@SECRET@", with: sec)
    }
    
    // YahooAPIを検索する
    func getPoiList(lon: Double, lat: Double, Rkm: Double, keyword: String, callback: @escaping (Bool, JsonItem?) -> Void) {
        let keyescaped = keyword.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        if keyescaped.isEmpty {
            fatalError("キーワードの％エスケープができなかった")
        }
        var urlstr = urlPattern.replacingOccurrences(of: "@KEYWORD@", with: keyescaped)
        urlstr = urlstr.replacingOccurrences(of: "@LON@", with: String(lon))
        urlstr = urlstr.replacingOccurrences(of: "@LAT@", with: String(lat))
        urlstr = urlstr.replacingOccurrences(of: "@Rkm@", with: String(Rkm))
        guard let url = URL(string: urlstr) else {
            fatalError("URLのフォーマットが期待された値ではなかった \(urlstr)")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0    // set timeout in second(s)

        URLSession
            .shared                                                 // シングルトン
            .dataTask(with: urlRequest) {                           // URLSessionDataTaskオブジェクト。Httpクライアントの非同期処理
                (data, response, error) in                          // 末尾クロージャ
                
                //==== ERROR HANDLING ====
                if let error = error {                              // コールバック errorを安全にアンラップして、値が入っていたらエラーと分かる
                    print( "エラー発生！ \(error.localizedDescription)" )
                    callback(false, nil)
                    return
                }
                //===== NORMAL CASE =====
                guard let data = data else { return }               // dataのアンラップと 明示例外処理(return)
                let decoder = JSONDecoder()
                let json: JsonItem? = try? decoder.decode(JsonItem.self, from: data)
                callback(true, json)
            }
            .resume()
    }
}
