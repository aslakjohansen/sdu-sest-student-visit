TARGETS = \
	SDU\ SEST\ Studiepraktik\ -\ Fagligt\ Indhold\ -\ Handouts.pdf \
	SDU\ SEST\ Studiepraktik\ -\ Fagligt\ Indhold\ -\ Presentation.pdf \
	SDU\ SEST\ Studiepraktik\ -\ De\ To\ Uddannelser\ -\ Handouts.pdf \
	SDU\ SEST\ Studiepraktik\ -\ De\ To\ Uddannelser\ -\ Presentation.pdf \



all: ${TARGETS}

clean:
	touch ${TARGETS}
	rm -f ${TARGETS}

mrproper: clean
	touch d.aux d.log d~ d.nav d.out d.snm d.toc includes.d
	rm -f *.aux *.log *~ *.nav *.out *.snm *.toc includes.*



.includes:
	rm -Rf .includes
	mkdir .includes

.includes/slides.timestamp: .includes slides_*.tex shared.tex
	python3 ../bin/process-pubsub-flow
	python3 ../bin/process-object-struct
	cd .. ; bin/generate-tex-includes PDF doc/slides_handouts.tex doc
	touch .includes/slides.timestamp

.includes/uddannelser.timestamp: .includes uddannelser_*.tex shared.tex
	cd .. ; bin/generate-tex-includes PDF doc/uddannelser_handouts.tex doc
	touch .includes/uddannelser.timestamp



SDU\ SEST\ Studiepraktik\ -\ Fagligt\ Indhold\ -\ Handouts.pdf: slides_*.tex shared.tex .includes/slides.timestamp
	pdflatex -shell-escape slides_handouts.tex
	pdflatex -shell-escape slides_handouts.tex
	mv slides_handouts.pdf SDU\ SEST\ Studiepraktik\ -\ Fagligt\ Indhold\ -\ Handouts.pdf

SDU\ SEST\ Studiepraktik\ -\ Fagligt\ Indhold\ -\ Presentation.pdf: slides_*.tex shared.tex .includes/slides.timestamp
	pdflatex -shell-escape slides_presentation.tex
	pdflatex -shell-escape slides_presentation.tex
	mv slides_presentation.pdf SDU\ SEST\ Studiepraktik\ -\ Fagligt\ Indhold\ -\ Presentation.pdf

SDU\ SEST\ Studiepraktik\ -\ De\ To\ Uddannelser\ -\ Handouts.pdf: uddannelser_*.tex shared.tex .includes/uddannelser.timestamp
	pdflatex -shell-escape uddannelser_handouts.tex
	pdflatex -shell-escape uddannelser_handouts.tex
	mv uddannelser_handouts.pdf SDU\ SEST\ Studiepraktik\ -\ De\ To\ Uddannelser\ -\ Handouts.pdf

SDU\ SEST\ Studiepraktik\ -\ De\ To\ Uddannelser\ -\ Presentation.pdf: uddannelser_*.tex shared.tex .includes/uddannelser.timestamp
	pdflatex -shell-escape uddannelser_presentation.tex
	pdflatex -shell-escape uddannelser_presentation.tex
	mv uddannelser_presentation.pdf SDU\ SEST\ Studiepraktik\ -\ De\ To\ Uddannelser\ -\ Presentation.pdf

