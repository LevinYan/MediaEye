//
//  ViewUtil.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/18.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Foundation
import AppKit

extension NSView {
    
    var width: CGFloat {
        
        get {
            return bounds.size.width
        }
    }
    var height: CGFloat {
        
        get {
            return bounds.size.height
        }
    }
    var top: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
    }
    var x: CGFloat {
       get {
           return frame.origin.x
       }
    }
    var y: CGFloat {
        get {
            return frame.origin.y
        }
    }
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
    }
}
