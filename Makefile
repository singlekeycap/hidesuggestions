export TARGET := iphone:clang:latest:15.0
export ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HideSuggestions

HideSuggestions_FILES = HideSuggestions.xm
HideSuggestions_CFLAGS = -fobjc-arc
HideSuggestions_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += hidesuggestionsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk