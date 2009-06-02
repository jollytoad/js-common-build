
BUILD_DIR ?= build
SRC_DIR ?= src
DIST_DIR ?= dist
COMMENT ?= Build-@VERSION-@DATE
MODE_FILE ?= mode

CONCAT = ${DIST_DIR}/${PACKAGE}.js

JS_CAT = $(addprefix ${SRC_DIR}/,${MODULES})
JS_OPT = $(addprefix ${SRC_DIR}/,${OPTIONAL_MODULES})
JS_ALL = ${JS_CAT} ${JS_OPT}

VERSION ?= `cat version.txt`
TODAY ?= `date +%Y%m%d`
SUB = sed "s/@VERSION/${VERSION}/g; s/@DATE/${TODAY}/g"

# Todo: set MODE_GREP to cat if MODE_FILE doesn't exist
MODE_GREP = grep -Fvf ${MODE_FILE}
MODES = `cat ${MODE_FILE}`

all: jslint build minify
	@@echo ${PACKAGE} "build complete."

build: concat opts extras

include ${BUILD_DIR}/jslint.mk
include ${BUILD_DIR}/minify.mk

concat: ${CONCAT}

ifdef OPTIONAL_MODULES
opts: ${DIST_DIR} ${MODE_FILE} ${JS_OPT}
	@@echo "Copying optional modules"
	@@echo "Build modes:" ${MODES}
	@@for f in ${OPTIONAL_MODULES} ; do \
		cat ${SRC_DIR}/$$f | ${MODE_GREP} | ${SUB} > ${DIST_DIR}/$$f ; done
else
opts:
endif

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

${CONCAT}: ${DIST_DIR} ${MODE_FILE} ${JS_CAT}
	@@echo "Building" ${CONCAT}
	@@echo "Build modes:" ${MODES}
	@@echo "/*! ${COMMENT}: ${MODULES} */" | cat - ${JS_CAT} | ${MODE_GREP} | ${SUB} > ${CONCAT}

${MODE_FILE}:
	@@touch ${MODE_FILE}

clean:
	@@echo "Removing distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

