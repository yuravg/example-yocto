# Make-file to download and manage main projects

MAKEFLAGS += --no-print-directory

BRANCH = zeus

META_ROOT ?=../

.PHONY: help
help:
	@echo ""
	@echo "Usage:  make [target(s)]"
	@echo "where target is any of:"
	@echo ""
	@echo "Download dependencies:"
	@echo "  dwn_poky - download Poky"
	@echo "  dwn_oe   - download meta OpenEmbedded"
	@echo "  dwn_rpi  - download meta Raspberry PI"
	@echo "  dwn_b96  - download meta 96boards"
	@echo "  download - download all"
	@echo ""
	@echo "Git repositories command:"
	@echo "  git_status   -- status"
	@echo "  git_checkout -- checkout branch: '$(BRANCH)', used by default"
	@echo "  git -- run command, which is set by CMD, example:"
	@echo "       make git CMD='branch --all'    -- list of bracnes"
	@echo "       make git CMD='checkout <Name>' -- checkot bracnes, etc."
	@echo ""

h: help
.DEFAULT_GOAL := help

LPOKY_DIR ?= poky
LOE_DIR ?= meta-openembedded
LRPI_DIR ?= meta-raspberrypi
B96_DIR ?= meta-96boards

# Git, http link source:
# https://www.openembedded.org/wiki/Mirrors
# http://git.yoctoproject.org/cgit/cgit.cgi/meta-raspberrypi
GIT_POKY ?= git clone -b $(BRANCH) https://git.yoctoproject.org/git/poky
GIT_OE   ?= git clone -b $(BRANCH) https://github.com/openembedded/meta-openembedded.git
GIT_RPI  ?= git clone -b $(BRANCH) https://git.yoctoproject.org/git/meta-raspberrypi
GIT_B96  ?= git clone -b $(BRANCH) https://github.com/96boards/meta-96boards.git

# GIT_POKY ?= git clone -b krogoth git://git.yoctoproject.org/poky
# GIT_OE   ?= git clone -b krogoth git://git.openembedded.org/meta-openembedded
# GIT_RPI  ?= git clone -b krogoth git://git.yoctoproject.org/meta-raspberrypi
# FIXME: add usage at work(fix setup proxy)
# git clone https://git.linaro.org/openembedded/meta-linaro.git

.PHONY: dwn_poky dwn_oe dwn_rpi dwn_b96 download layers all
dwn_poky:
	@-if [ ! -d "$(LPOKY_DIR)" ] ; then \
		echo "Download Poky";           \
		$(GIT_POKY);                    \
	  else                              \
		echo "Poky already downloaded"; \
	  fi

dwn_oe:
	@-if [ ! -d "$(LOE_DIR)" ] ; then           \
		echo "Download OpenEmbedded";           \
		$(GIT_OE);                              \
	  else                                      \
		echo "OpenEmbedded already downloaded"; \
	  fi

dwn_rpi:
	@-if [ ! -d "$(LRPI_DIR)" ] ; then          \
		echo "Download meta Raspberry PI";      \
		$(GIT_RPI);                             \
	  else                                      \
		echo "Raspberry PI already downloaded"; \
	  fi

dwn_b96:
	@-if [ ! -d "$(B96_DIR)" ] ; then           \
		echo "Download meta Raspberry PI";      \
		$(GIT_B96);                             \
	  else                                      \
		echo "Raspberry PI already downloaded"; \
	  fi

download:
	@make dwn_poky
	@make dwn_oe
	@make dwn_rpi
	@make dwn_b96

assert-command-present = $(if $(shell which $1),,$(error '$1' missing and needed for this build))

# NOTE: if appear error:
# bitbake/bin/bitbake-layers", line 93, in <module>
#     ret = main()
# see at:
# https://stackoverflow.com/questions/59127987/bitbake-layers-add-layer-meta-python-meta-raspberrypi-failed
#
# may be should change layers order.
#
layers:
	@-if [ ! $(call assert-command-present,bitbake) ] ; then            \
		echo "Add meta layers";                                         \
		cd "$(LBUID_DIR)" ;                                             \
		bitbake-layers add-layer ../meta-openembedded/meta-oe/;         \
		bitbake-layers add-layer ../meta-openembedded/meta-python/;     \
		bitbake-layers add-layer ../meta-openembedded/meta-networking/; \
		bitbake-layers add-layer ../meta-openembedded/meta-multimedia/; \
		bitbake-layers add-layer ../meta-raspberrypi/;                  \
		bitbake-layers add-layer $(META_ROOT)/meta-example-yocto/;      \
	  fi

.PHONY: git_status git_checkout git
git_status:
	git -C "$(LPOKY_DIR)" status
	git -C "$(LOE_DIR)" status
	git -C "$(LRPI_DIR)" status
	git -C "$(B96_DIR)" status

git_checkout:
	git -C "$(LPOKY_DIR)" checkout "$(BRANCH)"
	git -C "$(LOE_DIR)" checkout "$(BRANCH)"
	git -C "$(LRPI_DIR)" checkout "$(BRANCH)"
	git -C "$(B96_DIR)" checkout "$(BRANCH)"

git:
	git -C "$(LPOKY_DIR)" $(CMD)
	git -C "$(LOE_DIR)" $(CMD)
	git -C "$(LRPI_DIR)" $(CMD)
	git -C "$(B96_DIR)" $(CMD)

.PHONY: printvars
printvars:
	$(foreach V,$(sort $(.VARIABLES)),                           \
	 $(if                                                        \
	  $(filter-out environment% default automatic,$(origin $V)), \
	   $(info $V=$($V) ($(value $V)))))
	@true
