
ifndef BUILD_DIR
 BUILD_DIR = build
endif

ifndef SRC_DIR
 SRC_DIR = src
endif

ifndef DIST_DIR
 DIST_DIR = dist
endif

ifndef COMMENT
 COMMENT = Build-@VERSION-@DATE
endif

CONCAT = ${DIST_DIR}/${PACKAGE}.js

JS_CAT = $(addprefix ${SRC_DIR}/,${MODULES})
JS_OPT = $(addprefix ${SRC_DIR}/,${OPTIONAL_MODULES})
JS_ALL = ${JS_CAT} ${JS_OPT}

VERSION := `cat version.txt`
TODAY := `date +%Y%m%d`
SUB = sed "s/@VERSION/${VERSION}/g; s/@DATE/${TODAY}/g"

all: jslint concat opts extras minify
	@@echo ${PACKAGE} "build complete."

include ${BUILD_DIR}/jslint.mk
include ${BUILD_DIR}/minify.mk

concat: ${CONCAT}

ifdef OPTIONAL_MODULES
opts: ${JS_OPT} ${DIST_DIR}
	@@echo "Copying optional modules"
	@@for f in ${OPTIONAL_MODULES} ; do \
		cat ${SRC_DIR}/$$f | ${SUB} > ${DIST_DIR}/$$f ; done
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

${CONCAT}: ${DIST_DIR} ${JS_CAT}
	@@echo "Building" ${CONCAT}
	@@echo "/*! ${COMMENT}: ${MODULES} */" | cat - ${JS_CAT} | ${SUB} > ${CONCAT}

clean:
	@@echo "Removing distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

