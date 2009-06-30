FILENAME = presentation

all:
	latex $(FILENAME)
	dvipdf $(FILENAME)

clean:
	rm -f *.aux *.ps *.dvi *.log *~ *.bak *.bbl *.blg *.nav *.out *.snm

realclean: clean
	rm -f *.pdf

public: all
	install $(FILENAME).pdf /var/www/
