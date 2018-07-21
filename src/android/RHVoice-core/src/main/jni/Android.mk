LOCAL_PATH := $(call my-dir)

MY_PACKAGE := RHVoice
MY_VERSION := 0.7.1
MY_DEFINES := -DPACKAGE=\"$(MY_PACKAGE)\" -DVERSION=\"$(MY_VERSION)\" -DDATA_PATH=\"\" -DCONFIG_PATH=\"\" -DENABLE_MAGE -DHTS_EMBEDDED -DHTS106_EMBEDDED -DMAX_VOLUME=MAX_MAX_VOLUME
MY_SRC_DIR := ../../../../..
MY_INCLUDE_DIR := $(MY_SRC_DIR)/include
MY_THIRD_PARTY_DIR := $(MY_SRC_DIR)/third-party
MY_SONIC_DIR := $(MY_THIRD_PARTY_DIR)/sonic
MY_HTS_ENGINE_DIR := $(MY_THIRD_PARTY_DIR)/hts_engine
MY_MAGE_DIR := $(MY_THIRD_PARTY_DIR)/mage
MY_UTF8_DIR := $(MY_THIRD_PARTY_DIR)/utf8
MY_RAPIDXML_DIR := $(MY_THIRD_PARTY_DIR)/rapidxml
MY_CORE_DIR := $(MY_SRC_DIR)/core

include $(CLEAR_VARS)
LOCAL_MODULE := sonic
LOCAL_SRC_FILES := $(MY_SONIC_DIR)/sonic.c
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/$(MY_SONIC_DIR)
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := hts_engine
LOCAL_C_INCLUDES := $(LOCAL_PATH)/$(MY_INCLUDE_DIR)
LOCAL_SRC_FILES := $(patsubst $(LOCAL_PATH)/%, %, $(wildcard $(LOCAL_PATH)/$(MY_HTS_ENGINE_DIR)/*.c))
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/$(MY_HTS_ENGINE_DIR)
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := mage
LOCAL_C_INCLUDES := $(LOCAL_PATH)/$(MY_INCLUDE_DIR) $(LOCAL_PATH)/$(MY_HTS_ENGINE_DIR)
LOCAL_CFLAGS := -DRHVOICE
LOCAL_SRC_FILES := $(patsubst $(LOCAL_PATH)/%, %, $(wildcard $(LOCAL_PATH)/$(MY_MAGE_DIR)/*.cpp))
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/$(MY_MAGE_DIR)
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := RHVoice_core
LOCAL_C_INCLUDES := $(LOCAL_PATH)/$(MY_INCLUDE_DIR) $(LOCAL_PATH)/$(MY_UTF8_DIR) $(LOCAL_PATH)/$(MY_RAPIDXML_DIR) $(LOCAL_PATH)/$(MY_SONIC_DIR) $(LOCAL_PATH)/$(MY_HTS_ENGINE_DIR) $(LOCAL_PATH)/$(MY_MAGE_DIR)
LOCAL_SRC_FILES := $(patsubst $(LOCAL_PATH)/%, %, $(filter-out $(LOCAL_PATH)/$(MY_CORE_DIR)/unidata.cpp, $(wildcard $(LOCAL_PATH)/$(MY_CORE_DIR)/*.cpp)))
LOCAL_CFLAGS := $(MY_DEFINES)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := RHVoice_jni
LOCAL_SRC_FILES := native.cpp
LOCAL_WHOLE_STATIC_LIBRARIES := RHVoice_core sonic mage hts_engine
include $(BUILD_SHARED_LIBRARY)
