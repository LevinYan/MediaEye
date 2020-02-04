//
//  FramesViewController.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/18.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Cocoa

class FramesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    var frames = [AVFrame]()
    var player: Player?
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
        NotificationCenter.default.addObserver(self, selector: #selector(getFrame(notification:)), name: NSNotification.Name(Player.VideoFrameNotification), object: nil)

    }
    @objc
    func getFrame(notification: Notification) {
        
        if let frame = notification.userInfo?["frame"] as? AVFrame {
            
            frames.append(frame)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @objc
    func getPacket(notification: Notification) {
        
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return frames.count
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellIdentify = ["FrameNum", "FrameType", "DTS", "PTS"]
        let colum = tableView.tableColumns.firstIndex(of: tableColumn!)!
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentify[colum]), owner: nil) as? NSTableCellView {
            
            cell.wantsLayer = true
            let index = frames.count - 1 - row
            let frame = frames[index]
            let isKey = frame.pict_type == AV_PICTURE_TYPE_I
            switch colum {
            case 0:
                cell.textField?.stringValue = "\(index)"
            case 1:
                let types = ["unknow","I","P","B","S","SI","SP","BI"]
                cell.textField?.stringValue = types[Int(frame.pict_type.rawValue)]
            case 2:
                let dts = frame.coded_picture_number
                cell.textField?.stringValue = "\(dts)"

            case 3:
                if let timebase = player?.videoStream?.time_base {
                    let pts = Double(frame.pts)*av_q2d(timebase)
                    cell.textField?.stringValue = "\(String(format: "%.2f", pts))"
                }

            default: break
                
            }
            
            cell.textField?.alignment = .center
            cell.layer?.backgroundColor = isKey ? NSColor.red.cgColor : NSColor.white.cgColor
        return cell
        }
        return nil
    }

    
}
