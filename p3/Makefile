myshell :
	cd src; \
	make
	mkdir -p bin
	mv src/myshell bin/myshell

debug :
	cd src; \
	make debug
	mkdir -p bin
	mv src/myshell bin/myshell

tar : clean
	tar -hczvf p3.tar.gz *
	
clean :
	cd src; \
	make clean
	rm -frd ./bin
	rm -f p3.tar.gz
	rm -f test/error.txt test/expected_error.txt test/expected_ls.txt test/output.txt test/output_ls.txt test/expected_output.txt
