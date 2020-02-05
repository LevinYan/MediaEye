//
//  ffplay.h
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/11/28.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

#ifndef ffplay_h
#define ffplay_h
#include <inttypes.h>
#import "avformat.h"

typedef enum FFP_State {
    FFP_State_Idl = 0,
    FFP_State_Play,
    FFP_State_Pause

} FFP_State;
    
typedef enum FFP_Event{
    
    FFP_Event_State = 0,
    FFP_Event_OpenStream,
    FFP_Event_PushPacket,
    FFP_Event_PushVideoFrame,
    FFP_Event_PushAudioFrame,
    FFP_Event_RenderFrame,
    FFP_Event_Complete,
    
}FFP_Event;
    
typedef void (*notifyFunc)(FFP_Event event, void *msg);
int FFP_play(const char *url);
void FFP_pause(void);
void FFP_stop(void);
void FFP_seek(int ms);
void FFP_destory();
void FFP_eventNotify(notifyFunc func);
int64_t FFP_duration(void);
float FFP_progress(void);
void FFP_eventLoop(void);
AVFormatContext getFormatContext(void);
AVStream getVideoStream(void);
AVStream getAudioStream(void);
void FFP_open(const char *url);
#endif /* ffplay_h */
