include $(THEOS)/makefiles/common.mk

TOOL_NAME = librampdeepsleep

librampdeepsleep_FILES = main.m
librampdeepsleep_FRAMEWORKS +=  IOKit CoreFoundation
librampdeepsleep_CFLAGS = -fobjc-arc
librampdeepsleep_CODESIGN_FLAGS = -Sent.xml

include $(THEOS_MAKE_PATH)/tool.mk
