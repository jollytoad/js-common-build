
JSLINT_DIR = ${BUILD_DIR}/jslint
JSLINT_JS = ${JSLINT_DIR}/jslint.js
JSLINT_SRC_JS = ${JSLINT_DIR}/fulljslint.js
JSLINT_RHINO_JS = ${JSLINT_DIR}/rhino.js

RHINO = rhino

jslint: ${JSLINT_JS} ${JS_ALL}
	@@echo "Checking JS files with JSLint"
	@@${RHINO} ${JSLINT_JS} ${JS_ALL}

${JSLINT_JS}:
	@@echo "Building JSLint"
	@@cat ${JSLINT_SRC_JS} ${JSLINT_RHINO_JS} > ${JSLINT_JS}

clean-jslint:
	@@echo "Removing JSLint"
	@@rm -f ${JSLINT_JS}

