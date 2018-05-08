//
//  AnimatedButton.swift
//  MustacheSlider
//
//  Created by Nicolaj Roos on 05/05/2018.
//  Copyright © 2018 Nicolaj Roos. All rights reserved.
//

import UIKit

class AnimatedButton: UIView {
    
    var
        size = 0,
        topMargin = 0

    let
        knob = UIView(),
        popupKnob = UIView(),
        numberLabel = UILabel()
    
    var selectedButtonIndex: Int = 0 {
        willSet(newValue) {
            numberLabel.text = "\(newValue + 1)"
        }
    }
    
    init(size:Int, topMargin:Int) {
        
        self.size = size
        self.topMargin = topMargin
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
        
    }
    
    func setup() {
        
        knob.frame = CGRect(x: 0, y: 0, width: size, height: size)
        popupKnob.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        knob.backgroundColor = UIColor(hexString: "#ca6c42")
        popupKnob.backgroundColor = UIColor(hexString: "#fb986c")
        
        popupKnob.layer.cornerRadius = CGFloat(self.size)/2
        knob.layer.cornerRadius = CGFloat(self.size)/2
        
        numberLabel.frame = CGRect(x: 0, y: 0, width: size, height: size)
        numberLabel.textAlignment = NSTextAlignment.center
        numberLabel.textColor = UIColor.white
        numberLabel.font = UIFont(name: "OpenSans-Bold", size: 21)        
        
        updateNumberLabel()
        
        popupKnob.addSubview(numberLabel)
        
        addSubview(popupKnob)
        addSubview(knob)
        
        sendSubview(toBack: popupKnob)
   
    }
    
    func updateNumberLabel() {
        numberLabel.text = "\(selectedButtonIndex)"
    }
    
    func animationStart(selectedButton:Int) {
        
        self.selectedButtonIndex = selectedButton
        updateNumberLabel()
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: { () in
            
            var frame = self.popupKnob.frame
            frame.origin.y = -CGFloat(self.size + self.topMargin)
            self.popupKnob.frame = frame
        
        }, completion: nil)

    }
    
    func animationEnd() {
        
        UIView.animate(withDuration: 0.2, animations: { () in
            
            var frame = self.popupKnob.frame
            frame.origin.y = 0
            self.popupKnob.frame = frame
            
        })
        
    }
    
}
