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
        let O = CGPoint(x: W / 2 + 1, y: W * 0.442) // 針の根本の座標
        let R = (H - (H - O.y) * 2) * 1.05
        let Rx: CGFloat = R * 0.13
        let Rlabel = R * 0.62
        let zrad = angleDeg * Double.pi / 180.0

        // メーターの画像をセルとピッタリのサイズで描画
        UIImage(named: "Meter")?.draw(in: CGRect(origin: .zero, size: CGSize(width: W, height: H)))
        
        // メーターのぼかし画像
        let alphaBlue = angleDeg > 60.0 ? 1.0 : angleDeg / 60.0
        let alphaRed = angleDeg > 60.0 ? 0.0 : (60.0 - angleDeg) / 60.0
        UIImage(named: "MeterOuterBlue")?.draw(in: CGRect(origin: .zero, size: CGSize(width: W, height: H)), blendMode: .normal, alpha: alphaBlue)
        UIImage(named: "MeterOuterRed")?.draw(in: CGRect(origin: .zero, size: CGSize(width: W, height: H)), blendMode: .normal, alpha: alphaRed)

        // メモリと針
        for deg in stride(from: 180.0, to: -2.0, by: -120.0 / Double(labels.count - 1)) {

            let zrad = deg * Double.pi / 180.0
            // 補助線
            do {
                let r0 = (R * 0.71) + (Rx * abs(cos(zrad)))
                let x0 = cos(zrad) * r0 + O.x
                let y0 = -sin(zrad) * r0 + O.y
                let r1 = (R * 0.63) + (Rx * abs(cos(zrad)))
                let x1 = cos(zrad) * r1 + O.x
                let y1 = -sin(zrad) * r1 + O.y
                let line = UIBezierPath();
                line.move(to: CGPoint(x: x0, y: y0));
                line.addLine(to: CGPoint(x: x1, y: y1));
                UIColor(red: 0.5, green: 1.0, blue: 1.0, alpha: 1.0).setStroke()
                line.lineWidth = 2.0
                line.stroke();
            }
        }
        
        // ラベル描画
        for label in labels {
            
            let zrad = label.angleDeg * Double.pi / 180.0
            // ラベル数字
            do {
                let r0 = Rlabel + (Rx * abs(cos(zrad)))
                let x = cos(zrad) * r0 + O.x - abs(sin(zrad)) * 2.0
                let y = -sin(zrad) * r0 + O.y - abs(cos(zrad)) * 2.0
                label.text.draw(
                    at: CGPoint(x: x, y: y),
                    withAttributes: [
                        NSAttributedString.Key.foregroundColor : UIColor(red: 0.5, green: 1.0, blue: 1.0, alpha: 1),
                        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 7),
                    ]
                )
            }
        }
        // メーターの針を描画
        do {
            let line = UIBezierPath();
            line.move(to: O);
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
