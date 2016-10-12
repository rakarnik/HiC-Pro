## HiC-Pro
## Copyleft 2015,2016 Institut Curie
## Author(s): Nicolas Servant
## Contact: nicolas.servant@curie.fr
## This software is distributed without any guarantee under the terms of the GNU General
## Public License, either Version 2, June 1991 or Version 3, June 2007. 

## DO NOT EDIT THE REST OF THIS FILE!!

MK_PATH = $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

SCRIPTS=$(MK_PATH)/scripts
SOURCES=$(SCRIPTS)/src
CONFIGURE_OUT=$(wildcard ./config-system.txt)
CONFIG_SYS=$(wildcard ./config-install.txt)


install : config_check mapbuilder readstrimming iced cp

######################################
## Config file
##
######################################
config_check:
ifneq ("$(CONFIGURE_OUT)","")
include $(CONFIGURE_OUT)
else
	$(error config-system.txt file not found. Please run 'make configure' first)
endif

######################################
## Configure
##
######################################
configure:
ifneq ("$(CONFIG_SYS)","")
	make -f ./scripts/install/Makefile CONFIG_SYS=$(CONFIG_SYS)
else
	$(error config-install.txt file not found !)
endif

######################################
## Compile
##
######################################

## Build C++ code
mapbuilder: $(SOURCES)/build_matrix.cpp
	(g++ -Wall -O2 -std=c++0x -o build_matrix ${SOURCES}/build_matrix.cpp; mv build_matrix ${SCRIPTS})

readstrimming: $(SOURCES)/cutsite_trimming.cpp
	(g++ -Wall -O2 -std=c++0x -o cutsite_trimming ${SOURCES}/cutsite_trimming.cpp; mv cutsite_trimming ${SCRIPTS})

## Build Python lib
iced: $(SOURCES)/ice_mod
	(cp $(SOURCES)/ice_mod/iced/scripts/ice ${SCRIPTS}; cd $(SOURCES)/ice_mod/; ${PYTHON_PATH}/python setup.py install --user;)

test: config_check
	@echo ${PYTHON_PATH}

######################################
## Create installed version
##
######################################

cp:
ifneq ($(realpath $(MK_PATH)), $(realpath $(INSTALL_PATH)))
	cp -Ri $(MK_PATH) $(INSTALL_PATH)
endif
	@echo "HiC-Pro installed in $(realpath $(INSTALL_PATH)) !"

