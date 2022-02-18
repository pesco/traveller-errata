TARGETS = lwb.html
CONVERT = convert.sh style.css

.PHONY: all clean
all: ${TARGETS}
clean:
	rm -f ${TARGETS}

${TARGETS}: ${CONVERT}

.SUFFIXES: .html .txt
.txt.html:
	./convert.sh "${<:R:U} Errata" < $< > $@
