//
//  ViewController.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/11/27.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var fileUrl: NSTextField!
    @IBOutlet weak var playButton: NSButton!
    @IBOutlet weak var progress: NSProgressIndicator!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func openFile(_ sender: Any) {
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {
                self.fileUrl.stringValue = openPanel.url?.absoluteString ?? ""
            }
        }
    }
    
    @IBAction func play(_ sender: Any) {
        
        let fileUrl = Bundle.main.path(forResource: "test", ofType: "flv")
        FFP_play(fileUrl?.toUnsafePointer())

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (_) in
            self.updateProgress()
            FFP_eventLoop()

        }
        print("timer")
    }
    func updateProgress() {
        
        progress.doubleValue = Double(FFP_progress()*100);
    }
}

extension String {
    func toUnsafePointer() -> UnsafeMutablePointer<UInt8>? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
        let stream = OutputStream(toBuffer: buffer, capacity: data.count)
        stream.open()
        let value = data.withUnsafeBytes {
            $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
        }
        guard let val = value else {
            return nil
        }
        stream.write(val, maxLength: data.count)
        stream.close()

        return UnsafeMutablePointer<UInt8>(buffer)
    }

    func toUnsafeMutablePointer() -> UnsafeMutablePointer<Int8>? {
        return strdup(self)
    }
}
