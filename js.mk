
JS_CONCAT = ${DIST_DIR}/${PACKAGE}.js

JS_CAT = $(addprefix ${SRC_DIR}/,${MODULES})
JS_OPT = $(addprefix ${SRC_DIR}/,${OPTIONAL_MODULES})
JS_ALL = ${JS_CAT} ${JS_OPT}

js: ${JS_CONCAT}

ifdef OPTIONAL_MODULES
optjs: ${DIST_DIR} ${MODE_FILE} ${JS_OPT}
	@@echo "Copying optional modules"
	@@echo "Build modes:" ${MODES}
	@@for f in ${OPTIONAL_MODULES} ; do \
		cat ${SRC_DIR}/$$f | ${MODE_GREP} | ${SUB} > ${DIST_DIR}/$$f ; done
else
optjs:
endif

${JS_CONCAT}: ${DIST_DIR} ${MODE_FILE} ${JS_CAT}
	@@echo "Building" ${JS_CONCAT}
	@@echo "Build modes:" ${MODES}
	@@echo "/*! ${COMMENT}: ${MODULES} */" | cat - ${JS_CAT} | ${MODE_GREP} | ${SUB} > ${JS_CONCAT}

