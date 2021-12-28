//
//  MyMeterView.swift
//  CareTaker3
//
//  Created by Manabu Tonosaki on 2021/12/28.
//

import UIKit

class MyMeterView : UIView {
    override func draw(_ rect: CGRect) {
        UIImage(named: "Meter")?.draw(in: CGRect(origin: .zero, size: CGSize(width: self.frame.size.width, height: self.frame.size.height)))
    }
}
