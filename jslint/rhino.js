// rhino.js
// 2009-03-25
/*
Copyright (c) 2002 Douglas Crockford  (www.JSLint.com) Rhino Edition
*/

// This is the Rhino companion to fulljslint.js.

// 2009-05-14: Modifications by Mark Gibson to support multiple files.

/*extern JSLINT */
/*jslint rhino: true*/

(function (a) {
	if (!a[0]) {
		print("Usage: jslint.js file.js [...]");
		quit(1);
	}
	for (var f = 0; f < a.length; f += 1) {
		var input = readFile(a[f]);
		if (!input) {
			print("jslint: " + a[f] + " - couldn't open file!");
			quit(1);
		}
		if (!JSLINT(input, {rhino: true, passfail: false})) {
			for (var i = 0; i < JSLINT.errors.length; i += 1) {
				var e = JSLINT.errors[i];
				if (e) {
					print('jslint: ' + a[f]);
					print('line ' + (e.line + 1) + ', character ' +
							(e.character + 1) + ': ' + e.reason);
					print((e.evidence || '').
							replace(/^\s*(\S*(\s+\S+)*)\s*$/, "$1"));
					print('');
				}
			}
			quit(2);
		} else {
			print("jslint: " + a[f] + " - no problems");
		}
	}
	quit();
}(arguments));

