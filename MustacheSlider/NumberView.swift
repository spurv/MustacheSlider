//
//  NumberView.swift
//  MustacheSlider
//
//  Created by Nicolaj Roos on 05/05/2018.
//  Copyright © 2018 Nicolaj Roos. All rights reserved.
//

import UIKit

class NumberView: UIView {
    
    var label = UILabel()
    
    var active = false {
        
        willSet (newValue) {
            
            if newValue {
                label.textColor = UIColor(hexString: "#CA6C42")
                label.font = UIFont(name: "Open Sans", size: 21)
            } else {
                label.textColor = UIColor.white
                label.font = UIFont(name: "OpenSans-Bold", size: 21)
            }
        
        }
    }
    
    init(number:Int, size:Int) {

        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        label.frame = CGRect(x: 0, y: 0, width: size, height: size)
        label.font = UIFont(name: "Open Sans", size: 21)
        label.text = "\(number)"
        label.textColor = UIColor(hexString: "#CA6C42")
        label.textAlignment = NSTextAlignment.center

        self.addSubview(label)
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
