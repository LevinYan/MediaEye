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

typedef enum FFP_State {
    FFP_State_Idl = 0,
    FFP_State_Play,
    FFP_State_Pause

} FFP_State;
    
typedef enum FFP_Event{
    
    FFP_Event_State = 0,
    
}FFP_Event;
    
typedef void (*notifyFunc)(FFP_Event event, void *msg);
int FFP_play(unsigned char *url);
void FFP_pause();
void FFP_stop();
void FFP_eventNotify(notifyFunc func);
int64_t FFP_duration();
float FFP_progress();
void FFP_eventLoop();
#endif /* ffplay_h */
