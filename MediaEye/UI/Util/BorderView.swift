//
//  BorderView.swift
//  MediaEye
//
//  Created by Mac on 2020/2/4.
//  Copyright © 2020 levinyang(杨亦伟). All rights reserved.
//

import Cocoa

class BorderView: NSView {

    override func awakeFromNib() {
        
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        layer?.borderWidth = 1
        layer?.borderColor = NSColor.gray.cgColor
    }
}
