#!/bin/sh

set -e

echo '<!DOCTYPE html>'
echo '<html>'
echo '<head>'
echo "	<title>$1</title>"
echo '	<meta charset="utf-8"/>'
echo '	<meta name="viewport" content="width=device-width"/>'
echo '	<style>'
cat style.css
echo '	</style>'
echo '</head>'

echo '<body>'
awk -F '	' '
/^;/ {
	next	# comment
}

/^	[^	]+$/ {
	sub(/^	*/, "")
	print "<header>"
	print "<h1>" $0 "</h1>"
	print "<hr>"
	header = 1
	next
}

/^	*https?:/ {
	sub(/^	*/, "")
	print "<br><a href=\"" $0 "\">" $0 "</a><br>"
	next
}

/^		/ {
	if (header) {
		if (!subtitle)
			print "<p>"
		else
			print "<br>"
		subtitle = 1
	}
	print
	next
}

// {
	if (header)
		print "</header>"
	if (subtitle)
		print "</p>"
	if (tr)
		print "</td></tr>"
	if (dd)
		print "</dd>"
	header = 0
	subtitle = 0
	tr = 0
	dd = 0
}

/^[A-Z0-9]+	[^	]+	.*$/ {
	if (!table) {
		print "<table>"
		print "<colgroup><col class=bk><col class=pp></colgroup>"
	}
	print "<tr><td>" $1 "</td><td>" $2 "</td><td>"
	print "		" $3
	table = 1
	tr = 1
	next
}

// {
	if (table)
		print "</table>"
	table = 0
}

/^[^	]+	[^	]+$/ {
	if (!dl)
		print "<dl>"
	print "<dt>" $1 "</dt><dd>"
	print "		" $2
	dl = 1
	dd = 1
	next
}

// {
	if (dl)
		print "</dl>"
	dl = 0
}

/^\* +.* +\*$/ {
	sub(/^\* +/, "")
	sub(/ +\*$/, "")
	print "<h6>" $0 "</h6>"
	next
}

/^\*\* +.* +\*\*$/ {
	sub(/^\*\* +/, "")
	sub(/ +\*\*$/, "")
	print "<h5>" $0 "</h5>"
	next
}

// {
	while (match($0, /\*[^ *].*[^ *]\*/)) {
		a = substr($0, 1, RSTART - 1);
		b = substr($0, RSTART + 1, RLENGTH - 2);
		c = substr($0, RSTART + RLENGTH);
		$0 = a "<strong>" b "</strong>" c
	}
	print
}

END {
	if (tr)
		print "</td></tr>"
	if (table)
		print "</table>"
	if (dd)
		print "</dd>"
	if (dl)
		print "</dl>"
}
'

echo '</body>'
echo '</html>'
