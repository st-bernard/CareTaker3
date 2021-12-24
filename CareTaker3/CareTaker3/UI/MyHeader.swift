//
//  MyHeader.swift
//  CareTaker3
//
//  Created by Tasuku Furuki on 2021/12/24.
//

import UIKit

class MyHeader: UICollectionReusableView {
    
    func setTitle(str: String) {
        let label = viewWithTag(66001) as! UILabel
        label.text = str
    }
}
