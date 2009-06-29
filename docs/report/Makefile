REPORT = report

all:
	latex $(REPORT)
	bibtex $(REPORT)
	bibtex $(REPORT)
	latex $(REPORT)
	latex $(REPORT)
	dvipdf $(REPORT)

clean:
	rm -f *.aux *.ps *.dvi *.log *~ *.bak *.bbl *.blg

realclean: clean
	rm -f *.pdf

public: all
	install $(REPORT).pdf /var/www/
