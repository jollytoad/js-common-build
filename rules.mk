
PREFIX = .
DOCS_DIR = ${PREFIX}/docs
TEST_DIR = ${PREFIX}/test
DIST_DIR = ${PREFIX}/dist

OUT = ${DIST_DIR}/${PACKAGE}.js
OUT_MIN = ${DIST_DIR}/${PACKAGE}.min.js

VERSION = `cat version.txt`
TODAY = `date +%Y%m%d`
SUB = sed "s/@VERSION/${VERSION}/g; s/@DATE/${TODAY}/g"

all: jslint concat minify
	@@echo ${PACKAGE} "build complete."

include ${BUILD_DIR}/jslint.mk
include ${BUILD_DIR}/minify.mk

concat: ${OUT}

minify: ${OUT_MIN}

${DIST_DIR}:
	@@echo "Creating Distribution directory:" ${DIST_DIR}
	@@mkdir -p ${DIST_DIR}

${OUT}: ${DIST_DIR} ${MODULES}
	@@echo "Building" ${OUT}
	@@cat ${MODULES} | ${SUB} > ${OUT}

${OUT_MIN}: ${DIST_DIR} ${OUT}
	@@echo "Minifying" ${OUT}
	@@${MINIFY} -o ${OUT_MIN} ${OUT}

clean:
	@@echo "Removing Distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

