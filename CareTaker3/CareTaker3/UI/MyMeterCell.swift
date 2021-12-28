//
//  MyMeterCell.swift
//  CareTaker3
//
//  Created by Tasuku Furuki on 2021/12/24.
//

import UIKit

class MyMeterCell : UICollectionViewCell {
    
    // セルの値を決める
    func setValue(model: ContentModel) {
        
        guard let meter = contentView as? MyMeterView else {
            fatalError("ContentViewが MyMeterViewオブジェクトを期待した設計")
        }
        let now = Date()
        let lastDateCalc = DateUtils.dateFromString(string: model.lastDate+" 00:00:00 +00:00", format: "yyyy年MM月dd日 HH:mm:ss Z")
        let elapsedDays = Calendar.current.dateComponents([.day], from: lastDateCalc, to: now).day ?? 999
        var percent = CGFloat(elapsedDays) / CGFloat(model.interval)
        percent = max(0, percent)
        let adeg = max(-5, 180.0 - percent * 120.0)
        meter.angleDeg = adeg
        meter.title = "\(model.name)"
        meter.labels = makeLabels(interval: model.interval)

//        let label1 = contentView.viewWithTag(77001) as! UILabel
//        label1.text = model.name
//
//        let label2 = contentView.viewWithTag(77002) as! UILabel
//        label2.text = model.lastDate
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
            case 10: return [
                MyMeterView.LabelItem(text: "10", angleDeg: 182, offset: .zero),
                MyMeterView.LabelItem(text: "5", angleDeg: 120, offset: CGPoint(x: 1, y: 4)),
                MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 5))
            ]
            case 2:
                return [
                    MyMeterView.LabelItem(text: "2", angleDeg: 182, offset: .zero),
                    MyMeterView.LabelItem(text: "1", angleDeg: 120, offset: CGPoint(x: 1, y: 3)),
                    MyMeterView.LabelItem(text: "0", angleDeg: 60, offset: CGPoint(x: -1, y: 6))
                ]
            default: return []
        }
    }

}
