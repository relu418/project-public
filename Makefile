%.pdf: %.md
	pandoc -o $@ $<
