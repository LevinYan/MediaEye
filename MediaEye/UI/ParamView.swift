//
//  ParamView.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/24.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Cocoa

class ParamView: NSTextView {
    
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


    func update(mediaParam: MediaParam) {
        
        let fmtParam =    "封装\n"
                        + "封装格式:\(String(cString:mediaParam.format))\n"
                        + "时长：\( Double(mediaParam.duration) / 1000.0)秒\n"
                        + "比特率: \(mediaParam.bitRate)kb/s\n"
                        + "metedata: \(String(cString:mediaParam.metaData))\n"
                        + "\n"
        
        let videoParam =  "视频\n"
                        +   "像素：\(pixFormt[Int(mediaParam.videoParam.pixFormt.rawValue + 1)])\n"
                        + "编码：\(codecString[mediaParam.videoParam.codeId.rawValue] ?? "")\n"
                        + "帧率：\(mediaParam.videoParam.fps)fps\n"
                        + "宽高: \(mediaParam.videoParam.width)*\(mediaParam.videoParam.height)\n"
                        + "metedata: \(String(cString:mediaParam.videoParam.metadata))\n"
                        + "\n"

        let audioParam = "音频\n"
                        + "采样率：\(mediaParam.audioParam.sampleRate)HZ\n"
                        + "编码： \(codecString[mediaParam.audioParam.codeId.rawValue] ?? "")\n"
                        + "时长： \(mediaParam.audioParam.duration)\n"
                        + "声道：\(mediaParam.audioParam.channels)\n"
                        + "metedata: \(String(cString:mediaParam.audioParam.metadata))\n"
                        + "\n"


        string = (  fmtParam  + videoParam + audioParam)
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
