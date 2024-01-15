# Project directories
CWD := $(abspath $(shell pwd))
SRC := $(CWD)/src
OUT := $(CWD)/out

# Set engine (do not know if lualatex or xelatex works)
ENGINE := pdflatex

# Every source .tex file should correspond to a .pdf output file
SRC_FILES := $(wildcard $(SRC)/*.tex)

.PHONY: pdf clean lint
.SILENT: pdf clean lint

pdf: $(subst src,out,$(subst .tex,.pdf, $(SRC_FILES)))

clean:
	- rm -f $(OUT)/*

$(OUT):
	mkdir -p $@

$(OUT)/%.pdf: $(SRC_FILES) | $(OUT)
	cd $(SRC) \
	&& openout_any=a $(ENGINE) --jobname=$(notdir $(basename $@)) --output-directory=$(OUT) --file-line-error --shell-escape --synctex=1 $< \
	&& cd ..

lint:
	chktex -I0 -l $(SRC)/.chktexrc $(SRC_FILES)
	$(foreach x, $(SRC_FILES), lacheck $(x);)
