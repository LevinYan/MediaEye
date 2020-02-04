//
//  ParamView.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/24.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Cocoa

class ParamView: NSView {
    
    let pixFormt = ["AV_PIX_FMT_NONE",
                   "AV_PIX_FMT_YUV420P",
                   "AV_PIX_FMT_YUYV422",
                   "AV_PIX_FMT_RGB24",
                   "AV_PIX_FMT_BGR24",
                   "AV_PIX_FMT_YUV422P",
                   "AV_PIX_FMT_YUV444P",
                   "AV_PIX_FMT_YUV410P",
                   "AV_PIX_FMT_YUV411P",
                   "AV_PIX_FMT_GRAY8",
                   "AV_PIX_FMT_MONOWHITE",
                   "AV_PIX_FMT_MONOBLACK",
                   "AV_PIX_FMT_PAL8",
                   "AV_PIX_FMT_YUVJ420P",
                   "AV_PIX_FMT_YUVJ422P",
                   "AV_PIX_FMT_YUVJ444P",
                   "AV_PIX_FMT_UYVY422"]
    let codecString = [AV_CODEC_ID_H264.rawValue: ".H264",
                       AV_CODEC_ID_HEVC.rawValue: ".H265",
                       AV_CODEC_ID_AAC.rawValue: "AAC"]
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
    @IBOutlet weak var duration: NSTextField!

    func update(mediaParam: MediaParam) {
        
        format.stringValue = "\(String(cString:mediaParam.format))"
        duration.stringValue = " \( Double(mediaParam.duration) / 1000.0)秒"
        size.stringValue = "\(mediaParam.videoParam.width)*\(mediaParam.videoParam.height)"
        frameRate.stringValue = "\(mediaParam.videoParam.fps)fps"
        sampleRate.stringValue = "\(mediaParam.audioParam.sampleRate)HZ"
        audioDuration.stringValue = "\(mediaParam.audioParam.duration)"
        channel.stringValue = "\(mediaParam.audioParam.channels)"
        pixel.stringValue = "\(pixFormt[Int(mediaParam.videoParam.pixFormt.rawValue + 1)])"
        videoEncode.stringValue = codecString[mediaParam.videoParam.codeId.rawValue] ?? ""
        audioEncode.stringValue = codecString[mediaParam.audioParam.codeId.rawValue] ?? ""
        bitrate.stringValue = "\(mediaParam.bitRate)kb/s"
        metadata.stringValue = "\(String(cString:mediaParam.metaData))"
    }
   override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func awakeFromNib() {
        
    format.stringValue = ""
    duration.stringValue = ""
    size.stringValue = ""
    frameRate.stringValue = ""
    sampleRate.stringValue = ""
    audioDuration.stringValue = ""
    channel.stringValue = ""
    pixel.stringValue = ""
    videoEncode.stringValue = ""
    audioEncode.stringValue = ""
    bitrate.stringValue = ""
    metadata.stringValue = ""
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
