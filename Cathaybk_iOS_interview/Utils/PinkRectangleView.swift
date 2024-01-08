//
//  PinkRectangleView.swift
//  Cathaybk_iOS_interview
//
//  Created by LoganMacMini on 2024/1/4.
//

import UIKit

class PinkRectangleView: UIView {
    
    // 新增一個屬性存儲顏色
    var rectangleColor: UIColor = .hotPink {
        didSet {
            // 調用 setNeedsDisplay() 以便更新視圖
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        // 1
        guard let context = UIGraphicsGetCurrentContext() else {
          return
        }
        // 2
        context.setFillColor(rectangleColor.cgColor)  // 使用屬性中的顏色
        // 3
        context.fill(bounds)
    }
    
    // 新增的函式用於修改顏色
    func changeColor(to color: UIColor) {
        rectangleColor = color
    }
}

