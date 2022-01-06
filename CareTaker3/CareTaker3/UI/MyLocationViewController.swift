//
//  MyLocationViewController.swift
//  CareTaker3
//
//  Created by kai on 2022/01/05.
//

import UIKit
import MapKit
import Tono

class MyLocationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, TspResolverDelegate, MKMapViewDelegate{

    
    var model: ContentsListModel!
    let firebaseRepository = FirebaseContentRepository()
    let dueSpanDays = 7
    var locationList = Array<ContentModel> ()
    var uniqueShopList = Array<ShopItem>()
    
    @IBOutlet weak var locationMap: MKMapView!
    @IBOutlet weak var locationTable: UITableView!
    @IBOutlet weak var dueLabel: UILabel!
    @IBAction func clickTestButton(_ sender: Any) {

        
    }
    
    
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print(sender.value)
    }
    
    override func viewDidLoad() {
        //MapViewのカスタマイズ
        locationMap.delegate = self
        locationMap.showsUserLocation = true
        locationMap.userTrackingMode = .followWithHeading
        
        
        //        locationTable.delegate = self
        firebaseRepository.reloadFirebaseData{
            success,newModel in
            if success {
                self.model = newModel
                self.resetLocationList()
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqueShopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTable.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath)
        let shop = uniqueShopList[indexPath.row]
        cell.textLabel?.text = shop.locationName ?? "noname"
        cell.detailTextLabel?.text = "髪の毛とか出す"
        cell.imageView?.image = UIImage(named: "annotation\(indexPath.row+1)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shop = uniqueShopList[indexPath.row]
        let annotation =  locationMap.annotations
            .filter{
                ($0.title ?? "") == (shop.locationName ?? "")
            }.first
        if let annotation = annotation{
            locationMap.selectedAnnotations = [annotation]
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let centerLocation = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)
            let region = MKCoordinateRegion(center: centerLocation, span: span)
            locationMap.region = region
            
        }
        
    }
    
    
    struct ShopItem:Hashable, TspNode {
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

        // Locationリストから店舗の場所を取得して地図に貼る（店舗が同じだったら重複を削除）
        let shopList = locationList.filter{
            $0.isHome == false
        }.map{
            ShopItem(locationName:$0.locationName, locationLon:$0.locationLon, locationLat:$0.locationLat, address:"")
        }.filter{
            $0.locationName != nil && $0.locationLon != nil && $0.locationLat != nil
        }
        uniqueShopList = Array(Set( shopList ) )
        if uniqueShopList.count > 0 {
            for item in uniqueShopList {
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
        //uniqueShopListの順番を巡回セールスマン法で最短順にする
        //二点間距離計算関数をつくる
        
        //TSPresolverで最短経路
        //TODO: 現在地起点の時はLoop、現在地起点無しの時はShuffle
        let tsp = TspResolverShuffle()
        tsp.delegate = self
        uniqueShopList = tsp.solve(data: uniqueShopList) as! [ShopItem]
        locationTable.reloadData()
        
        //uniqueShopListの各ノード間をルート探索しルートの線を描画
        for nodeIndex in 1..<uniqueShopList.count {
            let nodeFrom = uniqueShopList[nodeIndex-1]
            let nodeTo = uniqueShopList[nodeIndex]
            
            print("junban =\(nodeFrom.locationName!) \(nodeTo.locationName!)")
            
            let sourcePlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: nodeFrom.locationLat!, longitude: nodeFrom.locationLon!))
            let destinationPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: nodeTo.locationLat!, longitude: nodeTo.locationLon!))
            let directionRequest = MKDirections.Request()
            
            directionRequest.transportType = .walking
            
            directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
            directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate {
                (response, error) in
                guard let directionResponse = response else {
                    if let error = error {
                        debugPrint("calculation error of directions \(error.localizedDescription)")
                    }
                    return
                }
                // ルートを追加
                let route = directionResponse.routes[0]
                //self.locationMap.route = route
                self.locationMap.addOverlay(route.polyline, level: .aboveRoads)
            }
        }
        
        
        
    }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolygonRenderer(overlay: overlay)
//        renderer.strokeColor = .systemBlue
//        renderer.lineWidth = 4.0
//        return renderer
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func getTspCost(from: TspNode, to: TspNode, stage: TspCaluclationStage) -> Double {
        guard let shop0 = from as? ShopItem else { fatalError() }
        guard let shop1 = to as? ShopItem else { fatalError() }
        let cost = getDistance(shop0: shop0, shop1: shop1)
        return cost
    }
    
    func getDistance(shop0: ShopItem,shop1: ShopItem) -> Double{
        guard shop0.locationLat != nil && shop0.locationLon != nil && shop1.locationLat != nil && shop1.locationLon != nil else{
            fatalError("shop0/1 should have Lon and Lat")
        }
        let meter = GeoEu.getDistanceGrateCircle(lon0: shop0.locationLon!, lat0: shop0.locationLat!, lon1: shop1.locationLon!, lat1: shop1.locationLat!)
        return meter * 1.37 //直線距離を道路距離に変換する概算係数
    }
    
    
}
