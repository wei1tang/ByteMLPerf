#!/bin/bash

SHELL_FOLDER=$(cd "$(dirname "$0")"; pwd)
cd $SHELL_FOLDER/..

echo "******************* Downloading Model and Logits....  *******************"

mkdir -p llm_perf/download

SOTA_MODEL_CKPT="llm_perf/model_zoo/sota"
GPU_REPORT_BASELINE="llm_perf/reports/base"

mkdir -p $SOTA_MODEL_CKPT
mkdir -p $GPU_REPORT_BASELINE

MODEL=$1
ENABLE_ACC=$2

# supported model:
#   * chatglm2-torch-fp16-6b
#   * chinese-llama2-torch-fp16-13b
#   * mixtral-torch-fp16-8x7b
if  [ $MODEL == "chatglm2-torch-fp16-6b" ] || 
    [ $MODEL == "chinese-llama2-torch-fp16-13b" ] || 
    [ $MODEL == "mixtral-torch-fp16-8x7b" ]; then
    if [ -d "$SOTA_MODEL_CKPT/$MODEL" ]; then
        echo "already exist model, skip download"
    else
        wget -O llm_perf/download/$MODEL.tar.gz https://lf-bytemlperf.17mh.cn/obj/bytemlperf-zoo/llm/$MODEL.tar.gz
        tar xf llm_perf/download/$MODEL.tar.gz -C $SOTA_MODEL_CKPT
    fi
    if [ $ENABLE_ACC == "True" ]; then
        if [ -d "$GPU_REPORT_BASELINE/$MODEL" ]; then
            echo "already exist logits, skip download"
        else
            wget -O llm_perf/download/reports_gpu_$MODEL.tar.gz https://lf-bytemlperf.17mh.cn/obj/bytemlperf-zoo/llm/reports_gpu_$MODEL.tar.gz
            tar xf llm_perf/download/reports_gpu_$MODEL.tar.gz -C $GPU_REPORT_BASELINE
        fi
    fi
else
    echo "Unsupported model!"
    exit -1
fi

echo "Extract Done."
