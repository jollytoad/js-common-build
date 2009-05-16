
MIN_DIR ?= ${DIST_DIR}/min

MINIFY = java -jar ${BUILD_DIR}/yuicompressor-2.4.2.jar

MIN_FILES = $(notdir ${CONCAT}) ${OPTIONAL_MODULES}
MIN_OUT = $(addprefix ${MIN_DIR}/,$(patsubst %.js,%.min.js,${MIN_FILES}))

minify: ${MIN_OUT}

${MIN_DIR}:
	@@echo "Creating minify directory:" ${MIN_DIR}
	@@mkdir -p ${MIN_DIR}

${MIN_OUT}: concat opts ${MIN_DIR}
	@@echo "Minifying" $@
	@@${MINIFY} -o $@ $(addprefix ${DIST_DIR}/,$(notdir $(patsubst %.min.js,%.js,$@)))

