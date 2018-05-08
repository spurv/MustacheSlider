//
//  ViewController.swift
//  MustacheSlider
//
//  Created by Nicolaj Roos on 05/05/2018.
//  Copyright © 2018 Nicolaj Roos. All rights reserved.
//

import UIKit
import GradientView


/**
 First of all, to gain an understanding of the code, a few key concepts is explained here:
 Inside the slider, is a containerview, which in turn contains all the necessary UI parts.
 These parts are the button (the one the user touches/interacts with), the numbers (1-8) which is called numberViews.
 The button contains a knob and a popupKnob, and handles all animation of these.
 */

class ViewController: UIViewController {

    let numberViewCount = 8,
        numberViewSize = 46,
        margin = 2
    
    var sliderWidth:Int {
        return (numberViewSize * numberViewCount) + (margin * 2)
    }
    
    var button:AnimatedButton?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        addSlider()
        gradientViewInit()
        
    }
    
    /**
     Here we're adding the slider.
     When creating the slider, I'm passing in the total number of numberviews I want the slider to handle.
     I also tell it what size each numberview should be. Finally I pass in the margin that should surround the contents of the slider.
     */
    
    func addSlider() {
        
        let slider = Slider(numberViewCount: numberViewCount, numberViewSize: numberViewSize, margin: margin)
        
        view.addSubview(slider)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: slider,
                                                      attribute: NSLayoutAttribute.centerX,
                                                      relatedBy: NSLayoutRelation.equal,
                                                      toItem: view,
                                                      attribute: NSLayoutAttribute.centerX,
                                                      multiplier: 1,
                                                      constant: 0)
        
        let verticalConstraint = NSLayoutConstraint(item: slider,
                                                    attribute: NSLayoutAttribute.centerY,
                                                    relatedBy: NSLayoutRelation.equal,
                                                    toItem: view,
                                                    attribute: NSLayoutAttribute.centerY,
                                                    multiplier: 1,
                                                    constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: slider,
                                                 attribute: NSLayoutAttribute.width,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.notAnAttribute,
                                                 multiplier: 1,
                                                 constant: CGFloat(sliderWidth))
        
        let heightConstraint = NSLayoutConstraint(item: slider,
                                                  attribute: NSLayoutAttribute.height,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutAttribute.notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 50)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    /**
     This function initializes the gradient view, and places it on the screen.
     I've chosen to hardcode the hex values, but these could just as easily have been placed in a plist or constants file.
     */
    
    func gradientViewInit() {
        
        let gradientView = GradientView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        let colorStart = UIColor(hexString: "#753F4F")
        let colorEnd = UIColor(hexString: "#221E33")
        
        gradientView.colors = [colorStart, colorEnd]
        
        view.addSubview(gradientView)
        view.sendSubview(toBack: gradientView)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: gradientView,
                                                      attribute: NSLayoutAttribute.centerX,
                                                      relatedBy: NSLayoutRelation.equal,
                                                      toItem: view,
                                                      attribute: NSLayoutAttribute.centerX,
                                                      multiplier: 1,
                                                      constant: 0)
        
        let verticalConstraint = NSLayoutConstraint(item: gradientView,
                                                    attribute: NSLayoutAttribute.centerY,
                                                    relatedBy: NSLayoutRelation.equal,
                                                    toItem: view,
                                                    attribute: NSLayoutAttribute.centerY,
                                                    multiplier: 1,
                                                    constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: gradientView,
                                                 attribute: NSLayoutAttribute.width,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: view,
                                                 attribute: NSLayoutAttribute.width,
                                                 multiplier: 1,
                                                 constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: gradientView,
                                                  attribute: NSLayoutAttribute.height,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: view,
                                                  attribute: NSLayoutAttribute.height,
                                                  multiplier: 1,
                                                  constant: 0)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }

}
