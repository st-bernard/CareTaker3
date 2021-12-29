//
//  MyMeterCell.swift
//  CareTaker3
//
//  Created by Tasuku Furuki on 2021/12/24.
//

import UIKit

class MyMeterCell : UICollectionViewCell {
    
    var displayModel: ContentModel? = nil
    
    func checkLocationInputted(model: ContentModel) -> Bool {
        if PoiClientYahoo.makeKeyword(sectionName: model.category, itemName: model.name) == nil {
            return true // Home onlyは、地図登録しなくて良い
        }
        if model.isHome == nil {
            return false
        }
        if model.isHome == true {
            return true
        }
        if model.locationName == nil {
            return false
        }
        return true
    }
    
    // セルの値を決める
    func setValue(model: ContentModel) {
        
        guard let meter = contentView.viewWithTag(99101) as? MyMeterView else {
            fatalError("ContentViewが MyMeterViewオブジェクトを期待した設計")
        }

        if let noLocMark = contentView.viewWithTag(99102) {
            noLocMark.isHidden = checkLocationInputted(model: model)
        }

        
        displayModel = model
        meter.lastDate = model.lastDate
        let now = Date()
        let lastDateCalc = DateUtils.dateFromString(string: model.lastDate + " 00:00:00 +00:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
        let elapsedDays = Calendar.current.dateComponents([.day], from: lastDateCalc, to: now).day ?? 999
        var percent = CGFloat(elapsedDays) / CGFloat(model.interval)
        percent = max(0, percent)
        let adeg = max(-5, 185.0 - percent * 125.0)
        meter.angleDeg = adeg
        
        meter.title = model.name
        meter.labels = makeLabels(interval: model.interval)
        meter.setNeedsDisplay() // meter再描画要求（<--重要）
    }
    
    func makeLabels(interval: Int) -> [MyMeterView.LabelItem] {
        switch interval {
            case 40: return [
                MyMeterView.LabelItem(text: "40", angleDeg: 182, offset: .zero),
                MyMeterView.LabelItem(text: "30", angleDeg: 150, offset: CGPoint(x: 0, y: 1)),
                MyMeterView.LabelItem(text: "20", angleDeg: 120, offset: CGPoint(x: -1, y: 2)),
                MyMeterView.LabelItem(text: "10", angleDeg: 90, offset: CGPoint(x: -2, y: 3)),
                MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 4))
            ]
            case 30: return [
                MyMeterView.LabelItem(text: "30", angleDeg: 182, offset: CGPoint(x: 0, y: 1)),
                MyMeterView.LabelItem(text: "20", angleDeg: 140, offset: CGPoint(x: 0, y: 3)),
                MyMeterView.LabelItem(text: "10", angleDeg: 100, offset: CGPoint(x: -2, y: 4)),
                MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 5))
            ]
            case 14:
                return [
                    MyMeterView.LabelItem(text: "14", angleDeg: 182, offset: .zero),
                    //MyMeterView.LabelItem(text: "12", angleDeg: 60+17.14*6, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "10", angleDeg: 60+17.14*5, offset: CGPoint(x: 1, y: 3)),
                    //MyMeterView.LabelItem(text: "8", angleDeg: 60+17.14*4, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "6", angleDeg: 60+17.14*3, offset: CGPoint(x: 1, y: 3)),
                    //MyMeterView.LabelItem(text: "4", angleDeg: 60+17.14*2, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "2", angleDeg: 60+17.14*1, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60+17.14*0, offset: CGPoint(x: -1, y: 6))
                ]
            case 10: return [
                MyMeterView.LabelItem(text: "10", angleDeg: 182, offset: .zero),
                MyMeterView.LabelItem(text: "5", angleDeg: 120, offset: CGPoint(x: 1, y: 4)),
                MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 5))
            ]
            case 9: return [
                MyMeterView.LabelItem(text: "9", angleDeg: 182, offset: CGPoint(x: 0, y: 1)),
                MyMeterView.LabelItem(text: "6", angleDeg: 140, offset: CGPoint(x: 0, y: 3)),
                MyMeterView.LabelItem(text: "3", angleDeg: 100, offset: CGPoint(x: -2, y: 4)),
                MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 5))
            ]
            case 8:
                return [
                    MyMeterView.LabelItem(text: "8", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "4", angleDeg: 120, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 6))
                ]
            case 7:
                return [
                    MyMeterView.LabelItem(text: "7", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "6", angleDeg: 60+17.14*6, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "5", angleDeg: 60+17.14*5, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "4", angleDeg: 60+17.14*4, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "3", angleDeg: 60+17.14*3, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "2", angleDeg: 60+17.14*2, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "1", angleDeg: 60+17.14*1, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60+17.14*0, offset: CGPoint(x: -1, y: 6))
                ]
            case 6: return [
                MyMeterView.LabelItem(text: "6", angleDeg: 182, offset: CGPoint(x: 0, y: 1)),
                MyMeterView.LabelItem(text: "4", angleDeg: 140, offset: CGPoint(x: 0, y: 3)),
                MyMeterView.LabelItem(text: "2", angleDeg: 100, offset: CGPoint(x: -2, y: 4)),
                MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 5))
            ]
            case 4:
                return [
                    MyMeterView.LabelItem(text: "4", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "2", angleDeg: 120, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 6))
                ]
            case 3: return [
                MyMeterView.LabelItem(text: "3", angleDeg: 182, offset: CGPoint(x: 0, y: 1)),
                MyMeterView.LabelItem(text: "2", angleDeg: 140, offset: CGPoint(x: 0, y: 3)),
                MyMeterView.LabelItem(text: "1", angleDeg: 100, offset: CGPoint(x: -2, y: 4)),
                MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 5))
            ]
            case 2:
                return [
                    MyMeterView.LabelItem(text: "2", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "1", angleDeg: 120, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 6))
                ]
            case 1:
                return [
                    MyMeterView.LabelItem(text: "1", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 6))
                ]
            default:
                return [
                    MyMeterView.LabelItem(text: "\(interval)", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 6))
                ]
        }
    }

}
