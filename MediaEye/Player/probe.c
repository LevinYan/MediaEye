//
//  probe.c
//  MediaEye
//
//  Created by levinyang(杨亦伟) on 2019/12/31.
//  Copyright © 2019 levinyang(杨亦伟). All rights reserved.
//

#include "probe.h"
#include "libavformat/avformat.h"
#include "libavutil/dict.h"

static void print_error(const char *filename, int err)
{
    if (err == AVERROR_EOF) {
        // end of file; do not need print
        return;
    }
    char errbuf[128];
    const char *errbuf_ptr = errbuf;

    if (av_strerror(err, errbuf, sizeof(errbuf)) < 0)
        errbuf_ptr = strerror(AVUNERROR(err));
    av_log(NULL, AV_LOG_ERROR, "print_error %s:error_code:%d, %s\n", filename,err, errbuf_ptr);
}

void probe(const char* filename)
{
    AVFormatContext *fmt_ctx = NULL;
    AVDictionaryEntry *t = NULL;
    int scan_all_pmts_set = 0;

    fmt_ctx = avformat_alloc_context();
    AVInputFormat *iformat = NULL;

    int err;
    if ((err = avformat_open_input(&fmt_ctx, filename,
                                   iformat, NULL)) < 0) {
         print_error(filename, err);
         return ;
    }
    for (int i = 0; i < fmt_ctx->nb_streams; i++) {
           AVStream *stream = fmt_ctx->streams[i];
           AVCodec *codec;

           codec = avcodec_find_decoder(stream->codecpar->codec_id);
           if (!codec) {
               av_log(NULL, AV_LOG_WARNING,
                       "Unsupported codec with id %d for input stream %d\n",
                       stream->codecpar->codec_id, stream->index);
               continue;
           }
        
            AVCodecContext *codecContext = avcodec_alloc_context3(codec);
          
            err = avcodec_parameters_to_context(codecContext, stream->codecpar);
            if (err < 0)
             exit(1);
            if (avcodec_open2(codecContext, codec, NULL) < 0) {
              av_log(NULL, AV_LOG_WARNING, "Could not open codec for input stream %d\n",
                     stream->index);
              exit(1);
            }

    }
}

