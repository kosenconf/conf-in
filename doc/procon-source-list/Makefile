TEX = platex -kanji=euc -output-directory=../build
DVIPDFMX = dvipdfmx -V 5
PDFNAME = 10034.pdf
FILE_NAME = srclist
TEX_FILE = $(FILE_NAME).tex
DVI_FILE = $(FILE_NAME).dvi
AUX_FILE = $(FILE_NAME).aux

.PHONY: all
all: pdf/$(PDFNAME)

.PHONY: dvi pdf
dvi: build/$(DVI_FILE)
pdf: pdf/$(PDFNAME)

build/$(DVI_FILE): src/$(TEX_FILE)
	cd src && $(TEX) $(TEX_FILE)
build/$(AUX_FILE): src/$(TEX_FILE)
	cd src && $(TEX) $(TEX_FILE)

pdf/$(PDFNAME): build/$(DVI_FILE)
	cd build && $(DVIPDFMX) -o ../pdf/$(PDFNAME) $(DVI_FILE)

.PHONY: clean
clean:
	rm -f build/* pdf/*.pdf
	touch build/.gitignore
