//
//  PMTableViewDelegate.swift
//  PMLefe
//
//  Created by wsy on 16/4/17.
//  Copyright © 2016年 WSY. All rights reserved.
//

import Foundation
import UIKit

// Text
protocol PMTextDelegate{
    var text: String { get set }
    var textFont: UIFont { get set }
    var textColor: UIColor { get set }
}

extension PMTextDelegate{
    var textFont: UIFont {
        return PMUIContraint.kFont
    }
    var textColor: UIColor {
        return .blackColor()
    }
}

// Image
protocol PMImageDelegate{
    var imageName: String { get set }
    var imageWidth: CGFloat { get set }
    var imageHeight: CGFloat { get set }

}

extension PMImageDelegate{
    var imageWidth: CGFloat {
        return 24
    }
    
    var imageHeight: CGFloat {
        return 24
    }
}

// Text image
protocol PMTextImageDelegate: PMTextDelegate, PMImageDelegate{
    
}


// TableViewDelegate
extension UITableViewDelegate{
    
}

protocol PMTableViewDataSource: UITableViewDataSource{
    var rowDataSource: Array<AnyObject> { get set }
    var sectionDataSource: Array<Array<AnyObject>> { get set }
}


