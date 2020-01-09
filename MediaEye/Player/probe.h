//
//  probe.h
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/31.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

#ifndef probe_h
#define probe_h
#include "libavutil/avutil.h"
#include "libavcodec/avcodec.h"
#include <stdio.h>
typedef struct {
    
    int width;
    int height;
    int64_t duration;
    enum AVPixelFormat pixFormt;
    enum AVCodecID codeId;
}VideoParam;

typedef struct {
    
    int channels;
    int sampleRate;
    int64_t duration;
    enum AVCodecID codeId;


}AudioParam;

typedef struct {
    
    char* format;
    int duration;
    int64_t bitRate;
    VideoParam videoParam;
    AudioParam audioParam;
}MediaParam;

int FFP_probe(const char* filename, MediaParam *mediaParam);

#endif /* probe_h */
