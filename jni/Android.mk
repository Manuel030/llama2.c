LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := llama2
LOCAL_SRC_FILES := ../run.c
include $(BUILD_EXECUTABLE)