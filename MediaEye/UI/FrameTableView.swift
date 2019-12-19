//
//  FrameTableView.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/18.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Cocoa

class FrameTableView: NSTableView, NSTableViewDataSource {

    var frames = [AVFrame]()
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        let colom1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "colum1"))
        colom1.title = "帧数"
        colom1.width = 100
        addTableColumn(colom1)
        
        let colom2 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "colum2"))
        colom2.title = "类型"
        colom2.width = 100
        addTableColumn(colom2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return frames.count
    }
}
