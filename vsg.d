import std.stdio;
import std.algorithm;
import std.range;
import std.stdio;
import std.regex;
import std.string;

void main() {
	int words[string];

	auto f = File("data.txt");

	char[] unwanted = [
		',', ';', '.', ':', '-', '_', '#', '\'', '+', '*', '~', '!', '"', '§',
		'$', '%', '&', '/', '{', '}', '(', ')', '[', ']', '=', '?', '\\' 
	];

	auto del = delegate(char b) {
		foreach(it; unwanted) {
			if(b == it) {
				return true;
			}
		}
		return true;
	};

	auto re = regex("[.,-_!]");
	//foreach(it; f.byLine.map!split().map!(a => strip!(a => a.canFind!(unwanted)))) {
	foreach(it; f.byLine.map!split()) {
		foreach(char[] jt; it) {
			char[] w = jt.strip!(a => (a == '.' || a == ',' || a == ';' || a ==
							':' || a == '{' || a == '}' || a == '"' || a ==
							'%' || a == '*' || a == '!' || a == '\\' || a ==
							'?' || a == '=' || a == '-' || a == '+' || a ==
							'§' || a == ')' || a == '(' || a == '&'));
			if(w.empty) {
				continue;
			}

			string ws = w.idup.strip;
			if(ws in words) {
				words[ws]++;
			} else {
				words[ws] = 1;
			}
		}
	}

	alias Tuple!(string, "w", int, "c") WC;

	WC[] wcc;

	foreach(key, value; words) {
		wcc ~= WC(key, value);
	}

	wcc.sort!((a,b) => a.c > b.c);
	foreach(it; wcc.filter!(a => a.w.length > 3).take(80)) {
		writefln("%4d %15s", it.c, it.w);
	}
}
