//
//  MyMeterView.swift
//  CareTaker3
//
//  Created by Manabu Tonosaki on 2021/12/28.
//

import UIKit

class MyMeterView : UIView {
    
    struct LabelItem {
        var text: String
        var angleDeg: CGFloat
        var offset: CGPoint
    }
    
    var lastDate: String = ""
    var angleDeg: CGFloat = 45
    var labels = Array<LabelItem>()
    var title: String = "Hoge"
    
    override func draw(_ rect: CGRect) {
        
        let W = self.frame.size.width
        let H = self.frame.size.height
        let O = CGPoint(x: W / 2, y: W * 0.442) // 針の根本の座標
        let R = (H - (H - O.y) * 2)
        let Rx: CGFloat = 1.8
        let Rlabel = R * 0.75
        
        // メーターの画像をセルとピッタリのサイズで描画
        UIImage(named: "Meter")?.draw(in: CGRect(origin: .zero, size: CGSize(width: W, height: H)))
        
        // ラベル描画
        for label in labels {
            
            // 補助線
            do {
                let r0 = (R * 0.75) + (Rx * abs(cos(label.angleDeg)))
                let x0 = cos(label.angleDeg * Double.pi / 180.0) * r0 + O.x
                let y0 = -sin(label.angleDeg * Double.pi / 180.0) * r0 + O.y
                let r1 = (R * 0.70) + (Rx * abs(cos(label.angleDeg)))
                let x1 = cos(label.angleDeg * Double.pi / 180.0) * r1 + O.x
                let y1 = -sin(label.angleDeg * Double.pi / 180.0) * r1 + O.y
                let line = UIBezierPath();
                line.move(to: CGPoint(x: x0, y: y0));
                line.addLine(to: CGPoint(x: x1, y: y1));
                UIColor(red: 0.5, green: 1.0, blue: 1.0, alpha: 1.0).setStroke()
                line.lineWidth = 1
                line.stroke();

            }
            // ラベル数字
            do {
                let r0 = Rlabel + (Rx * abs(cos(label.angleDeg)))
                let x = cos(label.angleDeg * Double.pi / 180.0) * r0 + O.x + label.offset.x
                let y = -sin(label.angleDeg * Double.pi / 180.0) * r0 + O.y + label.offset.y
                label.text.draw(
                    at: CGPoint(x: x, y: y),
                    withAttributes: [
                        NSAttributedString.Key.foregroundColor : UIColor(red: 0.513725490196078, green: 0.686274509803922, blue: 0.694117647058824, alpha: 1),
                        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 6),
                    ]
                )
            }
        }
        // メーターの針を描画
        do {
            let line = UIBezierPath();
            line.move(to: O);
            let zrad = angleDeg * Double.pi / 180.0
            let r = R + (Rx * abs(cos(zrad)))
            line.addLine(to: CGPoint(x: cos(zrad) * r + O.x, y: -sin(zrad) * r + O.y));
            UIColor.red.setStroke()
            line.lineWidth = 2
            line.stroke();
        }
        // タイトル表示
        title.draw(
            at: CGPoint(x: 3, y: 3),
            withAttributes: [
                NSAttributedString.Key.foregroundColor : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1),
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 9),
            ]
        )
    }
}
