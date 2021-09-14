# Build system
BUILD_BROKEN_DUP_RULES := true

# Camera
ifeq ($(TARGET_SHIP_GCAM_GO),true)
PRODUCT_PACKAGES += \
    CameraGo
else
PRODUCT_PACKAGES += \
    OpenCamera
endif

# Charger
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/extra/charger,$(TARGET_COPY_OUT_PRODUCT)/etc/res)

# Debugging
ifeq ($(WITH_DEBUGGING), true)
PRODUCT_PACKAGES += \
    adbowifi \
    debugging.rc \
    magiskpolicy \
    vintf

PRODUCT_PRODUCT_PROPERTIES += \
    ro.adb.secure=0 \
    persist.sys.usb.config=adb \
    service.adb.root=1
endif
PRODUCT_PACKAGES += \
    iperf3

# Default ADB shell prompt
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.adb.shell=/system/xbin/bash

# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Extra
PRODUCT_PACKAGES += \
    extra.rc

# Faceunlock
TARGET_FACE_UNLOCK_SUPPORTED ?= true
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    FaceUnlockService
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face_unlock_service.enabled=$(TARGET_FACE_UNLOCK_SUPPORTED)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# Fonts
PRODUCT_COPY_FILES += \
    vendor/extra/prebuilt/etc/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml \
    $(call find-copy-subdir-files,*,vendor/extra/prebuilt/fonts,$(TARGET_COPY_OUT_PRODUCT)/fonts)

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64 \

# Google Apps
ifeq ($(WITH_GMS), true)
$(call inherit-product, vendor/gapps/common/common-vendor.mk)
endif

# Overlays
PRODUCT_PACKAGE_OVERLAYS += \
	vendor/extra/overlay

PRODUCT_PACKAGES += \
    FontGoogleSansOverlay \
    FontOneplusSlateSource \
    FontSamsungOneSourceOverlay \
    FontInterOverlay \
    ThemePrimerBlueOverlay \
    IconShapeRoundedRect2Overlay \
    IconShapeRoundedOverlay

# Signing
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/certs/releasekey

# StichImage
PRODUCT_PACKAGES += \
    StitchImage

# SU
ifeq ($(WITH_SU), true)
PRODUCT_PACKAGES += \
    Superuser \
    phh-su
endif

# Updater
PRODUCT_PROPERTY_OVERRIDES += \
    lineage.updater.uri=https://raw.githubusercontent.com/SamarV-121/lineage_OTA/master/$(LINEAGE_BUILD).json 
    # lineage.updater.allow_downgrading=true
