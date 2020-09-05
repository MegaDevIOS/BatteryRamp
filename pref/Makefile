include $(THEOS)/makefiles/common.mk


ARCHS = arm64 arm64e



BUNDLE_NAME = BatteryRampPref
BatteryRampPref_FILES = RampRootListController.m HBAppearanceSettings.m
BatteryRampPref_INSTALL_PATH = /Library/PreferenceBundles
BatteryRampPref_FRAMEWORKS = UIKit
BatteryRampPref_CODESIGN_FLAGS = -Sentitlements.xml
BatteryRampPref_PRIVATE_FRAMEWORKS = Preferences
BatteryRampPref_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BatteryRampPref.plist$(ECHO_END)
