//
//  MyMeterView.swift
//  CareTaker3
//
//  Created by Manabu Tonosaki on 2021/12/28.
//

import UIKit

class MyMeterView : UIView {
    
    var angleDeg: CGFloat = 45
    
    override func draw(_ rect: CGRect) {

        let Pi = 3.141592
        let W = self.frame.size.width
        let H = self.frame.size.height
        let O = CGPoint(x: W / 2, y: W * 0.442) // 針の根本の座標
        let R = (H - (H - O.y) * 2)
        let Rx = 1.15
        
        // メーターの画像をセルとピッタリのサイズで描画
        UIImage(named: "Meter")?.draw(in: CGRect(origin: .zero, size: CGSize(width: W, height: H)))
        
        // メーターの針を描画
        let line = UIBezierPath();
        line.move(to: O);
        let zrad = angleDeg * Pi / 180.0
        let r = R + (Rx * abs(cos(zrad)))
        line.addLine(to: CGPoint(x: cos(zrad) * r + O.x, y: -sin(zrad) * r + O.y));
        UIColor.red.setStroke()
        line.lineWidth = 2
        line.stroke();
    }
}
