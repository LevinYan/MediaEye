//
//  ParamView.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/24.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Cocoa

class ParamView: NSView {
    
    @IBOutlet weak var videoDuration: NSTextField!
    @IBOutlet weak var format: NSTextField!
    @IBOutlet weak var bitrate: NSTextField!
    @IBOutlet weak var metadata: NSTextField!
    @IBOutlet weak var pixel: NSTextField!
    @IBOutlet weak var videoEncode: NSTextField!
    @IBOutlet weak var frameRate: NSTextField!
    @IBOutlet weak var size: NSTextField!
    @IBOutlet weak var sampleRate: NSTextField!
    @IBOutlet weak var audioEncode: NSTextField!
    @IBOutlet weak var audioDuration: NSTextField!
    @IBOutlet weak var channel: NSTextField!

    func update(format: AVFormatContext, videoStream: AVStream, audioStream: AVStream) {
        
        videoDuration.stringValue = " \( videoStream.duration / 1000)"
        size.stringValue = "\(videoStream.codecpar.pointee.width)*\(videoStream.codecpar.pointee.height)"
        sampleRate.stringValue = "\(audioStream.codecpar.pointee.sample_rate)"
        audioDuration.stringValue = "\(audioStream.duration)"
        channel.stringValue = "\(audioStream.codecpar.pointee.channels)"
    }
   override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func awakeFromNib() {
        
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
