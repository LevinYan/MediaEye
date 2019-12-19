//
//  StoryboardUtil.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/18.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Foundation

extension NSStoryboard {
    
    
    class func loadViewController(_ name: String) -> NSViewController? {
        
        let vc = NSStoryboard.main?.instantiateController(withIdentifier: name) as? NSViewController
        return vc
    }
}
