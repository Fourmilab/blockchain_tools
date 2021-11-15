

    #   NOTE: This program was automatically generated by the Nuweb
    #   literate programming tool.  It is not intended to be modified
    #   directly.  If you wish to modify the code or use it in another
    #   project, you should start with the master, which is kept in the
    #   file blockchain_tools.w in the public GitHub repository:
    #       https://github.com/Fourmilab/blockchain_tools.git
    #   and is documented in the file blockchain_tools.pdf in the root directory
    #   of that repository.


PROJECT = blockchain_tools
VERSION = 1.0.4

#       Path names for build utilities

NUWEB = nuweb
LATEX = xelatex
PDFVIEW = evince
GNUFIND = find

duh:
	@echo "What'll it be, mate?  build view pdf peek gview gpdf geek lint stats clean bl"

build:
	perl tools/build/update_build.pl
	$(NUWEB) -t $(PROJECT).w
	chmod 755 perl/*.pl
	chmod 755 python/*.py
	@if [ \( ! -f Makefile \) -o \( Makefile.mkf -nt Makefile \) ] ; then \
		echo Makefile.mkf is newer than Makefile ; \
		sed "s/ \*$$//" Makefile.mkf | unexpand >Makefile ; \
	fi

pdf:
	rm -f $(PROJECT).log $(PROJECT).toc $(PROJECT).out $(PROJECT).aux
	$(NUWEB) -o -r $(PROJECT).w
	$(LATEX) $(PROJECT).tex
	# We have to re-run Nuweb to incorporate the updated TOC
	$(NUWEB) -o -r $(PROJECT).w
	$(LATEX) $(PROJECT).tex

view:
	make pdf
	$(PDFVIEW) $(PROJECT).pdf

peek:
	$(PDFVIEW) $(PROJECT).pdf

gpdf:
	rm -f $(PROJECT)_user_guide.log $(PROJECT)_user_guide.toc \
	      $(PROJECT)_user_guide.out $(PROJECT)_user_guide.aux
	$(NUWEB) -o -r $(PROJECT).w
	sed -e '/^\\expunge{begin}{userguide}$$/,/^\\expunge{end}{userguide}$$/d' \
	    $(PROJECT).tex | \
	    sed -e 's/\\impunge{userguide}//' >$(PROJECT)_user_guide.tex
	$(LATEX) $(PROJECT)_user_guide.tex
	$(LATEX) $(PROJECT)_user_guide.tex

gview:
	make gpdf
	$(PDFVIEW) $(PROJECT)_user_guide.pdf

geek:
	$(PDFVIEW) $(PROJECT)_user_guide.pdf

lint:
	@# Uses GNU find extension to quit on first error
	$(GNUFIND) perl tools -type f -name \*.pl -print \
		\( -exec perl -c {} \; -o -quit \)

bl:
	make --no-print-directory build
	make --no-print-directory lint

stats:
	@echo Build `grep "Build number" build.w | sed 's/[^0-9]//g'` \
		`grep "Build date and time " build.w | \
		sed 's/[^:0-9 \-]//g' | sed 's/^ *//'`
	@echo Web: `wc -l *.w`
	@echo Lines: `find . -type f \( -wholename ./perl/\*.pl \
		-o -wholename ./python/\*.py \) -exec cat {} \; | wc -l`
	@if [ -f $(PROJECT).log ] ; then \
		echo -n "Pages: " ; \
		tail -5 $(PROJECT).log | grep pages | sed 's/[^0-9]//g' ; \
	fi

dist:
	make bl
	make pdf
	make gpdf
	cp -pv perl/*.pl python/*.py bin
	cp -pv $(PROJECT).pdf $(PROJECT)_user_guide.pdf doc

release:
	rm -rf $(PROJECT)-$(VERSION)
	tar cfv release_temp.tar \
	    *.w Makefile bin doc \
	    figures perl/.keep python/.keep tools \
	    --exclude="test/test_output" test
	mkdir $(PROJECT)-$(VERSION)
	( cd $(PROJECT)-$(VERSION) ; tar xfv ../release_temp.tar )
	rm release_temp.tar
	tar cfvz $(PROJECT)-$(VERSION).tar.gz $(PROJECT)-$(VERSION)
	rm -rf $(PROJECT)-$(VERSION)

clean:
	rm -f nw[0-9]*[0-9] rm *.aux *.log *.out *.pdf *.tex *.toc \
	    perl/*.pl python/*.py *.gz bin/*.p[ly] doc/*.pdf
	rm -rf test/test_output

squeaky:
	make clean
	rm -f Makefile.mkf

regress:
	@if cmp -s perl/blockchain_address.pl bin/blockchain_address.pl; [ $$? -ne 0 ] ; \
	then \
	    echo "Did you forget to make dist?" ; \
	fi
	/bin/bash test/test.sh


regress_update:
	cp -p test/test_output/test_log.txt test/test_log_expected.txt
