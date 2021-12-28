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
    
    var angleDeg: CGFloat = 45
    var labels = Array<LabelItem>()
    var title: String = "Hoge"
    
    override func draw(_ rect: CGRect) {

        let Pi = 3.141592
        let W = self.frame.size.width
        let H = self.frame.size.height
        let O = CGPoint(x: W / 2, y: W * 0.442) // 針の根本の座標
        let R = (H - (H - O.y) * 2)
        let Rx: CGFloat = 1.15
        let Rlabel = R * 0.75
        
        // メーターの画像をセルとピッタリのサイズで描画
        UIImage(named: "Meter")?.draw(in: CGRect(origin: .zero, size: CGSize(width: W, height: H)))
        
        // ラベル描画
        for label in labels {
            let r0 = Rlabel + (Rx * abs(cos(label.angleDeg)))
            let x = cos(label.angleDeg * Pi / 180.0) * r0 + O.x + label.offset.x
            let y = -sin(label.angleDeg * Pi / 180.0) * r0 + O.y + label.offset.y
            label.text.draw(
                at: CGPoint(x: x, y: y),
                withAttributes: [
                    NSAttributedString.Key.foregroundColor : UIColor(red: 0.513725490196078, green: 0.686274509803922, blue: 0.694117647058824, alpha: 1),
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 6),
                ]
            )

        }
        
        // メーターの針を描画
        let line = UIBezierPath();
        line.move(to: O);
        let zrad = angleDeg * Pi / 180.0
        let r = R + (Rx * abs(cos(zrad)))
        line.addLine(to: CGPoint(x: cos(zrad) * r + O.x, y: -sin(zrad) * r + O.y));
        UIColor.red.setStroke()
        line.lineWidth = 2
        line.stroke();
        
        // タイトル表示
        title.draw(
            at: CGPoint(x: 3, y: 3),
            withAttributes: [
                NSAttributedString.Key.foregroundColor : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1),
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
            ]
        )
    }
}
