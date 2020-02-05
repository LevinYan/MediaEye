//
//  PlayerManager.swift
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/11.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

import Cocoa

fileprivate var player: Player?


class Player {

    enum Event {
        case state, progress
    }
    enum State {
        case idle, play, pause, complete
    }
    static let VideoFrameNotification = "VideoFrameNotification"
    static let PacketNotification = "PacketNotification"
    var progress: Float = 0 {
        didSet {
            sendEventNotify(.progress)
        }
    }
    var videoStream: AVStream?
    var audioStream: AVStream?
    var fmtContext: AVFormatContext?
    var state: State = .idle {
        didSet{
            if state != oldValue {
                sendEventNotify(.state)
            }
        }
    }
    var eventNotify : ((Event)->Void)
    var packets = [AVPacket]()
    var videoFrames = [AVFrame]()
    var audioFrames = [AVFrame]()
    var mediaParam: MediaParam?
    
    init(eventNotify: @escaping ((Event)->Void)) {

        self.eventNotify = eventNotify
        player = self
        registerEventHandler()
    }
    private func sendEventNotify(_ event: Event) {
        DispatchQueue.main.async {
            self.eventNotify(event)
        }
    }
    func play(url: String) {

        if state == .idle {
            innerPlay(url)
        } else {
            FFP_destory();
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (_) in
                self.innerPlay(url)
            }
        }

    }
    func innerPlay(_ url: String) {
       
        FFP_play(url)
        fmtContext = getFormatContext()
        videoStream = getVideoStream()
        audioStream = getAudioStream()
        state = .play
    }
    func pause() {
        FFP_pause()
    }
    func replay() {
        FFP_seek(0)
    }
    
    func probe(url: String){
        
        var mediaParam = MediaParam()
        if FFP_probe(url, &mediaParam) == 0 {
            self.mediaParam = mediaParam;
        }
        
    }
   fileprivate func handleEvent(_ event: FFP_Event, data: UnsafeMutableRawPointer?) {
          
    switch event {
    case FFP_Event_PushPacket:
        
        if let packet = data?.load(as: AVPacket.self) {
            packets.append(packet)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Player.PacketNotification), object: self, userInfo: ["packet": packet])
        }
        
    case FFP_Event_PushVideoFrame:
        
        if let frame = data?.load(as: AVFrame.self) {
            
            if frame.width > 0, frame.height > 0 {
                videoFrames.append(frame)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Player.VideoFrameNotification), object: self, userInfo: ["frame": frame])

            } else if frame.nb_samples > 0 {
                audioFrames.append(frame)
            }

        }
    case FFP_Event_RenderFrame:
        self.progress = FFP_progress()
        
    case FFP_Event_OpenStream:
        let opaquePtr = OpaquePointer(data)
 
    case FFP_Event_Complete:
        state = .complete
        
    default:
        print("")
        
    }
   }
}
private func registerEventHandler() {
    
    FFP_eventNotify {(event, data) in
               
        player?.handleEvent(event, data: data)
    }
}
