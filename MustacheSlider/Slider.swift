//
//  Slider.swift
//  MustacheSlider
//
//  Created by Nicolaj Roos on 05/05/2018.
//  Copyright © 2018 Nicolaj Roos. All rights reserved.
//

import UIKit

/**
 The slider handles all button interactions, and also snaps the button to the closest numberView position.
 At first I experimented using a UISlider, but it seemed to limited so I made my own. I'm handling all touch interaction on the
 Slider level, and tell the button to animate, if need be. This was the best solution. Other solutions I experimented with, had issues with stealing touch events from the button.
 */

class Slider: UIView {
    
    enum DragDirection {
        case Left
        case Right
    }
    
    var
        button:AnimatedButton?,
        numberViewSize = 0,
        sliderHeight = 0,
        numberViewCount = 0,
        buttonOffset:CGFloat = 0,
        initialTouchX:CGFloat = 0,
        selectedButton = 0,
        numberViews = Array<NumberView>(),
        activeNumberView:NumberView?,
        margin = 0,
        containerView = UIView(),
        dragDirection = DragDirection.Left
    

    
    init(numberViewCount:Int, numberViewSize:Int, margin:Int) {
        
        self.numberViewCount = numberViewCount
        self.numberViewSize = numberViewSize
        self.margin = margin
        
        sliderHeight = numberViewSize + (margin * 2)
        
        self.button = AnimatedButton(size: numberViewSize, topMargin: 1)

        let sliderWidth = numberViewCount * numberViewSize + (margin * 2)
        
        super.init(frame: CGRect(x: 0, y: 0, width: sliderWidth, height: sliderHeight))
        
        self.backgroundColor = UIColor(hexString: "#FB986C")
        self.layer.cornerRadius = CGFloat(sliderHeight/2)
        
        let buttonX = numberViewSize * 4 // Start at the 5th position
        
        button?.isUserInteractionEnabled = false
        button?.frame = CGRect(x: buttonX, y: 0, width: numberViewSize, height: numberViewSize)
        
        containerView.frame = CGRect(x: margin, y: margin, width: sliderWidth - (margin * 2), height: sliderHeight - (margin * 2))
        
        addSubview(containerView)
        
        addNumbers()
        
        if let button = self.button {
            
            containerView.addSubview(button)
            containerView.sendSubview(toBack: button)
            
            let selectedButton = self.selectedNumberViewFrom(x:Int(button.frame.origin.x))
            
            activeNumberView = numberViews[selectedButton-1]
        }

        activeNumberView?.active = false
        
    }
    
    func addNumbers() {

        for index in 0...(numberViewCount-1) {
            
            let numberView = NumberView(number: index+1, size: numberViewSize)
            numberView.layer.cornerRadius = CGFloat(sliderHeight/2)
            numberView.frame = CGRect(x: index * numberViewSize, y: 0, width: numberViewSize, height: numberViewSize)
            
            containerView.addSubview(numberView)
            
            numberViews.append(numberView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch : UITouch! = touches.first
        let location = touch.location(in: self)
        
        guard let button = self.button else {
            return
        }
        
        guard location.x > button.frame.origin.x, location.x < button.frame.origin.x + button.frame.width else {
            return
        }
        
        let selectedButton = self.selectedNumberViewFrom(x:Int(button.frame.origin.x))
        activeNumberView = numberViews[selectedButton-1]
        activeNumberView?.active = true

        // Store the initial button touch location on the X axis
        initialTouchX = location.x
        
        buttonOffset = location.x - button.frame.origin.x
        button.animationStart(selectedButton: selectedButton)
   
    }
    
    func hoveredButtonIndexFrom(currentX:Int) -> Int {
        
        var hoveredButton = 0
        
        guard let button = self.button else {
            return hoveredButton
        }
        
        hoveredButton = Int(button.frame.origin.x) / numberViewSize
        
        return hoveredButton
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let button = self.button else {
            return
        }
        
        let touch : UITouch! = touches.first
        let location = touch.location(in: self)
        let hoveredButtonIndex = hoveredButtonIndexFrom(currentX: Int(button.frame.origin.x))
        
        button.selectedButtonIndex = hoveredButtonIndex
        
        if location.x > initialTouchX {
            dragDirection = .Right
        } else {
            dragDirection = .Left
        }
        
        let borderLeft = CGFloat(numberViewSize/2)
        let borderRight = CGFloat((numberViewCount * numberViewSize) - (numberViewSize/2))
        let buttonCenterX = button.center.x
        
        if dragDirection == .Left {
            
            if buttonCenterX >= borderLeft {
                
                let touchDistance = location.x - initialTouchX
                button.center.x = buttonCenterX + touchDistance
                initialTouchX = location.x
    
            }
            
        } else {

            if buttonCenterX <= borderRight {
                
                let touchDistance = location.x - initialTouchX
                button.center.x = buttonCenterX + touchDistance
                initialTouchX = location.x
                
            }
        }
    }
    
    func selectedNumberViewFrom(x:Int) -> Int {
        
        var selectedNumberView = 0
        
        guard let button = self.button else {
            return selectedNumberView
        }
        
        let buttonCurrentX = button.frame.origin.x
        selectedNumberView = (Int(buttonCurrentX) / numberViewSize) + 1

        return selectedNumberView <= numberViewCount ? selectedNumberView : numberViewCount
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let button = self.button else {
            return
        }
        
        let hoveredButton = hoveredButtonIndexFrom(currentX: Int(button.center.x))
        let buttonCenterX = Int(button.center.x)
        let numberViewCenterX = (hoveredButton * numberViewSize) + (numberViewSize / 2)
        let nextNumberViewCenterX = Int(numberViewCenterX + numberViewSize)
        let distanceLeft = buttonCenterX - numberViewCenterX
        let distanceRight = nextNumberViewCenterX - buttonCenterX
        var snapToX = 0

        if distanceLeft < distanceRight {
            
            // The slider button is closer to the current (hovered) numberView.
            snapToX = numberViewCenterX
            
        } else {
            
            // The slider button is closer to the next numberView.
            // Calculating the centerX value for the next numberView, the button should snap to.
            snapToX = nextNumberViewCenterX
            
        }
        
        UIView.animate(withDuration: 0.2, animations: { () in
            button.center.x = CGFloat(snapToX)
         })
        
        button.animationEnd()
        let selectedButton = self.selectedNumberViewFrom(x:Int(button.frame.origin.x))
        
        activeNumberView = numberViews[selectedButton-1]
        activeNumberView?.active = false
        
    }
    
}
