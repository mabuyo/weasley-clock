    //
//  ClockHandView.swift
//  WeasleyClock
//
//  Created by Michelle Mabuyo on 2016-09-17.
//  Copyright © 2016 Michelle Mabuyo. All rights reserved.
//

import UIKit

@IBDesignable
class ClockHandView: UIView {
    
    var userColor = UIColor.init(red: 237, green: 237, blue: 237, alpha: 0)
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(ovalIn: rect)
        userColor.setFill()
        path.fill()
    }
    

}
