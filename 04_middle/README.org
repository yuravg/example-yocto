Build Configuration:
BB_VERSION           = "1.42.0"
BUILD_SYS            = "x86_64-linux"
NATIVELSBSTRING      = "universal"
TARGET_SYS           = "aarch64-poky-linux"
MACHINE              = "raspberrypi3-64"
DISTRO               = "poky"
DISTRO_VERSION       = "2.7.3"
TUNE_FEATURES        = "aarch64 cortexa53 crc"
TARGET_FPU           = ""
meta
meta-poky
meta-yocto-bsp       = "HEAD:f475afc5df0837532dcd0f3a831ddc3aec8941f1"
meta-oe
meta-python
meta-networking
meta-multimedia      = "warrior:a24acf94d48d635eca668ea34598c6e5c857e3f8"
meta-raspberrypi     = "warrior:5551792e642d6cc32e22dfe6dbfd29ac3e2390cd"
meta-example-yocto   = "develop:897392bac18660274ff5a4c0279900d44302925a"
