//
//  MyLocationViewController.swift
//  CareTaker3
//
//  Created by kai on 2022/01/05.
//

import UIKit
import MapKit

class MyLocationViewController : UIViewController{
    var model: ContentsListModel!
    let firebaseRepository = FirebaseContentRepository()
    let dueSpanDays = 7
    var locationList = Array<ContentModel> ()
    
    @IBOutlet weak var locationMap: MKMapView!
    @IBOutlet weak var locationTable: UITableView!
    @IBOutlet weak var dueLabel: UILabel!
    
    
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print(sender.value)
    }
    
    override func viewDidLoad() {
        firebaseRepository.reloadFirebaseData{
            success,newModel in
            if success {
                self.model = newModel
                self.resetLocationList()
            }
        }
    }
    
    struct ShopItem:Hashable {
        var locationName:String?
        var locationLon:Double?
        var locationLat:Double?
        var address:String?
        func hash(into hasher: inout Hasher) {
            if locationName != nil{
                hasher.combine(locationName!)
            }
            if locationLon != nil{
                hasher.combine(locationLon!)
            }
            if locationLat != nil{
                hasher.combine(locationLat!)
            }
        }
    }
    
    
    
    private func resetLocationList (){
        // モデルの一覧から納期が切れているもの又は納期がdueSpanDays以内のものを一覧してLocation一覧に格納する
        let today = Date()
        guard let due = Calendar.current.date(byAdding: .day, value: dueSpanDays, to: today) else {fatalError()}
        let list = model.contents.flatMap{
            $0
        }.filter{
            $0.isActive
        }.filter{
            let dateTime = DateUtils.dateFromString(string: $0.lastDate + " 00:00:00 +00:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
            return dateTime < due
            
        }
        locationList = list
        for item in locationList {
            print("targetItem =\(item.name) \(item.lastDate)")
        }
        // Locationリストから店舗の場所を取得して地図に貼る（店舗が同じだったら重複を削除）
        let shopList = locationList.filter{
            $0.isHome == false
        }.map{
            ShopItem(locationName:$0.locationName, locationLon:$0.locationLon, locationLat:$0.locationLat, address:"")
        }.filter{
            $0.locationName != nil && $0.locationLon != nil && $0.locationLat != nil
        }
        let uniqueShopList = Array(Set( shopList ) )
        if uniqueShopList.count > 0 {
            for item in uniqueShopList {
                print("uniqueShop =\(item.locationName!) \(item.locationLon!)")
                let pin = MKPointAnnotation()
                pin.title = item.locationName ?? "noname"
                pin.subtitle = item.address ?? "noname"
                pin.coordinate = CLLocationCoordinate2D(latitude: item.locationLat!, longitude: item.locationLon!)
                locationMap.addAnnotation(pin)
            }
            let centerLon = uniqueShopList.map{
                $0.locationLon
            }.compactMap{
                $0
            }.reduce(0){
                $0 + $1
            } / Double(uniqueShopList.count)
            let centerLat = uniqueShopList.map{
                $0.locationLat
            }.compactMap{
                $0
            }.reduce(0){
                $0 + $1
            } / Double(uniqueShopList.count)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let centerLocation = CLLocationCoordinate2DMake(centerLat, centerLon)
            let region = MKCoordinateRegion(center: centerLocation, span: span)
            locationMap.region = region
        }
    }
    
    
}
