//
//  PMAutoLayout.swift
//  PMLefe
//
//  Created by wsy on 16/1/10.
//  Copyright © 2016年 WSY. All rights reserved.
//

import UIKit
import Foundation

extension UIView{
    
    // MARK: - init
    class func initForAutoLaout() -> UIView{
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    // MARK: - superView
    func pmautoPinEdgeToSuperViewEdge(attribute: NSLayoutAttribute, withInsert insert: CGFloat) -> NSLayoutConstraint{
        self.translatesAutoresizingMaskIntoConstraints = false
        
        assert(self.superview != nil, "View's superview must not be nil. \nView:\(self)")
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: attribute, multiplier: 1.0, constant: insert)
        self.superview?.addConstraint(constraint)
        return constraint
    }
    
    func pmautoPinEdgeToSuperViewEdgesWithInsets(insets: UIEdgeInsets) -> NSArray{
        let contraints = NSMutableArray()
        contraints.addObject(pmautoPinEdgeToSuperViewEdge(NSLayoutAttribute.Top, withInsert: insets.top))
        contraints.addObject(pmautoPinEdgeToSuperViewEdge(NSLayoutAttribute.Left, withInsert: insets.left))
        contraints.addObject(pmautoPinEdgeToSuperViewEdge(NSLayoutAttribute.Bottom, withInsert: insets.bottom))
        contraints.addObject(pmautoPinEdgeToSuperViewEdge(NSLayoutAttribute.Right, withInsert: insets.right))
        return contraints
    }
    
    func pmautoPinExcludeEdgeToSuperViewEdgesWithInsets(insets: UIEdgeInsets, excludeEdge attribute: NSLayoutAttribute) -> NSArray{
        let contraints = NSMutableArray()
        if attribute != .Top{
            contraints.addObject(pmautoPinEdgeToSuperViewEdge(NSLayoutAttribute.Top, withInsert: insets.top))
        }
        if attribute != .Left{
            contraints.addObject(pmautoPinEdgeToSuperViewEdge(NSLayoutAttribute.Left, withInsert: insets.left))

        }
        if attribute != .Bottom{
            contraints.addObject(pmautoPinEdgeToSuperViewEdge(NSLayoutAttribute.Bottom, withInsert: insets.bottom))
        }
        if attribute != .Right{
            contraints.addObject(pmautoPinEdgeToSuperViewEdge(NSLayoutAttribute.Right, withInsert: insets.right))
        }
        return contraints
    }
    
    // MARK - size
    func pmautoSetSize(attribute: NSLayoutAttribute, withSize size: CGFloat) -> NSLayoutConstraint{
        self.translatesAutoresizingMaskIntoConstraints = false
        let contraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: size)
        self.addConstraint(contraint)
        return contraint
    }
    
    func pmautoSetSize(size: CGSize) -> NSArray{
        let contraints = NSMutableArray()
        contraints.addObject(pmautoSetSize(NSLayoutAttribute.Width, withSize: size.width))
        contraints.addObject(pmautoSetSize(NSLayoutAttribute.Height, withSize: size.height))
        return contraints
    }
}
