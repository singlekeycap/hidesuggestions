export TARGET := iphone:clang:latest:14.0
export ARCHS = arm64 arm64e
export THEOS_SDK_DIR = $(THEOS)/sdks/iPhoneOS14.5.sdk
INSTALL_TARGET_PROCESSES = Spotlight

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HideSuggestions

HideSuggestions_FILES = HideSuggestions.xm
HideSuggestions_CFLAGS = -fobjc-arc
HideSuggestions_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += hidesuggestionsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk