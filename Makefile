DL_NAME := SeDuMi_1_3.zip
DL_PATH := http://sedumi.ie.lehigh.edu/wp-content/sedumi-downloads
UNZIP_DIR := SeDuMi_1_3

default_target: all

# Figure out where to build the software.
#   Use BUILD_PREFIX if it was passed in.
#   If not, search up to four parent directories for a 'build' directory.
#   Otherwise, use ./build.
ifeq "$(BUILD_PREFIX)" ""
BUILD_PREFIX:=$(shell for pfx in ./ .. ../.. ../../.. ../../../..; do d=`pwd`/$$pfx/build;\
               if [ -d $$d ]; then echo $$d; exit 0; fi; done; echo `pwd`/build)
endif
# create the build directory if needed, and normalize its path name
BUILD_PREFIX:=$(shell mkdir -p $(BUILD_PREFIX) && cd $(BUILD_PREFIX) && echo `pwd`)

# Default to a release build.  If you want to enable debugging flags, run
# "make BUILD_TYPE=Debug"
ifeq "$(BUILD_TYPE)" ""
BUILD_TYPE="Release"
endif

all: $(UNZIP_DIR) $(BUILD_PREFIX)/matlab/addpath_sedumi.m $(BUILD_PREFIX)/matlab/rmpath_sedumi.m

$(UNZIP_DIR):
	@echo "\nDownloading sedumi \n\n"
	wget --no-check-certificate $(DL_PATH)/$(DL_NAME)
	@echo "\nunzipping to $(UNZIP_DIR) \n\n"
	unzip $(DL_NAME) && rm $(DL_NAME)
	@echo "\nBUILD_PREFIX: $(BUILD_PREFIX)\n\n"

$(BUILD_PREFIX)/matlab/addpath_sedumi.m :
	@mkdir -p $(BUILD_PREFIX)/matlab
	echo "Writing $(BUILD_PREFIX)/matlab/addpath_sedumi.m"
	echo "function addpath_sedumi()\n\n \
	  root = fullfile('$(shell pwd)','$(UNZIP_DIR)');\n \
		addpath(fullfile(root));\n \
		end\n \
		\n" \
		> $(BUILD_PREFIX)/matlab/addpath_sedumi.m

$(BUILD_PREFIX)/matlab/rmpath_sedumi.m :
	@mkdir -p $(BUILD_PREFIX)/matlab
	echo "Writing $(BUILD_PREFIX)/matlab/rmpath_sedumi.m"
	echo "function rmpath_sedumi()\n\n \
		root = fullfile('$(shell pwd)','$(UNZIP_DIR)');\n \
		addpath(fullfile(root));\n \
		end\n \
		\n" \
		> $(BUILD_PREFIX)/matlab/rmpath_sedumi.m

clean:
	
	-if [ -e $(BUILD_PREFIX)/matlab/addpath_sedumi.m ]; then echo "Deleting $(BUILD_PREFIX)/matlab/addpath_sedumi.m" && rm $(BUILD_PREFIX)/matlab/addpath_sedumi.m; fi
	-if [ -e $(BUILD_PREFIX)/matlab/rmpath_sedumi.m ]; then echo "Deleting $(BUILD_PREFIX)/matlab/rmpath_sedumi.m" && rm $(BUILD_PREFIX)/matlab/rmpath_sedumi.m; fi
	-if [ -d $(UNZIP_DIR) ]; then echo "Deleting sedumi unzip directory" && rm -rf $(UNZIP_DIR); fi

# Default to a less-verbose build.  If you want all the gory compiler output,
# run "make VERBOSE=1"
$(VERBOSE).SILENT:
