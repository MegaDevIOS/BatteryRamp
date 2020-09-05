INSTALL_TARGET_PROCESSES = SpringBoard
export ARCHS = arm64 arm64e
export TARGET=iphone:clang:13.3:13.3
export GO_EASY_ON_ME = 1
export DEBUG = 0
export password = alpine
export THEOS_DEVICE_PORT=22
 export THEOS_DEVICE_IP=192.168.1.63
SUBPROJECTS += pref
SUBPROJECTS += deepsleep
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BatteryRamp

BatteryRamp_FILES = Tweak.xm BatRampMenu.m BatRampMenu12.m 


BatteryRamp_FRAMEWORKS += UIKit QuartzCore IOKit CoreFoundation
BatteryRamp_CODESIGN_FLAGS = -Sent.xml
BatteryRamp_EXTRA_FRAMEWORKS += Cephei
BatteryRamp_PRIVATE_FRAMEWORKS = MediaRemote
BatteryRamp_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk