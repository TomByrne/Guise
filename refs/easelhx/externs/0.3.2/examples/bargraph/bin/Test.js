$estr = function() { return js.Boot.__string_rec(this,''); }
if(typeof js=='undefined') js = {}
js.Boot = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__unhtml(js.Boot.__string_rec(v,"")) + "<br/>";
	var d = document.getElementById("haxe:trace");
	if(d == null) alert("No haxe:trace element defined\n" + msg); else d.innerHTML += msg;
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = ""; else null;
}
js.Boot.__closure = function(o,f) {
	var m = o[f];
	if(m == null) return null;
	var f1 = function() {
		return m.apply(o,arguments);
	};
	f1.scope = o;
	f1.method = m;
	return f1;
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ != null || o.__ename__ != null)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__ != null) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		return o.__enum__ == cl || cl == Class && o.__name__ != null || cl == Enum && o.__ename__ != null;
	}
}
js.Boot.__init = function() {
	js.Lib.isIE = typeof document!='undefined' && document.all != null && typeof window!='undefined' && window.opera == null;
	js.Lib.isOpera = typeof window!='undefined' && window.opera != null;
	Array.prototype.copy = Array.prototype.slice;
	Array.prototype.insert = function(i,x) {
		this.splice(i,0,x);
	};
	Array.prototype.remove = Array.prototype.indexOf?function(obj) {
		var idx = this.indexOf(obj);
		if(idx == -1) return false;
		this.splice(idx,1);
		return true;
	}:function(obj) {
		var i = 0;
		var l = this.length;
		while(i < l) {
			if(this[i] == obj) {
				this.splice(i,1);
				return true;
			}
			i++;
		}
		return false;
	};
	Array.prototype.iterator = function() {
		return { cur : 0, arr : this, hasNext : function() {
			return this.cur < this.arr.length;
		}, next : function() {
			return this.arr[this.cur++];
		}};
	};
	if(String.prototype.cca == null) String.prototype.cca = String.prototype.charCodeAt;
	String.prototype.charCodeAt = function(i) {
		var x = this.cca(i);
		if(x != x) return null;
		return x;
	};
	var oldsub = String.prototype.substr;
	String.prototype.substr = function(pos,len) {
		if(pos != null && pos != 0 && len != null && len < 0) return "";
		if(len == null) len = this.length;
		if(pos < 0) {
			pos = this.length + pos;
			if(pos < 0) pos = 0;
		} else if(len < 0) len = this.length + len - pos;
		return oldsub.apply(this,[pos,len]);
	};
	$closure = js.Boot.__closure;
}
js.Boot.prototype.__class__ = js.Boot;
js.Lib = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.isIE = null;
js.Lib.isOpera = null;
js.Lib.document = null;
js.Lib.window = null;
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
js.Lib.prototype.__class__ = js.Lib;
if(typeof haxe=='undefined') haxe = {}
haxe.Log = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype.__class__ = haxe.Log;
Test = function(p) {
	if( p === $_ ) return;
	this.init();
}
Test.__name__ = ["Test"];
Test.main = function() {
	new Test();
}
Test.prototype.canvas = null;
Test.prototype.stage = null;
Test.prototype.barPadding = null;
Test.prototype.barHeight = null;
Test.prototype.maxValue = null;
Test.prototype.count = null;
Test.prototype.barValues = null;
Test.prototype.bars = null;
Test.prototype.init = function() {
	this.barPadding = 7.;
	this.barHeight = 0.;
	this.maxValue = 50.;
	this.count = 0;
	this.barValues = [];
	this.bars = [];
	this.canvas = js.Lib.document.getElementById("testCanvas");
	haxe.Log.trace("canvas " + this.canvas,{ fileName : "Test.hx", lineNumber : 36, className : "Test", methodName : "init"});
	this.stage = new Stage(this.canvas);
	this.stage.enableMouseOver(10);
	var numBars = 4 + Math.ceil(Math.random() * 6);
	var max = 0;
	var _g = 0;
	while(_g < numBars) {
		var i = _g++;
		var val = 1 + Math.ceil(Math.random() * this.maxValue);
		if(val > max) max = val;
		this.barValues.push(val);
	}
	var barWidth = (this.canvas.width - 150 - (numBars - 1) * this.barPadding) / numBars;
	this.barHeight = this.canvas.height - 150;
	var bg = new Shape();
	this.stage.addChild(bg);
	bg.graphics.beginStroke("#444").moveTo(40,this.canvas.height - 69.5).lineTo(this.canvas.width - 70,this.canvas.height - 69.5).endStroke().beginFill("#222").moveTo(this.canvas.width - 70,this.canvas.height - 70).lineTo(this.canvas.width - 60,this.canvas.height - 80).lineTo(50,this.canvas.height - 80).lineTo(40,this.canvas.height - 70).closePath();
	var _g = 0;
	while(_g < 9) {
		var i = _g++;
		bg.graphics.beginStroke(i % 2 == 0?"#333":"#444").moveTo(50,this.canvas.height - 80 - i / 8 * this.barHeight + 0.5).lineTo(this.canvas.width - 60,this.canvas.height - 80 - i / 8 * this.barHeight + 0.5);
	}
	var label = new Text("Bar Graph Example","bold 30px Arial","#FFF");
	label.textAlign = "center";
	label.x = this.canvas.width / 2;
	label.y = 50;
	this.stage.addChild(label);
	var _g = 0;
	while(_g < numBars) {
		var i = [_g++];
		var bar = new Container();
		bar.mouseEnabled = true;
		var hue = this.getHueForBarIndex(i[0],numBars);
		var front = new Shape();
		front.graphics.beginLinearGradientFill([Graphics.getHSL(hue,100,60,0.9),Graphics.getHSL(hue,100,20,0.75)],[0.,1.],0,-100,barWidth,0).drawRect(0,-100,barWidth,100);
		var top = new Shape();
		top.graphics.beginFill(Graphics.getHSL(hue,100,70,0.9)).moveTo(10,-10).lineTo(10 + barWidth,-10).lineTo(barWidth,0).lineTo(0,0).closePath();
		if(this.barValues[i[0]] == max) top.graphics.beginFill("rgba(0,0,0,0.45)").drawPolyStar(barWidth / 2,31,7,5,0.6,-90).closePath();
		var right = new Shape();
		right.x = barWidth - 0.5;
		var label1 = new Text("Label " + i[0],"16px Arial","#FFF");
		label1.textAlign = "center";
		label1.x = barWidth / 2;
		label1.maxWidth = barWidth;
		label1.y = 26;
		label1.alpha = 0.5;
		var tab = new Shape();
		tab.graphics.beginFill(Graphics.getHSL(hue,100,20)).drawRoundRectComplex(0,1,barWidth,38,0,0,10,10);
		var value = new Text("","bold 14px Arial","#000");
		value.textAlign = "center";
		value.x = barWidth / 2;
		value.alpha = 0.45;
		bar.addChild(right);
		bar.addChild(front);
		bar.addChild(top);
		bar.addChild(value);
		bar.addChild(tab);
		bar.addChild(label1);
		bar.x = i[0] * (barWidth + this.barPadding) + 60;
		bar.y = this.canvas.height - 70;
		bar.onPress = (function(i) {
			return function(e) {
				haxe.Log.trace("onPress: " + i[0],{ fileName : "Test.hx", lineNumber : 155, className : "Test", methodName : "init"});
				e.onMouseMove = (function() {
					return function(ev) {
						haxe.Log.trace("mouse mov",{ fileName : "Test.hx", lineNumber : 157, className : "Test", methodName : "init"});
					};
				})();
			};
		})(i);
		bar.onMouseOver = (function(i) {
			return function(e) {
				haxe.Log.trace("onMouseOver: " + i[0],{ fileName : "Test.hx", lineNumber : 162, className : "Test", methodName : "init"});
			};
		})(i);
		bar.onMouseOut = (function(i) {
			return function(e) {
				haxe.Log.trace("onMouseOut: " + i[0],{ fileName : "Test.hx", lineNumber : 166, className : "Test", methodName : "init"});
			};
		})(i);
		this.stage.addChild(bar);
		this.bars.push(bar);
		this.drawBar(bar,0,i[0]);
	}
	this.count = numBars * 10;
	Ticker.setInterval(50);
	Ticker.addListener(this);
}
Test.prototype.tick = function() {
	if(--this.count == 1) Ticker.removeListener(this);
	var c = this.bars.length * 10 - this.count;
	var index = Std["int"](c / 10);
	var bar = this.bars[index];
	this.drawBar(bar,(c % 10 + 1) / 10 * this.barValues[index],index);
	this.stage.tick();
}
Test.prototype.drawBar = function(bar,value,index) {
	if(index == null) index = 0;
	var h = value / this.maxValue * this.barHeight;
	var hue = this.getHueForBarIndex(index,this.bars.length);
	var val = bar.getChildAt(3);
	val.text = Std.string(Std["int"](value));
	val.visible = h > 28;
	val.y = -h + 22;
	bar.getChildAt(1).scaleY = h / 100;
	bar.getChildAt(2).y = -h + 0.5;
	var right = bar.getChildAt(0);
	right.graphics.clear().beginFill(Graphics.getHSL(hue,90,15,0.7)).moveTo(0,0).lineTo(0,-h).lineTo(10,-h - 10).lineTo(10,-10).closePath();
}
Test.prototype.getHueForBarIndex = function(i,numBars) {
	return Std["int"](i / numBars * 360);
}
Test.prototype.__class__ = Test;
Std = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	if(x < 0) return Math.ceil(x);
	return Math.floor(x);
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && x.charCodeAt(1) == 120) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
Std.prototype.__class__ = Std;
IntIter = function(min,max) {
	if( min === $_ ) return;
	this.min = min;
	this.max = max;
}
IntIter.__name__ = ["IntIter"];
IntIter.prototype.min = null;
IntIter.prototype.max = null;
IntIter.prototype.hasNext = function() {
	return this.min < this.max;
}
IntIter.prototype.next = function() {
	return this.min++;
}
IntIter.prototype.__class__ = IntIter;
$_ = {}
js.Boot.__res = {}
js.Boot.__init();
{
	js.Lib.document = document;
	js.Lib.window = window;
	onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if( f == null )
			return false;
		return f(msg,[url+":"+line]);
	}
}
{
	String.prototype.__class__ = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = Array;
	Array.__name__ = ["Array"];
	Int = { __name__ : ["Int"]};
	Dynamic = { __name__ : ["Dynamic"]};
	Float = Number;
	Float.__name__ = ["Float"];
	Bool = { __ename__ : ["Bool"]};
	Class = { __name__ : ["Class"]};
	Enum = { };
	Void = { __ename__ : ["Void"]};
}
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	Math.isFinite = function(i) {
		return isFinite(i);
	};
	Math.isNaN = function(i) {
		return isNaN(i);
	};
}
js.Lib.onerror = null;
Test.main()