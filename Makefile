.PHONY: test clean_test

test:
	vim -S column_conceal.vim sample.txt

clean_test:
	vim -S column_conceal.vim --clean sample.txt
