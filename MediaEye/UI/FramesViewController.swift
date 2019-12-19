//
//  FramesViewController.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/18.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Cocoa

class FramesViewController: NSViewController, NSTableViewDataSource,NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    var frames = [AVFrame]()
    
//    var tableView: NSTableView!
    
    public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    
    public required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
 
    override func viewDidLayout() {
//        tableView.frame = view.bounds
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
//        return frames.count
        return 100
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        let cellIdentify = ["FrameNum", "FrameType", "PFrame", "DTS", "PTS"]
        let colum = tableView.tableColumns.firstIndex(of: tableColumn!)!
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentify[colum]), owner: nil) as? NSTableCellView {
      
          return cell
        }
        return nil
    }
    
    
}
