REPORT = report

all:
	latex $(REPORT).tex	# Build dvi
	latex $(REPORT).tex	# Inserts reference indicators at points of citation
	dvipdf $(REPORT).dvi

clean:
	rm -f *.aux *.ps *.dvi *.log *~ *.bak *.bbl *.blg

realclean: clean
	rm -f *.pdf

public: all
	install $(REPORT).pdf /var/www/


