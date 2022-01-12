//
//  MyMeterCell.swift
//  CareTaker3
//
//  Created by Tasuku Furuki on 2021/12/24.
//

import UIKit

class MyMeterCell : UICollectionViewCell {
    
    var displayModel: ContentModel? = nil
    var isFadein: Bool = false
    
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
        self.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1.0)
        
        if isFadein {
            meter.alpha = 0.0
            UIView.animate(withDuration: Double.random(in: 0.2...1.5), delay: Double.random(in: 0.2...0.5), options: [.curveEaseIn],
            animations: {
                meter.alpha = 1.0
            })
        }
    }
    
    func makeLabels(interval: Int) -> [MyMeterView.LabelItem] {
        switch interval {
            case let num where num % 7 == 0:
                return [
                    MyMeterView.LabelItem(text: "\(interval/7*7)", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "\(interval/7*6)", angleDeg: 60+17.14*6, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/7*5)", angleDeg: 60+17.14*5, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/7*4)", angleDeg: 60+17.14*4, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/7*3)", angleDeg: 60+17.14*3, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/7*2)", angleDeg: 60+17.14*2, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/7*1)", angleDeg: 60+17.14*1, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60+17.14*0, offset: CGPoint(x: 0, y: 0))
                ]
            case let num where num % 6 == 0:
                return [
                    MyMeterView.LabelItem(text: "\(interval)", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "\(interval/6*5)", angleDeg: 60+20*5, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/6*4)", angleDeg: 60+20*4, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/6*3)", angleDeg: 60+20*3, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/6*2)", angleDeg: 60+20*2, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/6*1)", angleDeg: 60+20*1, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60+24*0, offset: CGPoint(x: 0, y: 0))
                ]
            case let num where num % 5 == 0:
                return [
                    MyMeterView.LabelItem(text: "\(interval)", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "\(interval/5*4)", angleDeg: 60+24*4, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/5*3)", angleDeg: 60+24*3, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/5*2)", angleDeg: 60+24*2, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/5*1)", angleDeg: 60+24*1, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60+24*0, offset: CGPoint(x: 0, y: 0))
                ]
            case let num where num % 4 == 0:
                return [
                    MyMeterView.LabelItem(text: "\(interval)", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "\(interval*3/4)", angleDeg: 150, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/2)", angleDeg: 120, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/4)", angleDeg: 90, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: 0, y: 0))
                ]
            case let num where num % 3 == 0:
                return [
                    MyMeterView.LabelItem(text: "\(interval)", angleDeg: 182, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval*2/3)", angleDeg: 140, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "\(interval/3)", angleDeg: 100, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: 0, y: 0))
                ]
            case let num where num % 2 == 0:
                return [
                    MyMeterView.LabelItem(text: "\(interval)", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "\(interval/2)", angleDeg: 120, offset: CGPoint(x: 0, y: 0)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: 0, y: 0))
                ]
            default:
                return [
                    MyMeterView.LabelItem(text: "\(interval)", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: 0, y: 0))
                ]
        }
    }
}
