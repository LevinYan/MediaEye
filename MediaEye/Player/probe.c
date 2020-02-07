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


static char *getMetadata(AVDictionary *metadata)
{
    AVDictionaryEntry *t = NULL;
    char *ret = "";
    
    while( (t = av_dict_get(metadata,"",t,AV_DICT_IGNORE_SUFFIX)) != NULL){
            
        char *old = ret;
        char *new = calloc(100, 1);
        ret = calloc(strlen(old) + 1 + strlen(t->key) + 1 + 1 +  strlen(t->value) + 1 + 1,sizeof(char));
        sprintf(new, "\n%s:\n%s\n", t->key, t->value);

        strcat(ret, old);
        strcat(ret, new);
    }
    return ret;
}
int FFP_probe(const char* filename, MediaParam *mediaParam)
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
         return -1;
    }
    mediaParam->format = malloc(strlen(fmt_ctx->iformat->long_name) + 1);
    strcpy(mediaParam->format, fmt_ctx->iformat->long_name);
    
    av_dump_format(fmt_ctx, 0, filename, 0);

    err = avformat_find_stream_info(fmt_ctx, NULL);
    mediaParam->metaData = getMetadata(fmt_ctx->metadata);

    mediaParam->bitRate = fmt_ctx->bit_rate/1024;
    mediaParam->duration = (int)fmt_ctx->duration/1000;
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

        if (stream->codecpar->codec_type ==  AVMEDIA_TYPE_VIDEO){
            
            mediaParam->videoParam.width = codecContext->width;
            mediaParam->videoParam.height = codecContext->height;
            mediaParam->videoParam.duration = stream->duration;
            mediaParam->videoParam.pixFormt = codecContext->pix_fmt;
            mediaParam->videoParam.codeId = stream->codecpar->codec_id;
            mediaParam->videoParam.fps = av_q2d(stream->avg_frame_rate);
            mediaParam->videoParam.metadata = getMetadata(stream->metadata);
            
        }else if (stream->codecpar->codec_type == AVMEDIA_TYPE_AUDIO) {
            mediaParam->audioParam.channels = codecContext->channels;
            mediaParam->audioParam.duration = stream->duration;
            mediaParam->audioParam.codeId = stream->codecpar->codec_id;
            mediaParam->audioParam.sampleRate = stream->codecpar->sample_rate;
            mediaParam->audioParam.metadata = getMetadata(stream->metadata);
        }

        if (err < 0)
         exit(1);
        if (avcodec_open2(codecContext, codec, NULL) < 0) {
          av_log(NULL, AV_LOG_WARNING, "Could not open codec for input stream %d\n",
                 stream->index);
          exit(1);
        }

    }
    
    return 0;
}

