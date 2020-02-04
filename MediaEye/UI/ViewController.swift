//
//  ViewController.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/11/27.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Cocoa
import AppKit

class ViewController: NSViewController {

    
    @IBOutlet weak var duration: NSTextFieldCell!
    @IBOutlet weak var progressTime: NSTextField!
    @IBOutlet weak var paramView: ParamView!
    @IBOutlet weak var fileUrl: NSTextField!
    @IBOutlet weak var playButton: NSButton!
    @IBOutlet weak var progress: NSProgressIndicator!
    var timer: Timer?
    var player: Player?
    var framesWindows: NSWindow?
    var framewsVc: FramesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.player = Player(eventNotify: { (event) in
            
            self.updateProgress()

        })
        playButton.isEnabled = false
        loadLastFileUrl()
       
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
                
                let fileUrl = openPanel.url?.absoluteString ?? ""
                self.probeFile(fileUrl)
                self.saveLastFileUrl(fileUrl)
            }
        }
    }
    private func probeFile(_ fileUrl: String)  {
        
        self.fileUrl.stringValue = fileUrl
        self.player?.probe(url: fileUrl)
        if let mediaParam = self.player?.mediaParam {
        self.paramView.update(mediaParam: mediaParam)
        }
        playButton.isEnabled = true
    }
    private func saveLastFileUrl(_ fileUrl: String) {
        
        UserDefaults.standard.set(fileUrl, forKey: "LastFileUrlKey")
    }
    private func loadLastFileUrl() {
        
        if let _fileUrl = UserDefaults.standard.string(forKey: "LastFileUrlKey") {
            fileUrl.stringValue = _fileUrl
            probeFile(_fileUrl)
        }
    }
    @IBAction func play(_ sender: Any) {
        
        let fileUrl = Bundle.main.path(forResource: "B", ofType: "MP4")
        player?.play(url: fileUrl!)
        if let _duration = player?.mediaParam?.duration {
            duration.stringValue = String(format: "%0.1f秒", Double(_duration)/1000.0)
        }

        framesWindows = NSWindow(contentRect: NSRect(x: self.view.window!.frame.origin.x + self.view.window!.frame.size.width + 100, y: self.view.window!.frame.origin.y, width: 400, height: 600), styleMask: [.borderless, .titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false)
        framewsVc = NSStoryboard.loadViewController("FramesViewController") as? FramesViewController
        framesWindows?.contentViewController = framewsVc
        framesWindows?.orderFront(nil)

        framewsVc?.player = player

    }
    func updateProgress() {
    
        progress.doubleValue = Double(self.player!.progress*100)
        progressTime.stringValue = String(format: "%0.1f秒", self.player!.progress * Float(self.player!.mediaParam!.duration)/1000.0)
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
