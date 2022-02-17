all.html: all.txt style.css convert.sh
	./convert.sh "LWB Errata" < all.txt > all.html
