//
//  MyDetailView.swift
//  CareTaker3
//
//  Created by Manabu Tonosaki on 2021/12/28.
//

import UIKit
import MapKit

class MyDetailView : UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var intervalTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var homeMapSwitch: UISwitch!
    @IBOutlet weak var labelHomeMap: UILabel!
    @IBOutlet weak var labelLocationName: UILabel!

    var content: ContentModel?
    
    override func viewDidLoad() {
        
        // 空白領域タップでキーボード閉じる仕組み
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // コントロールを初期化
        guard let content = content else {
            fatalError("実行前に contentインスタンスを紐づけてください")
        }
        title = content.name
        intervalTextField.text = String(content.interval)
        datePicker.date = DateUtils.dateFromString(string: content.lastDate + " 00:00:00 +00:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
        
        // 地図のズームを調整する
        mapView.delegate = self
        let centerLon = 139.7474472
        let centerLat = 35.6458841
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let centerLocation = CLLocationCoordinate2DMake(centerLat, centerLon)
        let region = MKCoordinateRegion(center: centerLocation, span: span)
        mapView.region = region
        
        // 地図の拠点を収集する
        let poi = PoiClientYahoo()
        if let keyword = PoiClientYahoo.makeKeyword(sectionName: content.category, itemName: content.name) {
            poi.getPoiList(lon: centerLon, lat: centerLat, Rkm: 1.5, keyword: keyword) {
                success, items in
                
                guard success,
                      let items = items,
                let features = items.Feature else {
                    self.alert(caption: "ERROR", message: "施設検索サービスが利用できませんでした。後からやり直してください", button1: "OK")
                    return
                }
                DispatchQueue.main.async {
                    for item in features {
                        guard let lonlatstr = item.Geometry?.Coordinates else {
                            print("座標が入っていない施設情報はスキップ \(String(describing: item.Name))")
                            continue
                        }
                        let lonlatarray = lonlatstr.split(separator: ",")
                        guard
                            let lon = CLLocationDegrees(lonlatarray[0]),
                            let lat = CLLocationDegrees(lonlatarray[1])
                        else {
                            print("座標が入っていない施設情報はスキップ \(String(describing: item.Name))")
                            continue
                        }
                        
                        let pin = MKPointAnnotation()
                        pin.title = item.Name
                        pin.subtitle = item.Property?.Address ?? ""
                        pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        self.mapView.addAnnotation(pin)
                    }
                    self.mapView.setNeedsDisplay()

                    if content.isHome == true {
                        self.homeMapSwitch.setOn(false, animated: false)
                        self.homeImage.isHidden = false
                        self.mapView.isHidden = true
                        self.labelLocationName.isHidden = true
                    } else {
                        self.mapView.isHidden = false
                        self.homeImage.isHidden = true
                        self.homeMapSwitch.setOn(true, animated: true)
                        self.labelLocationName.isHidden = false
                        if content.locationName == nil {
                            self.labelLocationName.text = "※地図上のポイントを選択してください"
                        } else {
                            self.labelLocationName.text = content.locationName
                            var tarAnnotations = Array<MKAnnotation>()
                            for annotation in self.mapView.annotations {
                                if annotation.title == content.locationName {
                                    tarAnnotations.append(annotation)
                                }
                            }
                            if tarAnnotations.count > 0 {
                                self.mapView.selectedAnnotations.append(contentsOf: tarAnnotations)

                                // 選択されているときは、マップの中央にする
                                let tarAnnotation = tarAnnotations[0]
                                let centerLon = tarAnnotation.coordinate.longitude
                                let centerLat = tarAnnotation.coordinate.latitude
                                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                let centerLocation = CLLocationCoordinate2DMake(centerLat, centerLon)
                                let region = MKCoordinateRegion(center: centerLocation, span: span)
                                self.mapView.region = region
                            }
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.homeImage.isHidden = false
                self.mapView.isHidden = true
                self.homeMapSwitch.setOn(false, animated: true)
                self.homeMapSwitch.isEnabled = false
                self.labelHomeMap.text = "Home only"
                self.labelLocationName.isHidden = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        guard let annotation = view.annotation, let content = content else { return }
        let title = (annotation.title ?? "(no name)") ?? "(no name)"
        labelLocationName.text = title
        let updateFirebase = UpdateFirebase(section: content.section, row: content.row)
        updateFirebase.updateLocation(
            isHome: homeMapSwitch.isOn ? false : true,
            locationName: title,
            lon: annotation.coordinate.longitude,
            lat: annotation.coordinate.latitude
        )
    }
    
    @IBAction func didHomeMapSwitchValueChanged(_ sender: Any) {

        let content = content!
        let updateFirebase = UpdateFirebase(section: content.section, row: content.row)
        if homeMapSwitch.isOn {
            self.homeImage.isHidden = true
            self.mapView.isHidden = false
            self.labelLocationName.isHidden = false
            updateFirebase.updateLocation(isHome: false)
            if content.locationName == nil {
                self.labelLocationName.text = "※地図上のポイントを選択してください"
            } else {
                self.labelLocationName.text = content.locationName
            }
        } else {
            self.homeImage.isHidden = false
            self.mapView.isHidden = true
            self.labelLocationName.isHidden = true
            updateFirebase.updateLocation(isHome: true)
        }
    }
    
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        
        let content = content!
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        let today = formatter.string(from: Date())
        let updateFirebase = UpdateFirebase(section: content.section, row: content.row)
        updateFirebase.updateLastDate(withText:today)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func intervalEditingDidEnd(_ sender: Any) {
        
        let content = content!
        if let val = Int(intervalTextField.text ?? "x") {
            if val != content.interval {
                if val <= 0 || val > 366 {
                    alert(caption: "WARNING", message: "指定した値は Intervalとして使えません", button1: "Cancel"){
                        () in
                        DispatchQueue.main.async {
                            self.intervalTextField.text = "\(content.interval)"
                        }
                    }
                } else {
                    let updateFirebase = UpdateFirebase(section: content.section, row: content.row)
                    updateFirebase.updateInterval(withInt: val)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let content = content else {
            return
        }
        if let val = Int(intervalTextField.text ?? "x") {
            if val != content.interval {
                if val > 0 || val <= 366 {
                    let updateFirebase = UpdateFirebase(section: content.section, row: content.row)
                    updateFirebase.updateInterval(withInt: val)
                } else {
                    print("intervalに \(intervalTextField.text ?? "nil") を入力してたが 無視した")
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MacのキーボードでEnter押した時に、キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func datePrimaryActionTriggered(_ sender: Any) {
        
        // 強制的に元の日付にもどして、編集を無力化する
        let content = content!
        datePicker.date = DateUtils.dateFromString(string: content.lastDate + " 00:00:00 +00:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
    }
}
