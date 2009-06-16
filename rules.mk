
BUILD_DIR ?= build
SRC_DIR ?= src
DIST_DIR ?= dist
COMMENT ?= Build-@VERSION-@DATE
MODE_FILE ?= mode

VERSION ?= `cat version.txt`
TODAY ?= `date +%Y%m%d`
SUB = sed "s/@VERSION/${VERSION}/g; s/@DATE/${TODAY}/g"

# Todo: set MODE_GREP to cat if MODE_FILE doesn't exist
MODE_GREP = grep -Fvf ${MODE_FILE}
MODES = `cat ${MODE_FILE}`

all: jslint build minify
	@@echo ${PACKAGE} "build complete."

build: js optjs extras css optcss

include ${BUILD_DIR}/js.mk
include ${BUILD_DIR}/css.mk
include ${BUILD_DIR}/jslint.mk
include ${BUILD_DIR}/minify.mk

ifdef EXTRAS
extras: ${EXTRAS} ${DIST_DIR}
	@@echo "Copying extra files"
	@@cp -a ${EXTRAS} ${DIST_DIR}
else
extras:
endif

${DIST_DIR}:
	@@echo "Creating distribution directory:" ${DIST_DIR}
	@@mkdir -p ${DIST_DIR}

${MODE_FILE}:
	@@touch ${MODE_FILE}

clean:
	@@echo "Removing distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

