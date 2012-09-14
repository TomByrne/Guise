$estr = function() { return js.Boot.__string_rec(this,''); }
if(typeof massive=='undefined') massive = {}
if(!massive.munit) massive.munit = {}
if(!massive.munit.async) massive.munit.async = {}
massive.munit.async.AsyncDelegate = function(testCase,handler,timeout,info) {
	if( testCase === $_ ) return;
	var self = this;
	this.testCase = testCase;
	this.handler = handler;
	this.delegateHandler = Reflect.makeVarArgs($closure(this,"responseHandler"));
	this.info = info;
	this.params = [];
	this.timedOut = false;
	this.canceled = false;
	if(timeout == null || timeout <= 0) timeout = 400;
	this.timeoutDelay = timeout;
	this.timer = massive.munit.util.Timer.delay($closure(this,"timeoutHandler"),this.timeoutDelay);
}
massive.munit.async.AsyncDelegate.__name__ = ["massive","munit","async","AsyncDelegate"];
massive.munit.async.AsyncDelegate.prototype.observer = null;
massive.munit.async.AsyncDelegate.prototype.info = null;
massive.munit.async.AsyncDelegate.prototype.delegateHandler = null;
massive.munit.async.AsyncDelegate.prototype.timeoutDelay = null;
massive.munit.async.AsyncDelegate.prototype.timedOut = null;
massive.munit.async.AsyncDelegate.prototype.testCase = null;
massive.munit.async.AsyncDelegate.prototype.handler = null;
massive.munit.async.AsyncDelegate.prototype.timer = null;
massive.munit.async.AsyncDelegate.prototype.canceled = null;
massive.munit.async.AsyncDelegate.prototype.deferredTimer = null;
massive.munit.async.AsyncDelegate.prototype.params = null;
massive.munit.async.AsyncDelegate.prototype.runTest = function() {
	this.handler.apply(this.testCase,this.params);
}
massive.munit.async.AsyncDelegate.prototype.cancelTest = function() {
	this.canceled = true;
	this.timer.stop();
	if(this.deferredTimer != null) this.deferredTimer.stop();
}
massive.munit.async.AsyncDelegate.prototype.responseHandler = function(params) {
	if(this.timedOut || this.canceled) return;
	this.timer.stop();
	if(this.deferredTimer != null) this.deferredTimer.stop();
	if(params == null) params = [];
	this.params = params;
	if(this.observer != null) this.observer.asyncResponseHandler(this);
}
massive.munit.async.AsyncDelegate.prototype.timeoutHandler = function() {
	this.actualTimeoutHandler();
}
massive.munit.async.AsyncDelegate.prototype.actualTimeoutHandler = function() {
	this.deferredTimer = null;
	this.handler = null;
	this.delegateHandler = null;
	this.timedOut = true;
	if(this.observer != null) this.observer.asyncTimeoutHandler(this);
}
massive.munit.async.AsyncDelegate.prototype.__class__ = massive.munit.async.AsyncDelegate;
if(typeof haxe=='undefined') haxe = {}
haxe.Http = function(url) {
	if( url === $_ ) return;
	this.url = url;
	this.headers = new Hash();
	this.params = new Hash();
	this.async = true;
}
haxe.Http.__name__ = ["haxe","Http"];
haxe.Http.requestUrl = function(url) {
	var h = new haxe.Http(url);
	h.async = false;
	var r = null;
	h.onData = function(d) {
		r = d;
	};
	h.onError = function(e) {
		throw e;
	};
	h.request(false);
	return r;
}
haxe.Http.prototype.url = null;
haxe.Http.prototype.async = null;
haxe.Http.prototype.postData = null;
haxe.Http.prototype.headers = null;
haxe.Http.prototype.params = null;
haxe.Http.prototype.setHeader = function(header,value) {
	this.headers.set(header,value);
}
haxe.Http.prototype.setParameter = function(param,value) {
	this.params.set(param,value);
}
haxe.Http.prototype.setPostData = function(data) {
	this.postData = data;
}
haxe.Http.prototype.request = function(post) {
	var me = this;
	var r = new js.XMLHttpRequest();
	var onreadystatechange = function() {
		if(r.readyState != 4) return;
		var s = (function($this) {
			var $r;
			try {
				$r = r.status;
			} catch( e ) {
				$r = null;
			}
			return $r;
		}(this));
		if(s == undefined) s = null;
		if(s != null) me.onStatus(s);
		if(s != null && s >= 200 && s < 400) me.onData(r.responseText); else switch(s) {
		case null: case undefined:
			me.onError("Failed to connect or resolve host");
			break;
		case 12029:
			me.onError("Failed to connect to host");
			break;
		case 12007:
			me.onError("Unknown host");
			break;
		default:
			me.onError("Http Error #" + r.status);
		}
	};
	if(this.async) r.onreadystatechange = onreadystatechange;
	var uri = this.postData;
	if(uri != null) post = true; else {
		var $it0 = this.params.keys();
		while( $it0.hasNext() ) {
			var p = $it0.next();
			if(uri == null) uri = ""; else uri += "&";
			uri += StringTools.urlDecode(p) + "=" + StringTools.urlEncode(this.params.get(p));
		}
	}
	try {
		if(post) r.open("POST",this.url,this.async); else if(uri != null) {
			var question = this.url.split("?").length <= 1;
			r.open("GET",this.url + (question?"?":"&") + uri,this.async);
			uri = null;
		} else r.open("GET",this.url,this.async);
	} catch( e ) {
		this.onError(e.toString());
		return;
	}
	if(this.headers.get("Content-Type") == null && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	var $it1 = this.headers.keys();
	while( $it1.hasNext() ) {
		var h = $it1.next();
		r.setRequestHeader(h,this.headers.get(h));
	}
	r.send(uri);
	if(!this.async) onreadystatechange();
}
haxe.Http.prototype.onData = function(data) {
}
haxe.Http.prototype.onError = function(msg) {
}
haxe.Http.prototype.onStatus = function(status) {
}
haxe.Http.prototype.__class__ = haxe.Http;
massive.munit.TestResult = function(p) {
	if( p === $_ ) return;
	this.passed = false;
	this.executionTime = 0.0;
	this.name = "";
	this.className = "";
	this.description = "";
	this.async = false;
	this.ignore = false;
	this.error = null;
	this.failure = null;
}
massive.munit.TestResult.__name__ = ["massive","munit","TestResult"];
massive.munit.TestResult.prototype.passed = null;
massive.munit.TestResult.prototype.executionTime = null;
massive.munit.TestResult.prototype.name = null;
massive.munit.TestResult.prototype.className = null;
massive.munit.TestResult.prototype.description = null;
massive.munit.TestResult.prototype.location = null;
massive.munit.TestResult.prototype.get_location = function() {
	return this.name == "" && this.className == ""?"":this.className + "#" + this.name;
}
massive.munit.TestResult.prototype.async = null;
massive.munit.TestResult.prototype.ignore = null;
massive.munit.TestResult.prototype.failure = null;
massive.munit.TestResult.prototype.error = null;
massive.munit.TestResult.prototype.type = null;
massive.munit.TestResult.prototype.get_type = function() {
	if(this.error != null) return massive.munit.TestResultType.ERROR;
	if(this.failure != null) return massive.munit.TestResultType.FAIL;
	if(this.ignore == true) return massive.munit.TestResultType.IGNORE;
	if(this.passed == true) return massive.munit.TestResultType.PASS;
	return massive.munit.TestResultType.UNKNOWN;
}
massive.munit.TestResult.prototype.__class__ = massive.munit.TestResult;
massive.munit.TestResultType = { __ename__ : ["massive","munit","TestResultType"], __constructs__ : ["UNKNOWN","PASS","FAIL","ERROR","IGNORE"] }
massive.munit.TestResultType.UNKNOWN = ["UNKNOWN",0];
massive.munit.TestResultType.UNKNOWN.toString = $estr;
massive.munit.TestResultType.UNKNOWN.__enum__ = massive.munit.TestResultType;
massive.munit.TestResultType.PASS = ["PASS",1];
massive.munit.TestResultType.PASS.toString = $estr;
massive.munit.TestResultType.PASS.__enum__ = massive.munit.TestResultType;
massive.munit.TestResultType.FAIL = ["FAIL",2];
massive.munit.TestResultType.FAIL.toString = $estr;
massive.munit.TestResultType.FAIL.__enum__ = massive.munit.TestResultType;
massive.munit.TestResultType.ERROR = ["ERROR",3];
massive.munit.TestResultType.ERROR.toString = $estr;
massive.munit.TestResultType.ERROR.__enum__ = massive.munit.TestResultType;
massive.munit.TestResultType.IGNORE = ["IGNORE",4];
massive.munit.TestResultType.IGNORE.toString = $estr;
massive.munit.TestResultType.IGNORE.__enum__ = massive.munit.TestResultType;
List = function(p) {
	if( p === $_ ) return;
	this.length = 0;
}
List.__name__ = ["List"];
List.prototype.h = null;
List.prototype.q = null;
List.prototype.length = null;
List.prototype.add = function(item) {
	var x = [item];
	if(this.h == null) this.h = x; else this.q[1] = x;
	this.q = x;
	this.length++;
}
List.prototype.push = function(item) {
	var x = [item,this.h];
	this.h = x;
	if(this.q == null) this.q = x;
	this.length++;
}
List.prototype.first = function() {
	return this.h == null?null:this.h[0];
}
List.prototype.last = function() {
	return this.q == null?null:this.q[0];
}
List.prototype.pop = function() {
	if(this.h == null) return null;
	var x = this.h[0];
	this.h = this.h[1];
	if(this.h == null) this.q = null;
	this.length--;
	return x;
}
List.prototype.isEmpty = function() {
	return this.h == null;
}
List.prototype.clear = function() {
	this.h = null;
	this.q = null;
	this.length = 0;
}
List.prototype.remove = function(v) {
	var prev = null;
	var l = this.h;
	while(l != null) {
		if(l[0] == v) {
			if(prev == null) this.h = l[1]; else prev[1] = l[1];
			if(this.q == l) this.q = prev;
			this.length--;
			return true;
		}
		prev = l;
		l = l[1];
	}
	return false;
}
List.prototype.iterator = function() {
	return { h : this.h, hasNext : function() {
		return this.h != null;
	}, next : function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		return x;
	}};
}
List.prototype.toString = function() {
	var s = new StringBuf();
	var first = true;
	var l = this.h;
	s.b[s.b.length] = "{" == null?"null":"{";
	while(l != null) {
		if(first) first = false; else s.b[s.b.length] = ", " == null?"null":", ";
		s.add(Std.string(l[0]));
		l = l[1];
	}
	s.b[s.b.length] = "}" == null?"null":"}";
	return s.b.join("");
}
List.prototype.join = function(sep) {
	var s = new StringBuf();
	var first = true;
	var l = this.h;
	while(l != null) {
		if(first) first = false; else s.b[s.b.length] = sep == null?"null":sep;
		s.add(l[0]);
		l = l[1];
	}
	return s.b.join("");
}
List.prototype.filter = function(f) {
	var l2 = new List();
	var l = this.h;
	while(l != null) {
		var v = l[0];
		l = l[1];
		if(f(v)) l2.add(v);
	}
	return l2;
}
List.prototype.map = function(f) {
	var b = new List();
	var l = this.h;
	while(l != null) {
		var v = l[0];
		l = l[1];
		b.add(f(v));
	}
	return b;
}
List.prototype.__class__ = List;
massive.munit.TestSuite = function(p) {
	if( p === $_ ) return;
	this.tests = new Array();
	this.index = 0;
}
massive.munit.TestSuite.__name__ = ["massive","munit","TestSuite"];
massive.munit.TestSuite.prototype.tests = null;
massive.munit.TestSuite.prototype.index = null;
massive.munit.TestSuite.prototype.add = function(test) {
	this.tests.push(test);
	this.sortTests();
}
massive.munit.TestSuite.prototype.hasNext = function() {
	return this.index < this.tests.length;
}
massive.munit.TestSuite.prototype.next = function() {
	return this.hasNext()?this.tests[this.index++]:null;
}
massive.munit.TestSuite.prototype.repeat = function() {
	if(this.index > 0) this.index--;
}
massive.munit.TestSuite.prototype.sortTests = function() {
	this.tests.sort($closure(this,"sortByName"));
}
massive.munit.TestSuite.prototype.sortByName = function(x,y) {
	var xName = Type.getClassName(x);
	var yName = Type.getClassName(y);
	if(xName == yName) return 0;
	if(xName > yName) return 1; else return -1;
}
massive.munit.TestSuite.prototype.__class__ = massive.munit.TestSuite;
if(!massive.haxe) massive.haxe = {}
massive.haxe.Exception = function(message,info) {
	if( message === $_ ) return;
	this.message = message;
	this.info = info;
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "Exception.hx", lineNumber : 70, className : "massive.haxe.Exception", methodName : "new"}).className;
}
massive.haxe.Exception.__name__ = ["massive","haxe","Exception"];
massive.haxe.Exception.prototype.type = null;
massive.haxe.Exception.prototype.message = null;
massive.haxe.Exception.prototype.info = null;
massive.haxe.Exception.prototype.toString = function() {
	var str = this.type + ": " + this.message;
	if(this.info != null) str += " at " + this.info.className + "#" + this.info.methodName + " (" + this.info.lineNumber + ")";
	return str;
}
massive.haxe.Exception.prototype.__class__ = massive.haxe.Exception;
massive.munit.MUnitException = function(message,info) {
	if( message === $_ ) return;
	massive.haxe.Exception.call(this,message,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "MUnitException.hx", lineNumber : 50, className : "massive.munit.MUnitException", methodName : "new"}).className;
}
massive.munit.MUnitException.__name__ = ["massive","munit","MUnitException"];
massive.munit.MUnitException.__super__ = massive.haxe.Exception;
for(var k in massive.haxe.Exception.prototype ) massive.munit.MUnitException.prototype[k] = massive.haxe.Exception.prototype[k];
massive.munit.MUnitException.prototype.__class__ = massive.munit.MUnitException;
massive.munit.async.MissingAsyncDelegateException = function(message,info) {
	if( message === $_ ) return;
	massive.munit.MUnitException.call(this,message,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "MissingAsyncDelegateException.hx", lineNumber : 47, className : "massive.munit.async.MissingAsyncDelegateException", methodName : "new"}).className;
}
massive.munit.async.MissingAsyncDelegateException.__name__ = ["massive","munit","async","MissingAsyncDelegateException"];
massive.munit.async.MissingAsyncDelegateException.__super__ = massive.munit.MUnitException;
for(var k in massive.munit.MUnitException.prototype ) massive.munit.async.MissingAsyncDelegateException.prototype[k] = massive.munit.MUnitException.prototype[k];
massive.munit.async.MissingAsyncDelegateException.prototype.__class__ = massive.munit.async.MissingAsyncDelegateException;
if(!massive.haxe.util) massive.haxe.util = {}
massive.haxe.util.ReflectUtil = function() { }
massive.haxe.util.ReflectUtil.__name__ = ["massive","haxe","util","ReflectUtil"];
massive.haxe.util.ReflectUtil.here = function(info) {
	return info;
}
massive.haxe.util.ReflectUtil.prototype.__class__ = massive.haxe.util.ReflectUtil;
massive.munit.ITestResultClient = function() { }
massive.munit.ITestResultClient.__name__ = ["massive","munit","ITestResultClient"];
massive.munit.ITestResultClient.prototype.completionHandler = null;
massive.munit.ITestResultClient.prototype.id = null;
massive.munit.ITestResultClient.prototype.addPass = null;
massive.munit.ITestResultClient.prototype.addFail = null;
massive.munit.ITestResultClient.prototype.addError = null;
massive.munit.ITestResultClient.prototype.addIgnore = null;
massive.munit.ITestResultClient.prototype.reportFinalStatistics = null;
massive.munit.ITestResultClient.prototype.__class__ = massive.munit.ITestResultClient;
massive.munit.IAdvancedTestResultClient = function() { }
massive.munit.IAdvancedTestResultClient.__name__ = ["massive","munit","IAdvancedTestResultClient"];
massive.munit.IAdvancedTestResultClient.prototype.setCurrentTestClass = null;
massive.munit.IAdvancedTestResultClient.prototype.__class__ = massive.munit.IAdvancedTestResultClient;
massive.munit.IAdvancedTestResultClient.__interfaces__ = [massive.munit.ITestResultClient];
if(!massive.munit.client) massive.munit.client = {}
massive.munit.client.HTTPClient = function(client,url,queueRequest) {
	if( client === $_ ) return;
	if(queueRequest == null) queueRequest = true;
	if(url == null) url = "http://localhost:2000";
	this.id = "HTTPClient";
	this.client = client;
	this.url = url;
	this.queueRequest = queueRequest;
}
massive.munit.client.HTTPClient.__name__ = ["massive","munit","client","HTTPClient"];
massive.munit.client.HTTPClient.dispatchNextRequest = function() {
	if(massive.munit.client.HTTPClient.responsePending || massive.munit.client.HTTPClient.queue.length == 0) return;
	massive.munit.client.HTTPClient.responsePending = true;
	var request = massive.munit.client.HTTPClient.queue.pop();
	request.send();
}
massive.munit.client.HTTPClient.prototype.id = null;
massive.munit.client.HTTPClient.prototype.completionHandler = null;
massive.munit.client.HTTPClient.prototype.get_completeHandler = function() {
	return this.completionHandler;
}
massive.munit.client.HTTPClient.prototype.set_completeHandler = function(value) {
	return this.completionHandler = value;
}
massive.munit.client.HTTPClient.prototype.client = null;
massive.munit.client.HTTPClient.prototype.url = null;
massive.munit.client.HTTPClient.prototype.request = null;
massive.munit.client.HTTPClient.prototype.queueRequest = null;
massive.munit.client.HTTPClient.prototype.setCurrentTestClass = function(className) {
	if(Std["is"](this.client,massive.munit.IAdvancedTestResultClient)) ((function($this) {
		var $r;
		var $t = $this.client;
		if(Std["is"]($t,massive.munit.IAdvancedTestResultClient)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this))).setCurrentTestClass(className);
}
massive.munit.client.HTTPClient.prototype.addPass = function(result) {
	this.client.addPass(result);
}
massive.munit.client.HTTPClient.prototype.addFail = function(result) {
	this.client.addFail(result);
}
massive.munit.client.HTTPClient.prototype.addError = function(result) {
	this.client.addError(result);
}
massive.munit.client.HTTPClient.prototype.addIgnore = function(result) {
	this.client.addIgnore(result);
}
massive.munit.client.HTTPClient.prototype.reportFinalStatistics = function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
	var result = this.client.reportFinalStatistics(testCount,passCount,failCount,errorCount,ignoreCount,time);
	this.sendResult(result);
	return result;
}
massive.munit.client.HTTPClient.prototype.sendResult = function(result) {
	this.request = new massive.munit.client.URLRequest(this.url);
	this.request.setHeader("munit-clientId",this.client.id);
	this.request.setHeader("munit-platformId",this.platform());
	this.request.onData = $closure(this,"onData");
	this.request.onError = $closure(this,"onError");
	this.request.data = result;
	if(this.queueRequest) {
		massive.munit.client.HTTPClient.queue.unshift(this.request);
		massive.munit.client.HTTPClient.dispatchNextRequest();
	} else this.request.send();
}
massive.munit.client.HTTPClient.prototype.platform = function() {
	return "js";
	return "unknown";
}
massive.munit.client.HTTPClient.prototype.onData = function(data) {
	if(this.queueRequest) {
		massive.munit.client.HTTPClient.responsePending = false;
		massive.munit.client.HTTPClient.dispatchNextRequest();
	}
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
}
massive.munit.client.HTTPClient.prototype.onError = function(msg) {
	if(this.queueRequest) {
		massive.munit.client.HTTPClient.responsePending = false;
		massive.munit.client.HTTPClient.dispatchNextRequest();
	}
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
}
massive.munit.client.HTTPClient.prototype.__class__ = massive.munit.client.HTTPClient;
massive.munit.client.HTTPClient.__interfaces__ = [massive.munit.IAdvancedTestResultClient];
massive.munit.client.URLRequest = function(url) {
	if( url === $_ ) return;
	this.url = url;
	this.createClient(url);
	this.setHeader("Content-Type","text/plain");
}
massive.munit.client.URLRequest.__name__ = ["massive","munit","client","URLRequest"];
massive.munit.client.URLRequest.prototype.onData = null;
massive.munit.client.URLRequest.prototype.onError = null;
massive.munit.client.URLRequest.prototype.data = null;
massive.munit.client.URLRequest.prototype.url = null;
massive.munit.client.URLRequest.prototype.headers = null;
massive.munit.client.URLRequest.prototype.client = null;
massive.munit.client.URLRequest.prototype.createClient = function(url) {
	this.client = new haxe.Http(url);
}
massive.munit.client.URLRequest.prototype.setHeader = function(name,value) {
	this.client.setHeader(name,value);
}
massive.munit.client.URLRequest.prototype.send = function() {
	this.client.onData = this.onData;
	this.client.onError = this.onError;
	this.client.setPostData(this.data);
	this.client.request(true);
}
massive.munit.client.URLRequest.prototype.__class__ = massive.munit.client.URLRequest;
Reflect = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	if(o.hasOwnProperty != null) return o.hasOwnProperty(field);
	var arr = Reflect.fields(o);
	var $it0 = arr.iterator();
	while( $it0.hasNext() ) {
		var t = $it0.next();
		if(t == field) return true;
	}
	return false;
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	if(o == null) return new Array();
	var a = new Array();
	if(o.hasOwnProperty) {
		for(var i in o) if( o.hasOwnProperty(i) ) a.push(i);
	} else {
		var t;
		try {
			t = o.__proto__;
		} catch( e ) {
			t = null;
		}
		if(t != null) o.__proto__ = null;
		for(var i in o) if( i != "__proto__" ) a.push(i);
		if(t != null) o.__proto__ = t;
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && f.__name__ == null;
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && v.__name__ != null;
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = new Array();
		var _g1 = 0, _g = arguments.length;
		while(_g1 < _g) {
			var i = _g1++;
			a.push(arguments[i]);
		}
		return f(a);
	};
}
Reflect.prototype.__class__ = Reflect;
if(typeof org=='undefined') org = {}
if(!org.hamcrest) org.hamcrest = {}
org.hamcrest.Exception = function(message,cause,info) {
	if( message === $_ ) return;
	if(message == null) message = "";
	this.name = Type.getClassName(Type.getClass(this));
	this.message = message;
	this.cause = cause;
	this.info = info;
}
org.hamcrest.Exception.__name__ = ["org","hamcrest","Exception"];
org.hamcrest.Exception.prototype.name = null;
org.hamcrest.Exception.prototype.message = null;
org.hamcrest.Exception.prototype.cause = null;
org.hamcrest.Exception.prototype.info = null;
org.hamcrest.Exception.prototype.toString = function() {
	var str = this.name + ": " + this.message;
	if(this.info != null) str += " at " + this.info.className + "#" + this.info.methodName + " (" + this.info.lineNumber + ")";
	if(this.cause != null) str += "\n\t Caused by: " + this.cause;
	return str;
}
org.hamcrest.Exception.prototype.__class__ = org.hamcrest.Exception;
org.hamcrest.AssertionException = function(message,cause,info) {
	if( message === $_ ) return;
	if(message == null) message = "";
	org.hamcrest.Exception.call(this,message,cause,info);
}
org.hamcrest.AssertionException.__name__ = ["org","hamcrest","AssertionException"];
org.hamcrest.AssertionException.__super__ = org.hamcrest.Exception;
for(var k in org.hamcrest.Exception.prototype ) org.hamcrest.AssertionException.prototype[k] = org.hamcrest.Exception.prototype[k];
org.hamcrest.AssertionException.prototype.__class__ = org.hamcrest.AssertionException;
haxe.StackItem = { __ename__ : ["haxe","StackItem"], __constructs__ : ["CFunction","Module","FilePos","Method","Lambda"] }
haxe.StackItem.CFunction = ["CFunction",0];
haxe.StackItem.CFunction.toString = $estr;
haxe.StackItem.CFunction.__enum__ = haxe.StackItem;
haxe.StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Lambda = function(v) { var $x = ["Lambda",4,v]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.Stack = function() { }
haxe.Stack.__name__ = ["haxe","Stack"];
haxe.Stack.callStack = function() {
	return haxe.Stack.makeStack("$s");
}
haxe.Stack.exceptionStack = function() {
	return haxe.Stack.makeStack("$e");
}
haxe.Stack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b[b.b.length] = "\nCalled from " == null?"null":"\nCalled from ";
		haxe.Stack.itemToString(b,s);
	}
	return b.b.join("");
}
haxe.Stack.itemToString = function(b,s) {
	var $e = (s);
	switch( $e[1] ) {
	case 0:
		b.b[b.b.length] = "a C function" == null?"null":"a C function";
		break;
	case 1:
		var m = $e[2];
		b.b[b.b.length] = "module " == null?"null":"module ";
		b.b[b.b.length] = m == null?"null":m;
		break;
	case 2:
		var line = $e[4], file = $e[3], s1 = $e[2];
		if(s1 != null) {
			haxe.Stack.itemToString(b,s1);
			b.b[b.b.length] = " (" == null?"null":" (";
		}
		b.b[b.b.length] = file == null?"null":file;
		b.b[b.b.length] = " line " == null?"null":" line ";
		b.b[b.b.length] = line == null?"null":line;
		if(s1 != null) b.b[b.b.length] = ")" == null?"null":")";
		break;
	case 3:
		var meth = $e[3], cname = $e[2];
		b.b[b.b.length] = cname == null?"null":cname;
		b.b[b.b.length] = "." == null?"null":".";
		b.b[b.b.length] = meth == null?"null":meth;
		break;
	case 4:
		var n = $e[2];
		b.b[b.b.length] = "local function #" == null?"null":"local function #";
		b.b[b.b.length] = n == null?"null":n;
		break;
	}
}
haxe.Stack.makeStack = function(s) {
	var a = (function($this) {
		var $r;
		try {
			$r = eval(s);
		} catch( e ) {
			$r = [];
		}
		return $r;
	}(this));
	var m = new Array();
	var _g1 = 0, _g = a.length - (s == "$s"?2:0);
	while(_g1 < _g) {
		var i = _g1++;
		var d = a[i].split("::");
		m.unshift(haxe.StackItem.Method(d[0],d[1]));
	}
	return m;
}
haxe.Stack.prototype.__class__ = haxe.Stack;
org.hamcrest.IllegalArgumentException = function(message,cause,info) {
	if( message === $_ ) return;
	if(message == null) message = "Argument could not be processed.";
	org.hamcrest.Exception.call(this,message,cause,info);
}
org.hamcrest.IllegalArgumentException.__name__ = ["org","hamcrest","IllegalArgumentException"];
org.hamcrest.IllegalArgumentException.__super__ = org.hamcrest.Exception;
for(var k in org.hamcrest.Exception.prototype ) org.hamcrest.IllegalArgumentException.prototype[k] = org.hamcrest.Exception.prototype[k];
org.hamcrest.IllegalArgumentException.prototype.__class__ = org.hamcrest.IllegalArgumentException;
org.hamcrest.MissingImplementationException = function(message,cause,info) {
	if( message === $_ ) return;
	if(message == null) message = "Abstract method not overridden.";
	org.hamcrest.Exception.call(this,message,cause,info);
}
org.hamcrest.MissingImplementationException.__name__ = ["org","hamcrest","MissingImplementationException"];
org.hamcrest.MissingImplementationException.__super__ = org.hamcrest.Exception;
for(var k in org.hamcrest.Exception.prototype ) org.hamcrest.MissingImplementationException.prototype[k] = org.hamcrest.Exception.prototype[k];
org.hamcrest.MissingImplementationException.prototype.__class__ = org.hamcrest.MissingImplementationException;
org.hamcrest.UnsupportedOperationException = function(message,cause,info) {
	if( message === $_ ) return;
	if(message == null) message = "";
	org.hamcrest.Exception.call(this,message,cause,info);
}
org.hamcrest.UnsupportedOperationException.__name__ = ["org","hamcrest","UnsupportedOperationException"];
org.hamcrest.UnsupportedOperationException.__super__ = org.hamcrest.Exception;
for(var k in org.hamcrest.Exception.prototype ) org.hamcrest.UnsupportedOperationException.prototype[k] = org.hamcrest.Exception.prototype[k];
org.hamcrest.UnsupportedOperationException.prototype.__class__ = org.hamcrest.UnsupportedOperationException;
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
TestSuite = function(p) {
	if( p === $_ ) return;
	massive.munit.TestSuite.call(this);
	this.add(ExampleTest);
	this.add(v042.EaselJsTest);
}
TestSuite.__name__ = ["TestSuite"];
TestSuite.__super__ = massive.munit.TestSuite;
for(var k in massive.munit.TestSuite.prototype ) TestSuite.prototype[k] = massive.munit.TestSuite.prototype[k];
TestSuite.prototype.__class__ = TestSuite;
massive.munit.TestClassHelper = function(type,isDebug) {
	if( type === $_ ) return;
	if(isDebug == null) isDebug = false;
	this.type = type;
	this.isDebug = isDebug;
	this.tests = [];
	this.index = 0;
	this.className = Type.getClassName(type);
	this.beforeClass = $closure(this,"nullFunc");
	this.afterClass = $closure(this,"nullFunc");
	this.before = $closure(this,"nullFunc");
	this.after = $closure(this,"nullFunc");
	this.parse(type);
}
massive.munit.TestClassHelper.__name__ = ["massive","munit","TestClassHelper"];
massive.munit.TestClassHelper.prototype.type = null;
massive.munit.TestClassHelper.prototype.test = null;
massive.munit.TestClassHelper.prototype.beforeClass = null;
massive.munit.TestClassHelper.prototype.afterClass = null;
massive.munit.TestClassHelper.prototype.before = null;
massive.munit.TestClassHelper.prototype.after = null;
massive.munit.TestClassHelper.prototype.tests = null;
massive.munit.TestClassHelper.prototype.index = null;
massive.munit.TestClassHelper.prototype.className = null;
massive.munit.TestClassHelper.prototype.isDebug = null;
massive.munit.TestClassHelper.prototype.hasNext = function() {
	return this.index < this.tests.length;
}
massive.munit.TestClassHelper.prototype.next = function() {
	return this.hasNext()?this.tests[this.index++]:null;
}
massive.munit.TestClassHelper.prototype.current = function() {
	return this.index <= 0?this.tests[0]:this.tests[this.index - 1];
}
massive.munit.TestClassHelper.prototype.parse = function(type) {
	this.test = Type.createEmptyInstance(type);
	var inherintanceChain = this.getInheritanceChain(type);
	var fieldMeta = this.collateFieldMeta(inherintanceChain);
	this.scanForTests(fieldMeta);
	this.tests.sort($closure(this,"sortTestsByName"));
}
massive.munit.TestClassHelper.prototype.getInheritanceChain = function(clazz) {
	var inherintanceChain = [clazz];
	while((clazz = Type.getSuperClass(clazz)) != null) inherintanceChain.push(clazz);
	return inherintanceChain;
}
massive.munit.TestClassHelper.prototype.collateFieldMeta = function(inherintanceChain) {
	var meta = { };
	while(inherintanceChain.length > 0) {
		var clazz = inherintanceChain.pop();
		var newMeta = haxe.rtti.Meta.getFields(clazz);
		var markedFieldNames = Reflect.fields(newMeta);
		var _g = 0;
		while(_g < markedFieldNames.length) {
			var fieldName = markedFieldNames[_g];
			++_g;
			var recordedFieldTags = Reflect.field(meta,fieldName);
			var newFieldTags = Reflect.field(newMeta,fieldName);
			var newTagNames = Reflect.fields(newFieldTags);
			if(recordedFieldTags == null) {
				var tagsCopy = { };
				var _g1 = 0;
				while(_g1 < newTagNames.length) {
					var tagName = newTagNames[_g1];
					++_g1;
					tagsCopy[tagName] = Reflect.field(newFieldTags,tagName);
				}
				meta[fieldName] = tagsCopy;
			} else {
				var ignored = false;
				var _g1 = 0;
				while(_g1 < newTagNames.length) {
					var tagName = newTagNames[_g1];
					++_g1;
					if(tagName == "Ignore") ignored = true;
					if(!ignored && (tagName == "Test" || tagName == "AsyncTest") && Reflect.hasField(recordedFieldTags,"Ignore")) Reflect.deleteField(recordedFieldTags,"Ignore");
					var tagValue = Reflect.field(newFieldTags,tagName);
					recordedFieldTags[tagName] = tagValue;
				}
			}
		}
	}
	return meta;
}
massive.munit.TestClassHelper.prototype.scanForTests = function(fieldMeta) {
	var fieldNames = Reflect.fields(fieldMeta);
	var _g = 0;
	while(_g < fieldNames.length) {
		var fieldName = fieldNames[_g];
		++_g;
		var f = Reflect.field(this.test,fieldName);
		if(Reflect.isFunction(f)) {
			var funcMeta = Reflect.field(fieldMeta,fieldName);
			this.searchForMatchingTags(fieldName,f,funcMeta);
		}
	}
}
massive.munit.TestClassHelper.prototype.searchForMatchingTags = function(fieldName,func,funcMeta) {
	var _g = 0, _g1 = massive.munit.TestClassHelper.META_TAGS;
	while(_g < _g1.length) {
		var tag = _g1[_g];
		++_g;
		if(Reflect.hasField(funcMeta,tag)) {
			var args = Reflect.field(funcMeta,tag);
			var description = args != null?args[0]:"";
			var isAsync = args != null && description == "Async";
			var isIgnored = Reflect.hasField(funcMeta,"Ignore");
			if(isAsync) description = ""; else if(isIgnored) {
				args = Reflect.field(funcMeta,"Ignore");
				description = args != null?args[0]:"";
			}
			switch(tag) {
			case "BeforeClass":
				this.beforeClass = func;
				break;
			case "AfterClass":
				this.afterClass = func;
				break;
			case "Before":
				this.before = func;
				break;
			case "After":
				this.after = func;
				break;
			case "AsyncTest":
				if(!this.isDebug) this.addTest(fieldName,func,this.test,true,isIgnored,description);
				break;
			case "Test":
				if(!this.isDebug) this.addTest(fieldName,func,this.test,isAsync,isIgnored,description);
				break;
			case "TestDebug":
				if(this.isDebug) this.addTest(fieldName,func,this.test,isAsync,isIgnored,description);
				break;
			}
		}
	}
}
massive.munit.TestClassHelper.prototype.addTest = function(field,testFunction,testInstance,isAsync,isIgnored,description) {
	var result = new massive.munit.TestResult();
	result.async = isAsync;
	result.ignore = isIgnored;
	result.className = this.className;
	result.description = description;
	result.name = field;
	var data = { test : testFunction, scope : testInstance, result : result};
	this.tests.push(data);
}
massive.munit.TestClassHelper.prototype.sortTestsByName = function(x,y) {
	if(x.result.name == y.result.name) return 0;
	if(x.result.name > y.result.name) return 1; else return -1;
}
massive.munit.TestClassHelper.prototype.nullFunc = function() {
}
massive.munit.TestClassHelper.prototype.__class__ = massive.munit.TestClassHelper;
ValueType = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
Type = function() { }
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	if(o.__enum__ != null) return null;
	return o.__class__;
}
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl;
	try {
		cl = eval(name);
	} catch( e ) {
		cl = null;
	}
	if(cl == null || cl.__name__ == null) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e;
	try {
		e = eval(name);
	} catch( err ) {
		e = null;
	}
	if(e == null || e.__ename__ == null) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	if(args.length <= 3) return new cl(args[0],args[1],args[2]);
	if(args.length > 8) throw "Too many arguments";
	return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
}
Type.createEmptyInstance = function(cl) {
	return new cl($_);
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.createEnumIndex = function(e,index,params) {
	var c = e.__constructs__[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = Reflect.fields(c.prototype);
	a.remove("__class__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	a.remove("__name__");
	a.remove("__interfaces__");
	a.remove("__super__");
	a.remove("prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.copy();
}
Type["typeof"] = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ != null) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		var _g1 = 2, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!Type.enumEq(a[i],b[i])) return false;
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	} catch( e ) {
		return false;
	}
	return true;
}
Type.enumConstructor = function(e) {
	return e[0];
}
Type.enumParameters = function(e) {
	return e.slice(2);
}
Type.enumIndex = function(e) {
	return e[1];
}
Type.prototype.__class__ = Type;
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
	if(d != null) d.innerHTML = "";
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
massive.munit.UnhandledException = function(source,testLocation) {
	if( source === $_ ) return;
	massive.munit.MUnitException.call(this,source.toString() + this.formatLocation(source,testLocation),null);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "UnhandledException.hx", lineNumber : 48, className : "massive.munit.UnhandledException", methodName : "new"}).className;
}
massive.munit.UnhandledException.__name__ = ["massive","munit","UnhandledException"];
massive.munit.UnhandledException.__super__ = massive.munit.MUnitException;
for(var k in massive.munit.MUnitException.prototype ) massive.munit.UnhandledException.prototype[k] = massive.munit.MUnitException.prototype[k];
massive.munit.UnhandledException.prototype.formatLocation = function(source,testLocation) {
	var stackTrace = this.getStackTrace(source);
	if(stackTrace == "") stackTrace = " at " + testLocation; else stackTrace = " " + stackTrace.substr(1);
	return stackTrace;
}
massive.munit.UnhandledException.prototype.getStackTrace = function(source) {
	var s = "";
	if(s == "") {
		var stack = haxe.Stack.exceptionStack();
		while(stack.length > 0) {
			var $e = (stack.shift());
			switch( $e[1] ) {
			case 2:
				var line = $e[4], file = $e[3], item = $e[2];
				s += "\tat " + file + " (" + line + ")\n";
				break;
			case 1:
				var module = $e[2];
				break;
			case 3:
				var method = $e[3], classname = $e[2];
				s += "\tat " + classname + "#" + method + "\n";
				break;
			case 4:
				var v = $e[2];
				break;
			case 0:
				break;
			}
		}
	}
	return s;
}
massive.munit.UnhandledException.prototype.__class__ = massive.munit.UnhandledException;
StringBuf = function(p) {
	if( p === $_ ) return;
	this.b = new Array();
}
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype.add = function(x) {
	this.b[this.b.length] = x == null?"null":x;
}
StringBuf.prototype.addSub = function(s,pos,len) {
	this.b[this.b.length] = s.substr(pos,len);
}
StringBuf.prototype.addChar = function(c) {
	this.b[this.b.length] = String.fromCharCode(c);
}
StringBuf.prototype.toString = function() {
	return this.b.join("");
}
StringBuf.prototype.b = null;
StringBuf.prototype.__class__ = StringBuf;
massive.munit.Assert = function() { }
massive.munit.Assert.__name__ = ["massive","munit","Assert"];
massive.munit.Assert.isTrue = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(value != true) massive.munit.Assert.fail("Expected TRUE but was [" + value + "]",info);
}
massive.munit.Assert.isFalse = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(value != false) massive.munit.Assert.fail("Expected FALSE but was [" + value + "]",info);
}
massive.munit.Assert.isNull = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(value != null) massive.munit.Assert.fail("Value [" + value + "] was not NULL",info);
}
massive.munit.Assert.isNotNull = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(value == null) massive.munit.Assert.fail("Value [" + value + "] was NULL",info);
}
massive.munit.Assert.isNaN = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(!Math.isNaN(value)) massive.munit.Assert.fail("Value [" + value + "]  was not NaN",info);
}
massive.munit.Assert.isNotNaN = function(value,info) {
	massive.munit.Assert.assertionCount++;
	if(Math.isNaN(value)) massive.munit.Assert.fail("Value [" + value + "] was NaN",info);
}
massive.munit.Assert.isType = function(value,type) {
	massive.munit.Assert.assertionCount++;
	if(!Std["is"](value,type)) massive.munit.Assert.fail("Value [" + value + "] was not of type: " + Type.getClassName(type),{ fileName : "Assert.hx", lineNumber : 126, className : "massive.munit.Assert", methodName : "isType"});
}
massive.munit.Assert.isNotType = function(value,type) {
	massive.munit.Assert.assertionCount++;
	if(Std["is"](value,type)) massive.munit.Assert.fail("Value [" + value + "] was of type: " + Type.getClassName(type),{ fileName : "Assert.hx", lineNumber : 138, className : "massive.munit.Assert", methodName : "isNotType"});
}
massive.munit.Assert.areEqual = function(expected,actual,info) {
	massive.munit.Assert.assertionCount++;
	if(expected != actual) massive.munit.Assert.fail("Value [" + actual + "] was not equal to expected value [" + expected + "]",info);
}
massive.munit.Assert.areNotEqual = function(expected,actual,info) {
	massive.munit.Assert.assertionCount++;
	if(expected == actual) massive.munit.Assert.fail("Value [" + actual + "] was equal to value [" + expected + "]",info);
}
massive.munit.Assert.fail = function(msg,info) {
	throw new massive.munit.AssertionException(msg,info);
}
massive.munit.Assert.prototype.__class__ = massive.munit.Assert;
Lambda = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.list = function(it) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		l.add(i);
	}
	return l;
}
Lambda.map = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(x));
	}
	return l;
}
Lambda.mapi = function(it,f) {
	var l = new List();
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(i++,x));
	}
	return l;
}
Lambda.has = function(it,elt,cmp) {
	if(cmp == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			if(x == elt) return true;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(cmp(x,elt)) return true;
		}
	}
	return false;
}
Lambda.exists = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
}
Lambda.foreach = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
}
Lambda.iter = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		f(x);
	}
}
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
}
Lambda.fold = function(it,f,first) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
Lambda.empty = function(it) {
	return !it.iterator().hasNext();
}
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
}
Lambda.concat = function(a,b) {
	var l = new List();
	var $it0 = a.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(x);
	}
	var $it1 = b.iterator();
	while( $it1.hasNext() ) {
		var x = $it1.next();
		l.add(x);
	}
	return l;
}
Lambda.prototype.__class__ = Lambda;
ExampleTest = function(p) {
}
ExampleTest.__name__ = ["ExampleTest"];
ExampleTest.prototype.timer = null;
ExampleTest.prototype.beforeClass = function() {
}
ExampleTest.prototype.afterClass = function() {
}
ExampleTest.prototype.setup = function() {
}
ExampleTest.prototype.tearDown = function() {
}
ExampleTest.prototype.testExample = function() {
	massive.munit.Assert.isTrue(true,{ fileName : "ExampleTest.hx", lineNumber : 45, className : "ExampleTest", methodName : "testExample"});
}
ExampleTest.prototype.testAsyncExample = function(factory) {
	var handler = factory.createHandler(this,$closure(this,"onTestAsyncExampleComplete"),300,{ fileName : "ExampleTest.hx", lineNumber : 51, className : "ExampleTest", methodName : "testAsyncExample"});
	this.timer = massive.munit.util.Timer.delay(handler,200);
}
ExampleTest.prototype.onTestAsyncExampleComplete = function() {
	massive.munit.Assert.isFalse(false,{ fileName : "ExampleTest.hx", lineNumber : 57, className : "ExampleTest", methodName : "onTestAsyncExampleComplete"});
}
ExampleTest.prototype.testExampleThatOnlyRunsWithDebugFlag = function() {
	massive.munit.Assert.isTrue(true,{ fileName : "ExampleTest.hx", lineNumber : 67, className : "ExampleTest", methodName : "testExampleThatOnlyRunsWithDebugFlag"});
}
ExampleTest.prototype.__class__ = ExampleTest;
if(!haxe.rtti) haxe.rtti = {}
haxe.rtti.Meta = function() { }
haxe.rtti.Meta.__name__ = ["haxe","rtti","Meta"];
haxe.rtti.Meta.getType = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.obj == null?{ }:meta.obj;
}
haxe.rtti.Meta.getStatics = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.statics == null?{ }:meta.statics;
}
haxe.rtti.Meta.getFields = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.fields == null?{ }:meta.fields;
}
haxe.rtti.Meta.prototype.__class__ = haxe.rtti.Meta;
massive.munit.async.AsyncTimeoutException = function(message,info) {
	if( message === $_ ) return;
	massive.munit.MUnitException.call(this,message,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "AsyncTimeoutException.hx", lineNumber : 47, className : "massive.munit.async.AsyncTimeoutException", methodName : "new"}).className;
}
massive.munit.async.AsyncTimeoutException.__name__ = ["massive","munit","async","AsyncTimeoutException"];
massive.munit.async.AsyncTimeoutException.__super__ = massive.munit.MUnitException;
for(var k in massive.munit.MUnitException.prototype ) massive.munit.async.AsyncTimeoutException.prototype[k] = massive.munit.MUnitException.prototype[k];
massive.munit.async.AsyncTimeoutException.prototype.__class__ = massive.munit.async.AsyncTimeoutException;
massive.munit.ICoverageTestResultClient = function() { }
massive.munit.ICoverageTestResultClient.__name__ = ["massive","munit","ICoverageTestResultClient"];
massive.munit.ICoverageTestResultClient.prototype.setCurrentTestClassCoverage = null;
massive.munit.ICoverageTestResultClient.prototype.reportFinalCoverage = null;
massive.munit.ICoverageTestResultClient.prototype.__class__ = massive.munit.ICoverageTestResultClient;
massive.munit.ICoverageTestResultClient.__interfaces__ = [massive.munit.IAdvancedTestResultClient];
massive.munit.client.AbstractTestResultClient = function(p) {
	if( p === $_ ) return;
	this.init();
}
massive.munit.client.AbstractTestResultClient.__name__ = ["massive","munit","client","AbstractTestResultClient"];
massive.munit.client.AbstractTestResultClient.prototype.id = null;
massive.munit.client.AbstractTestResultClient.prototype.completionHandler = null;
massive.munit.client.AbstractTestResultClient.prototype.get_completeHandler = function() {
	return this.completionHandler;
}
massive.munit.client.AbstractTestResultClient.prototype.set_completeHandler = function(value) {
	return this.completionHandler = value;
}
massive.munit.client.AbstractTestResultClient.prototype.output = null;
massive.munit.client.AbstractTestResultClient.prototype.get_output = function() {
	return this.output;
}
massive.munit.client.AbstractTestResultClient.prototype.passCount = null;
massive.munit.client.AbstractTestResultClient.prototype.failCount = null;
massive.munit.client.AbstractTestResultClient.prototype.errorCount = null;
massive.munit.client.AbstractTestResultClient.prototype.ignoreCount = null;
massive.munit.client.AbstractTestResultClient.prototype.currentTestClass = null;
massive.munit.client.AbstractTestResultClient.prototype.currentClassResults = null;
massive.munit.client.AbstractTestResultClient.prototype.currentCoverageResult = null;
massive.munit.client.AbstractTestResultClient.prototype.traces = null;
massive.munit.client.AbstractTestResultClient.prototype.totalResults = null;
massive.munit.client.AbstractTestResultClient.prototype.totalCoveragePercent = null;
massive.munit.client.AbstractTestResultClient.prototype.totalCoverageReport = null;
massive.munit.client.AbstractTestResultClient.prototype.totalCoverageResults = null;
massive.munit.client.AbstractTestResultClient.prototype.originalTrace = null;
massive.munit.client.AbstractTestResultClient.prototype.finalResult = null;
massive.munit.client.AbstractTestResultClient.prototype.init = function() {
	this.originalTrace = haxe.Log.trace;
	haxe.Log.trace = $closure(this,"customTrace");
	this.currentTestClass = null;
	this.currentClassResults = [];
	this.traces = [];
	this.passCount = 0;
	this.failCount = 0;
	this.errorCount = 0;
	this.ignoreCount = 0;
	this.currentCoverageResult = null;
	this.totalResults = [];
	this.totalCoveragePercent = 0;
	this.totalCoverageReport = null;
	this.totalCoverageResults = null;
}
massive.munit.client.AbstractTestResultClient.prototype.setCurrentTestClass = function(className) {
	if(this.currentTestClass == className) return;
	if(this.currentTestClass != null) this.finalizeTestClass();
	this.currentTestClass = className;
	if(this.currentTestClass != null) this.initializeTestClass();
}
massive.munit.client.AbstractTestResultClient.prototype.addPass = function(result) {
	this.passCount++;
	this.updateTestClass(result);
}
massive.munit.client.AbstractTestResultClient.prototype.addFail = function(result) {
	this.failCount++;
	this.updateTestClass(result);
}
massive.munit.client.AbstractTestResultClient.prototype.addError = function(result) {
	this.errorCount++;
	this.updateTestClass(result);
}
massive.munit.client.AbstractTestResultClient.prototype.addIgnore = function(result) {
	this.ignoreCount++;
	this.updateTestClass(result);
}
massive.munit.client.AbstractTestResultClient.prototype.setCurrentTestClassCoverage = function(result) {
	this.currentCoverageResult = result;
}
massive.munit.client.AbstractTestResultClient.prototype.reportFinalCoverage = function(percent,missingCoverageResults,summary,classBreakdown,packageBreakdown,executionFrequency) {
	if(percent == null) percent = 0;
	this.totalCoveragePercent = percent;
	this.totalCoverageResults = missingCoverageResults;
	this.totalCoverageReport = summary;
}
massive.munit.client.AbstractTestResultClient.prototype.reportFinalStatistics = function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
	this.finalResult = passCount == testCount;
	this.printReports();
	this.printFinalStatistics(this.finalResult,testCount,passCount,failCount,errorCount,ignoreCount,time);
	this.printOverallResult(this.finalResult);
	haxe.Log.trace = this.originalTrace;
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
	return this.get_output();
}
massive.munit.client.AbstractTestResultClient.prototype.initializeTestClass = function() {
	this.currentClassResults = [];
	this.traces = [];
	this.passCount = 0;
	this.failCount = 0;
	this.errorCount = 0;
	this.ignoreCount = 0;
}
massive.munit.client.AbstractTestResultClient.prototype.updateTestClass = function(result) {
	this.currentClassResults.push(result);
	this.totalResults.push(result);
}
massive.munit.client.AbstractTestResultClient.prototype.finalizeTestClass = function() {
	this.currentClassResults.sort($closure(this,"sortTestResults"));
}
massive.munit.client.AbstractTestResultClient.prototype.printReports = function() {
}
massive.munit.client.AbstractTestResultClient.prototype.printFinalStatistics = function(result,testCount,passCount,failCount,errorCount,ignoreCount,time) {
}
massive.munit.client.AbstractTestResultClient.prototype.printOverallResult = function(result) {
}
massive.munit.client.AbstractTestResultClient.prototype.customTrace = function(value,info) {
	var traceString = info.fileName + "|" + info.lineNumber + "| " + Std.string(value);
	this.traces.push(traceString);
}
massive.munit.client.AbstractTestResultClient.prototype.sortTestResults = function(a,b) {
	var aInt = (function($this) {
		var $r;
		switch( (a.get_type())[1] ) {
		case 3:
			$r = 2;
			break;
		case 2:
			$r = 1;
			break;
		case 4:
			$r = 0;
			break;
		case 1:
			$r = -1;
			break;
		default:
			$r = -2;
		}
		return $r;
	}(this));
	var bInt = (function($this) {
		var $r;
		switch( (b.get_type())[1] ) {
		case 3:
			$r = 2;
			break;
		case 2:
			$r = 1;
			break;
		case 4:
			$r = 0;
			break;
		case 1:
			$r = -1;
			break;
		default:
			$r = -2;
		}
		return $r;
	}(this));
	return aInt - bInt;
}
massive.munit.client.AbstractTestResultClient.prototype.__class__ = massive.munit.client.AbstractTestResultClient;
massive.munit.client.AbstractTestResultClient.__interfaces__ = [massive.munit.ICoverageTestResultClient,massive.munit.IAdvancedTestResultClient];
massive.munit.client.PrintClientBase = function(includeIgnoredReport) {
	if( includeIgnoredReport === $_ ) return;
	if(includeIgnoredReport == null) includeIgnoredReport = true;
	massive.munit.client.AbstractTestResultClient.call(this);
	this.id = "simple";
	this.verbose = false;
	this.includeIgnoredReport = includeIgnoredReport;
	this.printLine("MUnit Results");
	this.printLine(this.divider);
}
massive.munit.client.PrintClientBase.__name__ = ["massive","munit","client","PrintClientBase"];
massive.munit.client.PrintClientBase.__super__ = massive.munit.client.AbstractTestResultClient;
for(var k in massive.munit.client.AbstractTestResultClient.prototype ) massive.munit.client.PrintClientBase.prototype[k] = massive.munit.client.AbstractTestResultClient.prototype[k];
massive.munit.client.PrintClientBase.prototype.verbose = null;
massive.munit.client.PrintClientBase.prototype.includeIgnoredReport = null;
massive.munit.client.PrintClientBase.prototype.divider = null;
massive.munit.client.PrintClientBase.prototype.divider2 = null;
massive.munit.client.PrintClientBase.prototype.init = function() {
	massive.munit.client.AbstractTestResultClient.prototype.init.call(this);
	this.divider = "------------------------------";
	this.divider2 = "==============================";
}
massive.munit.client.PrintClientBase.prototype.initializeTestClass = function() {
	massive.munit.client.AbstractTestResultClient.prototype.initializeTestClass.call(this);
	this.printLine("Class: " + this.currentTestClass + " ");
}
massive.munit.client.PrintClientBase.prototype.updateTestClass = function(result) {
	massive.munit.client.AbstractTestResultClient.prototype.updateTestClass.call(this,result);
	if(this.verbose) this.printLine(" " + result.name + ": " + result.get_type() + " "); else {
		switch( (result.get_type())[1] ) {
		case 1:
			this.print(".");
			break;
		case 2:
			this.print("!");
			break;
		case 3:
			this.print("x");
			break;
		case 4:
			this.print(",");
			break;
		case 0:
			null;
			break;
		}
	}
}
massive.munit.client.PrintClientBase.prototype.finalizeTestClass = function() {
	massive.munit.client.AbstractTestResultClient.prototype.finalizeTestClass.call(this);
	var _g = 0, _g1 = this.traces;
	while(_g < _g1.length) {
		var item = _g1[_g];
		++_g;
		this.printLine("TRACE: " + item,1);
	}
	var _g = 0, _g1 = this.currentClassResults;
	while(_g < _g1.length) {
		var result = _g1[_g];
		++_g;
		switch( (result.get_type())[1] ) {
		case 3:
			this.printLine("ERROR: " + Std.string(result.error),1);
			break;
		case 2:
			this.printLine("FAIL: " + Std.string(result.failure),1);
			break;
		case 4:
			var ingoredString = result.get_location();
			if(result.description != null) ingoredString += " - " + result.description;
			this.printLine("IGNORE: " + ingoredString,1);
			break;
		case 1:
		case 0:
			null;
			break;
		}
	}
}
massive.munit.client.PrintClientBase.prototype.setCurrentTestClassCoverage = function(result) {
	massive.munit.client.AbstractTestResultClient.prototype.setCurrentTestClassCoverage.call(this,result);
	this.print(" [" + result.percent + "%]");
}
massive.munit.client.PrintClientBase.prototype.reportFinalCoverage = function(percent,missingCoverageResults,summary,classBreakdown,packageBreakdown,executionFrequency) {
	if(percent == null) percent = 0;
	massive.munit.client.AbstractTestResultClient.prototype.reportFinalCoverage.call(this,percent,missingCoverageResults,summary,classBreakdown,packageBreakdown,executionFrequency);
	this.printLine("");
	this.printLine(this.divider);
	this.printLine("COVERAGE REPORT");
	this.printLine(this.divider);
	if(missingCoverageResults != null && missingCoverageResults.length > 0) {
		this.printLine("MISSING CODE BLOCKS:");
		var _g = 0;
		while(_g < missingCoverageResults.length) {
			var result = missingCoverageResults[_g];
			++_g;
			this.printLine(result.className + " [" + result.percent + "%]",1);
			var _g1 = 0, _g2 = result.blocks;
			while(_g1 < _g2.length) {
				var item = _g2[_g1];
				++_g1;
				this.printIndentedLines(item,2);
			}
			this.printLine("");
		}
	}
	if(executionFrequency != null) {
		this.printLine("CODE EXECUTION FREQUENCY:");
		this.printIndentedLines(executionFrequency,1);
		this.printLine("");
	}
	if(classBreakdown != null) this.printIndentedLines(classBreakdown,0);
	if(packageBreakdown != null) this.printIndentedLines(packageBreakdown,0);
	if(summary != null) this.printIndentedLines(summary,0);
}
massive.munit.client.PrintClientBase.prototype.printIndentedLines = function(value,indent) {
	if(indent == null) indent = 1;
	var lines = value.split("\n");
	var _g = 0;
	while(_g < lines.length) {
		var line = lines[_g];
		++_g;
		this.printLine(line,indent);
	}
}
massive.munit.client.PrintClientBase.prototype.printReports = function() {
	this.printFinalIgnoredStatistics(this.ignoreCount);
}
massive.munit.client.PrintClientBase.prototype.printFinalIgnoredStatistics = function(count) {
	if(!this.includeIgnoredReport || count == 0) return;
	var items = Lambda.filter(this.totalResults,$closure(this,"filterIngored"));
	if(items.length == 0) return;
	this.printLine("");
	this.printLine("Ignored (" + count + "):");
	this.printLine(this.divider);
	var $it0 = items.iterator();
	while( $it0.hasNext() ) {
		var result = $it0.next();
		var ingoredString = result.get_location();
		if(result.description != null) ingoredString += " - " + result.description;
		this.printLine("IGNORE: " + ingoredString,1);
	}
	this.printLine("");
}
massive.munit.client.PrintClientBase.prototype.filterIngored = function(result) {
	return result.get_type() == massive.munit.TestResultType.IGNORE;
}
massive.munit.client.PrintClientBase.prototype.printFinalStatistics = function(result,testCount,passCount,failCount,errorCount,ignoreCount,time) {
	this.printLine(this.divider2);
	var resultString = result?"PASSED":"FAILED";
	resultString += "\n" + "Tests: " + testCount + "  Passed: " + passCount + "  Failed: " + failCount + " Errors: " + errorCount + " Ignored: " + ignoreCount + " Time: " + massive.munit.util.MathUtil.round(time,5);
	this.printLine(resultString);
	this.printLine("");
}
massive.munit.client.PrintClientBase.prototype.printOverallResult = function(result) {
	this.printLine("");
}
massive.munit.client.PrintClientBase.prototype.print = function(value) {
	this.output += Std.string(value);
}
massive.munit.client.PrintClientBase.prototype.printLine = function(value,indent) {
	if(indent == null) indent = 0;
	value = Std.string(value);
	value = this.indentString(value,indent);
	this.print("\n" + value);
}
massive.munit.client.PrintClientBase.prototype.indentString = function(value,indent) {
	if(indent == null) indent = 0;
	if(indent > 0) value = StringTools.lpad(""," ",indent * 4) + value;
	if(value == "") value = "";
	return value;
}
massive.munit.client.PrintClientBase.prototype.__class__ = massive.munit.client.PrintClientBase;
massive.munit.client.PrintClient = function(includeIgnoredReport) {
	if( includeIgnoredReport === $_ ) return;
	if(includeIgnoredReport == null) includeIgnoredReport = true;
	massive.munit.client.PrintClientBase.call(this,includeIgnoredReport);
	this.id = "print";
}
massive.munit.client.PrintClient.__name__ = ["massive","munit","client","PrintClient"];
massive.munit.client.PrintClient.__super__ = massive.munit.client.PrintClientBase;
for(var k in massive.munit.client.PrintClientBase.prototype ) massive.munit.client.PrintClient.prototype[k] = massive.munit.client.PrintClientBase.prototype[k];
massive.munit.client.PrintClient.prototype.external = null;
massive.munit.client.PrintClient.prototype.textArea = null;
massive.munit.client.PrintClient.prototype.init = function() {
	massive.munit.client.PrintClientBase.prototype.init.call(this);
	this.external = new massive.munit.client.ExternalPrintClientJS();
	this.initJS();
}
massive.munit.client.PrintClient.prototype.initJS = function() {
	var div = js.Lib.document.getElementById("haxe:trace");
	if(div == null) {
		var positionInfo = massive.haxe.util.ReflectUtil.here({ fileName : "PrintClient.hx", lineNumber : 124, className : "massive.munit.client.PrintClient", methodName : "initJS"});
		var error = "MissingElementException: 'haxe:trace' element not found at " + positionInfo.className + "#" + positionInfo.methodName + "(" + positionInfo.lineNumber + ")";
		js.Lib.alert(error);
	}
}
massive.munit.client.PrintClient.prototype.printOverallResult = function(result) {
	massive.munit.client.PrintClientBase.prototype.printOverallResult.call(this,result);
	this.external.setResult(result);
	this.external.setResultBackground(result);
}
massive.munit.client.PrintClient.prototype.reportFinalStatistics = function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
	massive.munit.client.PrintClientBase.prototype.reportFinalStatistics.call(this,testCount,passCount,failCount,errorCount,ignoreCount,time);
}
massive.munit.client.PrintClient.prototype.print = function(value) {
	massive.munit.client.PrintClientBase.prototype.print.call(this,value);
	this.external.print(value);
}
massive.munit.client.PrintClient.prototype.printLine = function(value,indent) {
	if(indent == null) indent = 0;
	massive.munit.client.PrintClientBase.prototype.printLine.call(this,value,indent);
}
massive.munit.client.PrintClient.prototype.__class__ = massive.munit.client.PrintClient;
massive.munit.client.RichPrintClient = function(p) {
	if( p === $_ ) return;
	massive.munit.client.PrintClientBase.call(this);
	this.id = "RichPrintClient";
}
massive.munit.client.RichPrintClient.__name__ = ["massive","munit","client","RichPrintClient"];
massive.munit.client.RichPrintClient.__super__ = massive.munit.client.PrintClientBase;
for(var k in massive.munit.client.PrintClientBase.prototype ) massive.munit.client.RichPrintClient.prototype[k] = massive.munit.client.PrintClientBase.prototype[k];
massive.munit.client.RichPrintClient.prototype.testClassResultType = null;
massive.munit.client.RichPrintClient.prototype.external = null;
massive.munit.client.RichPrintClient.prototype.init = function() {
	massive.munit.client.PrintClientBase.prototype.init.call(this);
	this.external = new massive.munit.client.ExternalPrintClientJS();
}
massive.munit.client.RichPrintClient.prototype.initializeTestClass = function() {
	massive.munit.client.PrintClientBase.prototype.initializeTestClass.call(this);
	this.external.createTestClass(this.currentTestClass);
	this.external.printToTestClassSummary("Class: " + this.currentTestClass + " ");
}
massive.munit.client.RichPrintClient.prototype.updateTestClass = function(result) {
	massive.munit.client.PrintClientBase.prototype.updateTestClass.call(this,result);
	var value = this.serializeTestResult(result);
	switch( (result.get_type())[1] ) {
	case 1:
		this.external.printToTestClassSummary(".");
		this.external.addTestPass(value);
		break;
	case 2:
		this.external.printToTestClassSummary("!");
		this.external.addTestFail(value);
		break;
	case 3:
		this.external.printToTestClassSummary("x");
		this.external.addTestError(value);
		break;
	case 4:
		this.external.printToTestClassSummary(",");
		this.external.addTestIgnore(value);
		break;
	case 0:
		null;
		break;
	}
}
massive.munit.client.RichPrintClient.prototype.serializeTestResult = function(result) {
	var summary = result.name;
	if(result.description != null && result.description != "") summary += " - " + result.description + " -";
	summary += " (" + massive.munit.util.MathUtil.round(result.executionTime,4) + "s)";
	var str = null;
	if(result.error != null) str = "Error: " + summary + "\n" + Std.string(result.error); else if(result.failure != null) str = "Failure: " + summary + "\n" + Std.string(result.failure); else if(result.ignore) str = "Ignore: " + summary; else if(result.passed) {
	}
	return str;
}
massive.munit.client.RichPrintClient.prototype.finalizeTestClass = function() {
	massive.munit.client.PrintClientBase.prototype.finalizeTestClass.call(this);
	this.testClassResultType = this.getTestClassResultType();
	var code = (function($this) {
		var $r;
		switch( ($this.testClassResultType)[1] ) {
		case 1:
			$r = 0;
			break;
		case 2:
			$r = 1;
			break;
		case 3:
			$r = 2;
			break;
		case 4:
			$r = 3;
			break;
		default:
			$r = -1;
		}
		return $r;
	}(this));
	if(code == -1) return;
	this.external.setTestClassResult(code);
}
massive.munit.client.RichPrintClient.prototype.getTestClassResultType = function() {
	if(this.errorCount > 0) return massive.munit.TestResultType.ERROR; else if(this.failCount > 0) return massive.munit.TestResultType.FAIL; else if(this.ignoreCount > 0) return massive.munit.TestResultType.IGNORE; else return massive.munit.TestResultType.PASS;
}
massive.munit.client.RichPrintClient.prototype.setCurrentTestClassCoverage = function(result) {
	massive.munit.client.PrintClientBase.prototype.setCurrentTestClassCoverage.call(this,result);
	this.external.printToTestClassSummary(" [" + result.percent + "%]");
	if(result.percent == 100) return;
	this.external.addTestClassCoverage(result.className,result.percent);
	var _g = 0, _g1 = result.blocks;
	while(_g < _g1.length) {
		var item = _g1[_g];
		++_g;
		this.external.addTestClassCoverageItem(item);
	}
}
massive.munit.client.RichPrintClient.prototype.reportFinalCoverage = function(percent,missingCoverageResults,summary,classBreakdown,packageBreakdown,executionFrequency) {
	if(percent == null) percent = 0;
	massive.munit.client.PrintClientBase.prototype.reportFinalCoverage.call(this,percent,missingCoverageResults,summary,classBreakdown,packageBreakdown,executionFrequency);
	this.external.createCoverageReport(percent);
	this.printMissingCoverage(missingCoverageResults);
	if(executionFrequency != null) this.external.addCoverageReportSection("Code Execution Frequency",this.trim(executionFrequency));
	if(classBreakdown != null) this.external.addCoverageReportSection("Class Breakdown",this.trim(classBreakdown));
	if(packageBreakdown != null) this.external.addCoverageReportSection("Package Breakdown",this.trim(packageBreakdown));
	if(packageBreakdown != null) this.external.addCoverageReportSection("Summary",this.trim(summary));
}
massive.munit.client.RichPrintClient.prototype.trim = function(output) {
	while(output.indexOf("\n") == 0) output = output.substr(1);
	while(output.lastIndexOf("\n") == output.length - 2) output = output.substr(0,output.length - 2);
	return output;
}
massive.munit.client.RichPrintClient.prototype.printMissingCoverage = function(missingCoverageResults) {
	if(missingCoverageResults == null || missingCoverageResults.length == 0) return;
	var _g = 0;
	while(_g < missingCoverageResults.length) {
		var result = missingCoverageResults[_g];
		++_g;
		this.external.addMissingCoverageClass(result.className,result.percent);
		var _g1 = 0, _g2 = result.blocks;
		while(_g1 < _g2.length) {
			var item = _g2[_g1];
			++_g1;
			this.external.addTestClassCoverageItem(item);
		}
	}
}
massive.munit.client.RichPrintClient.prototype.printReports = function() {
	massive.munit.client.PrintClientBase.prototype.printReports.call(this);
}
massive.munit.client.RichPrintClient.prototype.printFinalStatistics = function(result,testCount,passCount,failCount,errorCount,ignoreCount,time) {
	massive.munit.client.PrintClientBase.prototype.printFinalStatistics.call(this,result,testCount,passCount,failCount,errorCount,ignoreCount,time);
	var resultString = result?"PASSED":"FAILED";
	resultString += "\n" + "Tests: " + testCount + "  Passed: " + passCount + "  Failed: " + failCount + " Errors: " + errorCount + " Ignored: " + ignoreCount + " Time: " + massive.munit.util.MathUtil.round(time,5);
	this.external.printSummary(resultString);
}
massive.munit.client.RichPrintClient.prototype.printOverallResult = function(result) {
	massive.munit.client.PrintClientBase.prototype.printOverallResult.call(this,result);
	this.external.setResult(result);
}
massive.munit.client.RichPrintClient.prototype.customTrace = function(value,info) {
	massive.munit.client.PrintClientBase.prototype.customTrace.call(this,value,info);
	var t = this.traces[this.traces.length - 1];
	this.external.trace(t);
}
massive.munit.client.RichPrintClient.prototype.print = function(value) {
	massive.munit.client.PrintClientBase.prototype.print.call(this,value);
	return;
}
massive.munit.client.RichPrintClient.prototype.printLine = function(value,indent) {
	if(indent == null) indent = 0;
	massive.munit.client.PrintClientBase.prototype.printLine.call(this,value,indent);
}
massive.munit.client.RichPrintClient.prototype.__class__ = massive.munit.client.RichPrintClient;
massive.munit.client.ExternalPrintClient = function() { }
massive.munit.client.ExternalPrintClient.__name__ = ["massive","munit","client","ExternalPrintClient"];
massive.munit.client.ExternalPrintClient.prototype.queue = null;
massive.munit.client.ExternalPrintClient.prototype.setResult = null;
massive.munit.client.ExternalPrintClient.prototype.print = null;
massive.munit.client.ExternalPrintClient.prototype.printLine = null;
massive.munit.client.ExternalPrintClient.prototype.setResultBackground = null;
massive.munit.client.ExternalPrintClient.prototype.createTestClass = null;
massive.munit.client.ExternalPrintClient.prototype.printToTestClassSummary = null;
massive.munit.client.ExternalPrintClient.prototype.setTestClassResult = null;
massive.munit.client.ExternalPrintClient.prototype.trace = null;
massive.munit.client.ExternalPrintClient.prototype.addTestPass = null;
massive.munit.client.ExternalPrintClient.prototype.addTestFail = null;
massive.munit.client.ExternalPrintClient.prototype.addTestError = null;
massive.munit.client.ExternalPrintClient.prototype.addTestIgnore = null;
massive.munit.client.ExternalPrintClient.prototype.addTestClassCoverage = null;
massive.munit.client.ExternalPrintClient.prototype.addTestClassCoverageItem = null;
massive.munit.client.ExternalPrintClient.prototype.createCoverageReport = null;
massive.munit.client.ExternalPrintClient.prototype.addMissingCoverageClass = null;
massive.munit.client.ExternalPrintClient.prototype.addCoverageReportSection = null;
massive.munit.client.ExternalPrintClient.prototype.addCoverageSummary = null;
massive.munit.client.ExternalPrintClient.prototype.printSummary = null;
massive.munit.client.ExternalPrintClient.prototype.__class__ = massive.munit.client.ExternalPrintClient;
massive.munit.client.ExternalPrintClientJS = function(p) {
	if( p === $_ ) return;
	var div = js.Lib.document.getElementById("haxe:trace");
	if(div == null) {
		var positionInfo = massive.haxe.util.ReflectUtil.here({ fileName : "PrintClientBase.hx", lineNumber : 341, className : "massive.munit.client.ExternalPrintClientJS", methodName : "new"});
		var error = "MissingElementException: 'haxe:trace' element not found at " + positionInfo.className + "#" + positionInfo.methodName + "(" + positionInfo.lineNumber + ")";
		js.Lib.alert(error);
	}
}
massive.munit.client.ExternalPrintClientJS.__name__ = ["massive","munit","client","ExternalPrintClientJS"];
massive.munit.client.ExternalPrintClientJS.prototype.print = function(value) {
	this.queue("munitPrint",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.printLine = function(value) {
	this.queue("munitPrintLine",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.setResult = function(value) {
	this.queue("setResult",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.setResultBackground = function(value) {
	this.queue("setResultBackground",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.trace = function(value) {
	this.queue("munitTrace",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.createTestClass = function(className) {
	this.queue("createTestClass",className);
}
massive.munit.client.ExternalPrintClientJS.prototype.printToTestClassSummary = function(value) {
	this.queue("updateTestSummary",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.setTestClassResult = function(resultType) {
	this.queue("setTestClassResult",resultType);
}
massive.munit.client.ExternalPrintClientJS.prototype.addTestPass = function(value) {
	if(value == null) return;
	this.queue("addTestPass",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.addTestFail = function(value) {
	this.queue("addTestFail",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.addTestError = function(value) {
	this.queue("addTestError",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.addTestIgnore = function(value) {
	this.queue("addTestIgnore",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.addTestClassCoverage = function(className,percent) {
	if(percent == null) percent = 0;
	this.queue("addTestCoverageClass",[className,percent]);
}
massive.munit.client.ExternalPrintClientJS.prototype.addTestClassCoverageItem = function(value) {
	this.queue("addTestCoverageItem",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.createCoverageReport = function(percent) {
	if(percent == null) percent = 0;
	this.queue("createCoverageReport",percent);
}
massive.munit.client.ExternalPrintClientJS.prototype.addMissingCoverageClass = function(className,percent) {
	if(percent == null) percent = 0;
	this.queue("addMissingCoverageClass",[className,percent]);
}
massive.munit.client.ExternalPrintClientJS.prototype.addCoverageReportSection = function(name,value) {
	this.queue("addCoverageReportSection",[name,value]);
}
massive.munit.client.ExternalPrintClientJS.prototype.addCoverageSummary = function(value) {
	this.queue("addCoverageSummary",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.printSummary = function(value) {
	this.queue("printSummary",value);
}
massive.munit.client.ExternalPrintClientJS.prototype.queue = function(method,args) {
	var a = [];
	if(Std["is"](args,Array)) a = a.concat((function($this) {
		var $r;
		var $t = args;
		if(Std["is"]($t,Array)) $t; else throw "Class cast error";
		$r = $t;
		return $r;
	}(this))); else a.push(args);
	var jsCode = this.convertToJavaScript(method,a);
	return js.Lib.eval(jsCode);
	return false;
}
massive.munit.client.ExternalPrintClientJS.prototype.convertToJavaScript = function(method,args) {
	var htmlArgs = [];
	var _g = 0;
	while(_g < args.length) {
		var arg = args[_g];
		++_g;
		var html = this.serialiseToHTML(Std.string(arg));
		htmlArgs.push(html);
	}
	var jsCode;
	if(htmlArgs == null || htmlArgs.length == 0) jsCode = "addToQueue(\"" + method + "\")"; else {
		jsCode = "addToQueue(\"" + method + "\"";
		var _g = 0;
		while(_g < htmlArgs.length) {
			var arg = htmlArgs[_g];
			++_g;
			jsCode += ",\"" + arg + "\"";
		}
		jsCode += ")";
	}
	return jsCode;
}
massive.munit.client.ExternalPrintClientJS.prototype.serialiseToHTML = function(value) {
	value = js.Boot.__string_rec(value,"");
	var v = StringTools.htmlEscape(value);
	v = v.split("\n").join("<br/>");
	v = v.split(" ").join("&nbsp;");
	v = v.split("\"").join("\\'");
	return v;
}
massive.munit.client.ExternalPrintClientJS.prototype.__class__ = massive.munit.client.ExternalPrintClientJS;
massive.munit.client.ExternalPrintClientJS.__interfaces__ = [massive.munit.client.ExternalPrintClient];
haxe.Log = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype.__class__ = haxe.Log;
Hash = function(p) {
	if( p === $_ ) return;
	this.h = {}
	if(this.h.__proto__ != null) {
		this.h.__proto__ = null;
		delete(this.h.__proto__);
	}
}
Hash.__name__ = ["Hash"];
Hash.prototype.h = null;
Hash.prototype.set = function(key,value) {
	this.h["$" + key] = value;
}
Hash.prototype.get = function(key) {
	return this.h["$" + key];
}
Hash.prototype.exists = function(key) {
	try {
		key = "$" + key;
		return this.hasOwnProperty.call(this.h,key);
	} catch( e ) {
		for(var i in this.h) if( i == key ) return true;
		return false;
	}
}
Hash.prototype.remove = function(key) {
	if(!this.exists(key)) return false;
	delete(this.h["$" + key]);
	return true;
}
Hash.prototype.keys = function() {
	var a = new Array();
	for(var i in this.h) a.push(i.substr(1));
	return a.iterator();
}
Hash.prototype.iterator = function() {
	return { ref : this.h, it : this.keys(), hasNext : function() {
		return this.it.hasNext();
	}, next : function() {
		var i = this.it.next();
		return this.ref["$" + i];
	}};
}
Hash.prototype.toString = function() {
	var s = new StringBuf();
	s.b[s.b.length] = "{" == null?"null":"{";
	var it = this.keys();
	while( it.hasNext() ) {
		var i = it.next();
		s.b[s.b.length] = i == null?"null":i;
		s.b[s.b.length] = " => " == null?"null":" => ";
		s.add(Std.string(this.get(i)));
		if(it.hasNext()) s.b[s.b.length] = ", " == null?"null":", ";
	}
	s.b[s.b.length] = "}" == null?"null":"}";
	return s.b.join("");
}
Hash.prototype.__class__ = Hash;
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
if(typeof v042=='undefined') v042 = {}
v042.EaselJsTest = function(p) {
}
v042.EaselJsTest.__name__ = ["v042","EaselJsTest"];
v042.EaselJsTest.prototype.timer = null;
v042.EaselJsTest.prototype.beforeClass = function() {
}
v042.EaselJsTest.prototype.afterClass = function() {
}
v042.EaselJsTest.prototype.setup = function() {
}
v042.EaselJsTest.prototype.tearDown = function() {
}
v042.EaselJsTest.prototype.testExample = function() {
	massive.munit.Assert.isTrue(true,{ fileName : "EaselJsTest.hx", lineNumber : 49, className : "v042.EaselJsTest", methodName : "testExample"});
}
v042.EaselJsTest.prototype.testThatCanvasElementWorks = function() {
	var canvas = js.Lib.document.createElement("canvas");
	var ctx = canvas.getContext("2d");
	massive.munit.Assert.isTrue(canvas instanceof HTMLCanvasElement,{ fileName : "EaselJsTest.hx", lineNumber : 58, className : "v042.EaselJsTest", methodName : "testThatCanvasElementWorks"});
	massive.munit.Assert.isTrue(ctx instanceof CanvasRenderingContext2D,{ fileName : "EaselJsTest.hx", lineNumber : 59, className : "v042.EaselJsTest", methodName : "testThatCanvasElementWorks"});
}
v042.EaselJsTest.prototype.testThatDisplayObjectContainsMethodsAndProperties = function() {
	var canvas = js.Lib.document.createElement("canvas");
	var stage = new Stage(canvas);
	var displayObject = new DisplayObject();
	displayObject.name = "myDisplayObject";
	stage.addChild(displayObject);
	this.verifyThatPropertiesExist(displayObject,v042.EaselJsTest.displayObjectProperties,{ fileName : "EaselJsTest.hx", lineNumber : 71, className : "v042.EaselJsTest", methodName : "testThatDisplayObjectContainsMethodsAndProperties"});
	this.verifyThatMethodsExist(displayObject,v042.EaselJsTest.displayObjectMethods,{ fileName : "EaselJsTest.hx", lineNumber : 72, className : "v042.EaselJsTest", methodName : "testThatDisplayObjectContainsMethodsAndProperties"});
}
v042.EaselJsTest.prototype.testThatContainerContainsMethodsAndProperties = function() {
	var canvas = js.Lib.document.createElement("canvas");
	var stage = new Stage(canvas);
	var container = new Container();
	container.name = "myContainer";
	stage.addChild(container);
	this.verifyThatPropertiesExist(container,v042.EaselJsTest.displayObjectProperties,{ fileName : "EaselJsTest.hx", lineNumber : 84, className : "v042.EaselJsTest", methodName : "testThatContainerContainsMethodsAndProperties"});
	this.verifyThatMethodsExist(container,v042.EaselJsTest.displayObjectMethods,{ fileName : "EaselJsTest.hx", lineNumber : 85, className : "v042.EaselJsTest", methodName : "testThatContainerContainsMethodsAndProperties"});
	this.verifyThatPropertiesExist(container,v042.EaselJsTest.containerProperties,{ fileName : "EaselJsTest.hx", lineNumber : 86, className : "v042.EaselJsTest", methodName : "testThatContainerContainsMethodsAndProperties"});
	this.verifyThatMethodsExist(container,v042.EaselJsTest.containerMethods,{ fileName : "EaselJsTest.hx", lineNumber : 87, className : "v042.EaselJsTest", methodName : "testThatContainerContainsMethodsAndProperties"});
}
v042.EaselJsTest.prototype.testThatStageContainsMethodsAndProperties = function() {
	var canvas = js.Lib.document.createElement("canvas");
	var stage = new Stage(canvas);
	var stageProperties = ["canvas","snapToPixelEnabled","autoClear","mouseInBounds","tickOnUpdate"];
	var stageMethods = ["enableMouseOver","clear","toDataURL","update"];
	this.verifyThatMethodsExist(stage,v042.EaselJsTest.displayObjectMethods,{ fileName : "EaselJsTest.hx", lineNumber : 115, className : "v042.EaselJsTest", methodName : "testThatStageContainsMethodsAndProperties"});
	this.verifyThatPropertiesExist(stage,v042.EaselJsTest.containerProperties,{ fileName : "EaselJsTest.hx", lineNumber : 116, className : "v042.EaselJsTest", methodName : "testThatStageContainsMethodsAndProperties"});
	this.verifyThatMethodsExist(stage,v042.EaselJsTest.containerMethods,{ fileName : "EaselJsTest.hx", lineNumber : 117, className : "v042.EaselJsTest", methodName : "testThatStageContainsMethodsAndProperties"});
	this.verifyThatPropertiesExist(stage,stageProperties,{ fileName : "EaselJsTest.hx", lineNumber : 118, className : "v042.EaselJsTest", methodName : "testThatStageContainsMethodsAndProperties"});
	this.verifyThatMethodsExist(stage,stageMethods,{ fileName : "EaselJsTest.hx", lineNumber : 119, className : "v042.EaselJsTest", methodName : "testThatStageContainsMethodsAndProperties"});
}
v042.EaselJsTest.prototype.testAsyncExample = function(factory) {
	var handler = factory.createHandler(this,$closure(this,"onTestAsyncExampleComplete"),300,{ fileName : "EaselJsTest.hx", lineNumber : 125, className : "v042.EaselJsTest", methodName : "testAsyncExample"});
	this.timer = massive.munit.util.Timer.delay(handler,200);
}
v042.EaselJsTest.prototype.onTestAsyncExampleComplete = function() {
	massive.munit.Assert.isFalse(false,{ fileName : "EaselJsTest.hx", lineNumber : 131, className : "v042.EaselJsTest", methodName : "onTestAsyncExampleComplete"});
}
v042.EaselJsTest.prototype.testExampleThatOnlyRunsWithDebugFlag = function() {
	massive.munit.Assert.isTrue(true,{ fileName : "EaselJsTest.hx", lineNumber : 141, className : "v042.EaselJsTest", methodName : "testExampleThatOnlyRunsWithDebugFlag"});
}
v042.EaselJsTest.prototype.verifyThatMethodsExist = function(o,methods,pos) {
	var _g = 0;
	while(_g < methods.length) {
		var method = methods[_g];
		++_g;
		var m = o[method];
		var t = Type["typeof"](m);
		var isMethod = (function($this) {
			var $r;
			switch( (t)[1] ) {
			case 5:
				$r = true;
				break;
			default:
				$r = false;
			}
			return $r;
		}(this));
		if(!isMethod) {
			haxe.Log.trace("Object does not contain method : " + method + ". From line: " + pos.lineNumber,{ fileName : "EaselJsTest.hx", lineNumber : 165, className : "v042.EaselJsTest", methodName : "verifyThatMethodsExist"});
			massive.munit.Assert.isTrue(false,{ fileName : "EaselJsTest.hx", lineNumber : 165, className : "v042.EaselJsTest", methodName : "verifyThatMethodsExist"});
		} else massive.munit.Assert.isTrue(true,{ fileName : "EaselJsTest.hx", lineNumber : 167, className : "v042.EaselJsTest", methodName : "verifyThatMethodsExist"});
	}
}
v042.EaselJsTest.prototype.verifyThatPropertiesExist = function(o,fields,pos) {
	var _g = 0;
	while(_g < fields.length) {
		var field = fields[_g];
		++_g;
		var f = Reflect.field(o,field);
		if(f == null) {
			haxe.Log.trace("Object does not contain property : " + field + ". From line: " + pos.lineNumber,{ fileName : "EaselJsTest.hx", lineNumber : 183, className : "v042.EaselJsTest", methodName : "verifyThatPropertiesExist"});
			massive.munit.Assert.isTrue(false,{ fileName : "EaselJsTest.hx", lineNumber : 183, className : "v042.EaselJsTest", methodName : "verifyThatPropertiesExist"});
		} else massive.munit.Assert.isTrue(true,{ fileName : "EaselJsTest.hx", lineNumber : 185, className : "v042.EaselJsTest", methodName : "verifyThatPropertiesExist"});
	}
}
v042.EaselJsTest.prototype.__class__ = v042.EaselJsTest;
massive.munit.client.JUnitReportClient = function(p) {
	if( p === $_ ) return;
	this.id = "junit";
	this.xml = new StringBuf();
	this.currentTestClass = "";
	this.newline = "\n";
	this.testSuiteXML = null;
	this.xml.add("<testsuites>" + this.newline);
}
massive.munit.client.JUnitReportClient.__name__ = ["massive","munit","client","JUnitReportClient"];
massive.munit.client.JUnitReportClient.prototype.id = null;
massive.munit.client.JUnitReportClient.prototype.completionHandler = null;
massive.munit.client.JUnitReportClient.prototype.get_completeHandler = function() {
	return this.completionHandler;
}
massive.munit.client.JUnitReportClient.prototype.set_completeHandler = function(value) {
	return this.completionHandler = value;
}
massive.munit.client.JUnitReportClient.prototype.newline = null;
massive.munit.client.JUnitReportClient.prototype.xml = null;
massive.munit.client.JUnitReportClient.prototype.testSuiteXML = null;
massive.munit.client.JUnitReportClient.prototype.currentTestClass = null;
massive.munit.client.JUnitReportClient.prototype.suitePassCount = null;
massive.munit.client.JUnitReportClient.prototype.suiteFailCount = null;
massive.munit.client.JUnitReportClient.prototype.suiteErrorCount = null;
massive.munit.client.JUnitReportClient.prototype.suiteExecutionTime = null;
massive.munit.client.JUnitReportClient.prototype.setCurrentTestClass = function(className) {
	if(this.currentTestClass == className) return;
	if(this.currentTestClass != null) this.endTestSuite();
	this.currentTestClass = className;
	if(this.currentTestClass != null) this.startTestSuite();
}
massive.munit.client.JUnitReportClient.prototype.addPass = function(result) {
	this.suitePassCount++;
	this.testSuiteXML.add("<testcase classname=\"" + result.className + "\" name=\"" + result.name + "\" time=\"" + massive.munit.util.MathUtil.round(result.executionTime,5) + "\" />" + this.newline);
}
massive.munit.client.JUnitReportClient.prototype.addFail = function(result) {
	this.suiteFailCount++;
	this.testSuiteXML.add("<testcase classname=\"" + result.className + "\" name=\"" + result.name + "\" time=\"" + massive.munit.util.MathUtil.round(result.executionTime,5) + "\" >" + this.newline);
	this.testSuiteXML.add("<failure message=\"" + result.failure.message + "\" type=\"" + result.failure.type + "\">");
	this.testSuiteXML.add(result.failure);
	this.testSuiteXML.add("</failure>" + this.newline);
	this.testSuiteXML.add("</testcase>" + this.newline);
}
massive.munit.client.JUnitReportClient.prototype.addError = function(result) {
	this.suiteErrorCount++;
	this.testSuiteXML.add("<testcase classname=\"" + result.className + "\" name=\"" + result.name + "\" time=\"" + massive.munit.util.MathUtil.round(result.executionTime,5) + "\" >" + this.newline);
	this.testSuiteXML.add("<error message=\"" + result.error.message + "\" type=\"" + result.error.type + "\">");
	this.testSuiteXML.add(result.error);
	this.testSuiteXML.add("</error>" + this.newline);
	this.testSuiteXML.add("</testcase>" + this.newline);
}
massive.munit.client.JUnitReportClient.prototype.addIgnore = function(result) {
}
massive.munit.client.JUnitReportClient.prototype.reportFinalStatistics = function(testCount,passCount,failCount,errorCount,ignoreCount,time) {
	this.xml.add("</testsuites>");
	if(this.get_completeHandler() != null) (this.get_completeHandler())(this);
	return this.xml.b.join("");
}
massive.munit.client.JUnitReportClient.prototype.endTestSuite = function() {
	if(this.testSuiteXML == null) return;
	var suiteTestCount = this.suitePassCount + this.suiteFailCount + this.suiteErrorCount;
	this.suiteExecutionTime = massive.munit.util.Timer.stamp() - this.suiteExecutionTime;
	var header = "<testsuite errors=\"" + this.suiteErrorCount + "\" failures=\"" + this.suiteFailCount + "\" hostname=\"\" name=\"" + this.currentTestClass + "\" tests=\"" + suiteTestCount + "\" time=\"" + massive.munit.util.MathUtil.round(this.suiteExecutionTime,5) + "\" timestamp=\"" + Date.now() + "\">" + this.newline;
	var footer = "</testsuite>" + this.newline;
	this.testSuiteXML.add("<system-out></system-out>" + this.newline);
	this.testSuiteXML.add("<system-err></system-err>" + this.newline);
	this.xml.add(header);
	this.xml.add(this.testSuiteXML.b.join(""));
	this.xml.add(footer);
}
massive.munit.client.JUnitReportClient.prototype.startTestSuite = function() {
	this.suitePassCount = 0;
	this.suiteFailCount = 0;
	this.suiteErrorCount = 0;
	this.suiteExecutionTime = massive.munit.util.Timer.stamp();
	this.testSuiteXML = new StringBuf();
}
massive.munit.client.JUnitReportClient.prototype.__class__ = massive.munit.client.JUnitReportClient;
massive.munit.client.JUnitReportClient.__interfaces__ = [massive.munit.IAdvancedTestResultClient];
if(!massive.munit.util) massive.munit.util = {}
massive.munit.util.Timer = function(time_ms) {
	if( time_ms === $_ ) return;
	this.id = massive.munit.util.Timer.arr.length;
	massive.munit.util.Timer.arr[this.id] = this;
	this.timerId = window.setInterval("massive.munit.util.Timer.arr[" + this.id + "].run();",time_ms);
}
massive.munit.util.Timer.__name__ = ["massive","munit","util","Timer"];
massive.munit.util.Timer.delay = function(f,time_ms) {
	var t = new massive.munit.util.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
massive.munit.util.Timer.stamp = function() {
	return Date.now().getTime() / 1000;
}
massive.munit.util.Timer.prototype.id = null;
massive.munit.util.Timer.prototype.timerId = null;
massive.munit.util.Timer.prototype.stop = function() {
	if(this.id == null) return;
	window.clearInterval(this.timerId);
	massive.munit.util.Timer.arr[this.id] = null;
	if(this.id > 100 && this.id == massive.munit.util.Timer.arr.length - 1) {
		var p = this.id - 1;
		while(p >= 0 && massive.munit.util.Timer.arr[p] == null) p--;
		massive.munit.util.Timer.arr = massive.munit.util.Timer.arr.slice(0,p + 1);
	}
	this.id = null;
}
massive.munit.util.Timer.prototype.run = function() {
}
massive.munit.util.Timer.prototype.__class__ = massive.munit.util.Timer;
massive.munit.async.IAsyncDelegateObserver = function() { }
massive.munit.async.IAsyncDelegateObserver.__name__ = ["massive","munit","async","IAsyncDelegateObserver"];
massive.munit.async.IAsyncDelegateObserver.prototype.asyncResponseHandler = null;
massive.munit.async.IAsyncDelegateObserver.prototype.asyncTimeoutHandler = null;
massive.munit.async.IAsyncDelegateObserver.prototype.asyncDelegateCreatedHandler = null;
massive.munit.async.IAsyncDelegateObserver.prototype.__class__ = massive.munit.async.IAsyncDelegateObserver;
massive.munit.TestRunner = function(resultClient) {
	if( resultClient === $_ ) return;
	this.clients = new Array();
	this.addResultClient(resultClient);
	this.set_asyncFactory(this.createAsyncFactory());
	this.running = false;
	this.isDebug = false;
}
massive.munit.TestRunner.__name__ = ["massive","munit","TestRunner"];
massive.munit.TestRunner.prototype.completionHandler = null;
massive.munit.TestRunner.prototype.clientCount = null;
massive.munit.TestRunner.prototype.get_clientCount = function() {
	return this.clients.length;
}
massive.munit.TestRunner.prototype.running = null;
massive.munit.TestRunner.prototype.testCount = null;
massive.munit.TestRunner.prototype.failCount = null;
massive.munit.TestRunner.prototype.errorCount = null;
massive.munit.TestRunner.prototype.passCount = null;
massive.munit.TestRunner.prototype.ignoreCount = null;
massive.munit.TestRunner.prototype.clientCompleteCount = null;
massive.munit.TestRunner.prototype.clients = null;
massive.munit.TestRunner.prototype.activeHelper = null;
massive.munit.TestRunner.prototype.testSuites = null;
massive.munit.TestRunner.prototype.asyncPending = null;
massive.munit.TestRunner.prototype.asyncDelegate = null;
massive.munit.TestRunner.prototype.suiteIndex = null;
massive.munit.TestRunner.prototype.asyncFactory = null;
massive.munit.TestRunner.prototype.set_asyncFactory = function(value) {
	if(value == this.asyncFactory) return value;
	if(this.running) throw new massive.munit.MUnitException("Can't change AsyncFactory while tests are running",{ fileName : "TestRunner.hx", lineNumber : 119, className : "massive.munit.TestRunner", methodName : "set_asyncFactory"});
	value.observer = this;
	return this.asyncFactory = value;
}
massive.munit.TestRunner.prototype.emptyParams = null;
massive.munit.TestRunner.prototype.startTime = null;
massive.munit.TestRunner.prototype.testStartTime = null;
massive.munit.TestRunner.prototype.isDebug = null;
massive.munit.TestRunner.prototype.addResultClient = function(resultClient) {
	var _g = 0, _g1 = this.clients;
	while(_g < _g1.length) {
		var client = _g1[_g];
		++_g;
		if(client == resultClient) return;
	}
	resultClient.set_completeHandler($closure(this,"clientCompletionHandler"));
	this.clients.push(resultClient);
}
massive.munit.TestRunner.prototype.debug = function(testSuiteClasses) {
	this.isDebug = true;
	this.run(testSuiteClasses);
}
massive.munit.TestRunner.prototype.run = function(testSuiteClasses) {
	if(this.running) return;
	this.running = true;
	this.asyncPending = false;
	this.asyncDelegate = null;
	this.testCount = 0;
	this.failCount = 0;
	this.errorCount = 0;
	this.passCount = 0;
	this.ignoreCount = 0;
	this.suiteIndex = 0;
	this.clientCompleteCount = 0;
	massive.munit.Assert.assertionCount = 0;
	this.emptyParams = new Array();
	this.testSuites = new Array();
	this.startTime = massive.munit.util.Timer.stamp();
	var _g = 0;
	while(_g < testSuiteClasses.length) {
		var suiteType = testSuiteClasses[_g];
		++_g;
		this.testSuites.push(Type.createInstance(suiteType,new Array()));
	}
	this.execute();
}
massive.munit.TestRunner.prototype.execute = function() {
	var _g1 = this.suiteIndex, _g = this.testSuites.length;
	while(_g1 < _g) {
		var i = _g1++;
		var suite = this.testSuites[i];
		while( suite.hasNext() ) {
			var testClass = suite.next();
			if(this.activeHelper == null || this.activeHelper.type != testClass) {
				this.activeHelper = new massive.munit.TestClassHelper(testClass,this.isDebug);
				this.activeHelper.beforeClass.apply(this.activeHelper.test,this.emptyParams);
			}
			this.executeTestCases();
			if(!this.asyncPending) this.activeHelper.afterClass.apply(this.activeHelper.test,this.emptyParams); else {
				suite.repeat();
				this.suiteIndex = i;
				return;
			}
		}
	}
	if(!this.asyncPending) {
		var time = massive.munit.util.Timer.stamp() - this.startTime;
		var _g = 0, _g1 = this.clients;
		while(_g < _g1.length) {
			var client = _g1[_g];
			++_g;
			if(Std["is"](client,massive.munit.IAdvancedTestResultClient)) ((function($this) {
				var $r;
				var $t = client;
				if(Std["is"]($t,massive.munit.IAdvancedTestResultClient)) $t; else throw "Class cast error";
				$r = $t;
				return $r;
			}(this))).setCurrentTestClass(null);
			client.reportFinalStatistics(this.testCount,this.passCount,this.failCount,this.errorCount,this.ignoreCount,time);
		}
	}
}
massive.munit.TestRunner.prototype.executeTestCases = function() {
	var _g = 0, _g1 = this.clients;
	while(_g < _g1.length) {
		var c = _g1[_g];
		++_g;
		if(Std["is"](c,massive.munit.IAdvancedTestResultClient)) ((function($this) {
			var $r;
			var $t = c;
			if(Std["is"]($t,massive.munit.IAdvancedTestResultClient)) $t; else throw "Class cast error";
			$r = $t;
			return $r;
		}(this))).setCurrentTestClass(this.activeHelper.className);
	}
	var $it0 = this.activeHelper;
	while( $it0.hasNext() ) {
		var testCaseData = $it0.next();
		if(testCaseData.result.ignore) {
			this.ignoreCount++;
			var _g = 0, _g1 = this.clients;
			while(_g < _g1.length) {
				var c = _g1[_g];
				++_g;
				c.addIgnore(testCaseData.result);
			}
		} else {
			this.testCount++;
			this.activeHelper.before.apply(this.activeHelper.test,this.emptyParams);
			this.testStartTime = massive.munit.util.Timer.stamp();
			this.executeTestCase(testCaseData,testCaseData.result.async);
			if(!this.asyncPending) this.activeHelper.after.apply(this.activeHelper.test,this.emptyParams); else break;
		}
	}
}
massive.munit.TestRunner.prototype.executeTestCase = function(testCaseData,async) {
	var result = testCaseData.result;
	try {
		var assertionCount = massive.munit.Assert.assertionCount;
		if(async) {
			testCaseData.test.apply(testCaseData.scope,[this.asyncFactory]);
			if(this.asyncDelegate == null) throw new massive.munit.async.MissingAsyncDelegateException("No AsyncDelegate was created in async test at " + result.get_location(),null);
			this.asyncPending = true;
		} else {
			testCaseData.test.apply(testCaseData.scope,this.emptyParams);
			result.passed = true;
			result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
			this.passCount++;
			var _g = 0, _g1 = this.clients;
			while(_g < _g1.length) {
				var c = _g1[_g];
				++_g;
				c.addPass(result);
			}
		}
	} catch( e ) {
		if(async && this.asyncDelegate != null) {
			this.asyncDelegate.cancelTest();
			this.asyncDelegate = null;
		}
		if(Std["is"](e,org.hamcrest.AssertionException)) e = new massive.munit.AssertionException(e.message,e.info);
		if(Std["is"](e,massive.munit.AssertionException)) {
			result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
			result.failure = e;
			this.failCount++;
			var _g = 0, _g1 = this.clients;
			while(_g < _g1.length) {
				var c = _g1[_g];
				++_g;
				c.addFail(result);
			}
		} else {
			result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
			if(!Std["is"](e,massive.munit.MUnitException)) e = new massive.munit.UnhandledException(e,result.get_location());
			result.error = e;
			this.errorCount++;
			var _g = 0, _g1 = this.clients;
			while(_g < _g1.length) {
				var c = _g1[_g];
				++_g;
				c.addError(result);
			}
		}
	}
}
massive.munit.TestRunner.prototype.clientCompletionHandler = function(resultClient) {
	if(++this.clientCompleteCount == this.clients.length) {
		if(this.completionHandler != null) {
			var successful = this.passCount == this.testCount;
			var handler = this.completionHandler;
			massive.munit.util.Timer.delay(function() {
				handler(successful);
			},10);
		}
		this.running = false;
	}
}
massive.munit.TestRunner.prototype.asyncResponseHandler = function(delegate) {
	var testCaseData = this.activeHelper.current();
	testCaseData.test = $closure(delegate,"runTest");
	testCaseData.scope = delegate;
	this.asyncPending = false;
	this.asyncDelegate = null;
	this.executeTestCase(testCaseData,false);
	this.activeHelper.after.apply(this.activeHelper.test,this.emptyParams);
	this.execute();
}
massive.munit.TestRunner.prototype.asyncTimeoutHandler = function(delegate) {
	var testCaseData = this.activeHelper.current();
	var result = testCaseData.result;
	result.executionTime = massive.munit.util.Timer.stamp() - this.testStartTime;
	result.error = new massive.munit.async.AsyncTimeoutException("",delegate.info);
	this.asyncPending = false;
	this.asyncDelegate = null;
	this.errorCount++;
	var _g = 0, _g1 = this.clients;
	while(_g < _g1.length) {
		var c = _g1[_g];
		++_g;
		c.addError(result);
	}
	this.activeHelper.after.apply(this.activeHelper.test,this.emptyParams);
	this.execute();
}
massive.munit.TestRunner.prototype.asyncDelegateCreatedHandler = function(delegate) {
	this.asyncDelegate = delegate;
}
massive.munit.TestRunner.prototype.createAsyncFactory = function() {
	return new massive.munit.async.AsyncFactory(this);
}
massive.munit.TestRunner.prototype.__class__ = massive.munit.TestRunner;
massive.munit.TestRunner.__interfaces__ = [massive.munit.async.IAsyncDelegateObserver];
TestMain = function(p) {
	if( p === $_ ) return;
	var suites = new Array();
	suites.push(TestSuite);
	var client = new massive.munit.client.RichPrintClient();
	var runner = new massive.munit.TestRunner(client);
	runner.completionHandler = $closure(this,"completionHandler");
	runner.run(suites);
}
TestMain.__name__ = ["TestMain"];
TestMain.main = function() {
	/*
* EaselJS
* Visit http://createjs.com/ for documentation, updates and examples.
*
* Copyright (c) 2011 gskinner.com, inc.
* 
* Distributed under the terms of the MIT license.
* http://www.opensource.org/licenses/mit-license.html
*
* This notice shall be included in all copies or substantial portions of the Software.
*/
(function(j){var c=function(){throw"UID cannot be instantiated";};c._nextID=0;c.get=function(){return c._nextID++};j.UID=c})(window);(function(j){var c=function(){throw"Ticker cannot be instantiated.";};c.useRAF=null;c.animationTarget=null;c._listeners=null;c._pauseable=null;c._paused=false;c._inited=false;c._startTime=0;c._pausedTime=0;c._ticks=0;c._pausedTickers=0;c._interval=50;c._lastTime=0;c._times=null;c._tickTimes=null;c._rafActive=false;c._timeoutID=null;c.addListener=function(a,b){a!=null&&(c._inited||c.init(),c.removeListener(a),c._pauseable[c._listeners.length]=b==null?true:b,c._listeners.push(a))};c.init=function(){c._inited=
true;c._times=[];c._tickTimes=[];c._pauseable=[];c._listeners=[];c._times.push(c._lastTime=c._startTime=c._getTime());c.setInterval(c._interval)};c.removeListener=function(a){c._listeners!=null&&(a=c._listeners.indexOf(a),a!=-1&&(c._listeners.splice(a,1),c._pauseable.splice(a,1)))};c.removeAllListeners=function(){c._listeners=[];c._pauseable=[]};c.setInterval=function(a){c._interval=a;c._inited&&c._setupTick()};c.getInterval=function(){return c._interval};c.setFPS=function(a){c.setInterval(1E3/a)};
c.getFPS=function(){return 1E3/c._interval};c.getMeasuredFPS=function(a){if(c._times.length<2)return-1;a==null&&(a=c.getFPS()|0);a=Math.min(c._times.length-1,a);return 1E3/((c._times[0]-c._times[a])/a)};c.setPaused=function(a){c._paused=a};c.getPaused=function(){return c._paused};c.getTime=function(a){return c._getTime()-c._startTime-(a?c._pausedTime:0)};c.getTicks=function(a){return c._ticks-(a?c._pausedTickers:0)};c._handleAF=function(a){c._rafActive=false;c._setupTick();a-c._lastTime>=c._interval-
1&&c._tick()};c._handleTimeout=function(){c.timeoutID=null;c._setupTick();c._tick()};c._setupTick=function(){if(!(c._rafActive||c.timeoutID!=null)){if(c.useRAF){var a=j.requestAnimationFrame||j.webkitRequestAnimationFrame||j.mozRequestAnimationFrame||j.oRequestAnimationFrame||j.msRequestAnimationFrame;if(a){a(c._handleAF,c.animationTarget);c._rafActive=true;return}}c.timeoutID=setTimeout(c._handleTimeout,c._interval)}};c._tick=function(){c._ticks++;var a=c._getTime(),b=a-c._lastTime,p=c._paused;p&&
(c._pausedTickers++,c._pausedTime+=b);c._lastTime=a;for(var h=c._pauseable,e=c._listeners.slice(),d=e?e.length:0,f=0;f<d;f++){var g=e[f];g==null||p&&h[f]||(g.tick?g.tick(b,p):g instanceof Function&&g(b,p))}for(c._tickTimes.unshift(c._getTime()-a);c._tickTimes.length>100;)c._tickTimes.pop();for(c._times.unshift(a);c._times.length>100;)c._times.pop()};c._getTime=function(){return(new Date).getTime()};j.Ticker=c})(window);(function(j){var c=function(b,a,h,c,d){this.initialize(b,a,h,c,d)},a=c.prototype;a.stageX=0;a.stageY=0;a.type=null;a.nativeEvent=null;a.onMouseMove=null;a.onMouseUp=null;a.target=null;a.initialize=function(b,a,h,c,d){this.type=b;this.stageX=a;this.stageY=h;this.target=c;this.nativeEvent=d};a.clone=function(){return new c(this.type,this.stageX,this.stageY,this.target,this.nativeEvent)};a.toString=function(){return"[MouseEvent (type="+this.type+" stageX="+this.stageX+" stageY="+this.stageY+")]"};j.MouseEvent=
c})(window);(function(j){var c=function(b,a,h,c,d,f){this.initialize(b,a,h,c,d,f)},a=c.prototype;c.identity=null;c.DEG_TO_RAD=Math.PI/180;a.a=1;a.b=0;a.c=0;a.d=1;a.tx=0;a.ty=0;a.alpha=1;a.shadow=null;a.compositeOperation=null;a.initialize=function(b,a,h,c,d,f){if(b!=null)this.a=b;this.b=a||0;this.c=h||0;if(c!=null)this.d=c;this.tx=d||0;this.ty=f||0};a.prepend=function(b,a,h,c,d,f){var g=this.tx;if(b!=1||a!=0||h!=0||c!=1){var k=this.a,i=this.c;this.a=k*b+this.b*h;this.b=k*a+this.b*c;this.c=i*b+this.d*h;this.d=
i*a+this.d*c}this.tx=g*b+this.ty*h+d;this.ty=g*a+this.ty*c+f};a.append=function(b,a,h,c,d,f){var g=this.a,k=this.b,i=this.c,l=this.d;this.a=b*g+a*i;this.b=b*k+a*l;this.c=h*g+c*i;this.d=h*k+c*l;this.tx=d*g+f*i+this.tx;this.ty=d*k+f*l+this.ty};a.prependMatrix=function(b){this.prepend(b.a,b.b,b.c,b.d,b.tx,b.ty);this.prependProperties(b.alpha,b.shadow,b.compositeOperation)};a.appendMatrix=function(b){this.append(b.a,b.b,b.c,b.d,b.tx,b.ty);this.appendProperties(b.alpha,b.shadow,b.compositeOperation)};
a.prependTransform=function(b,a,h,e,d,f,g,k,i){if(d%360)var l=d*c.DEG_TO_RAD,d=Math.cos(l),l=Math.sin(l);else d=1,l=0;if(k||i)this.tx-=k,this.ty-=i;f||g?(f*=c.DEG_TO_RAD,g*=c.DEG_TO_RAD,this.prepend(d*h,l*h,-l*e,d*e,0,0),this.prepend(Math.cos(g),Math.sin(g),-Math.sin(f),Math.cos(f),b,a)):this.prepend(d*h,l*h,-l*e,d*e,b,a)};a.appendTransform=function(b,a,h,e,d,f,g,k,i){if(d%360)var l=d*c.DEG_TO_RAD,d=Math.cos(l),l=Math.sin(l);else d=1,l=0;f||g?(f*=c.DEG_TO_RAD,g*=c.DEG_TO_RAD,this.append(Math.cos(g),
Math.sin(g),-Math.sin(f),Math.cos(f),b,a),this.append(d*h,l*h,-l*e,d*e,0,0)):this.append(d*h,l*h,-l*e,d*e,b,a);if(k||i)this.tx-=k*this.a+i*this.c,this.ty-=k*this.b+i*this.d};a.rotate=function(b){var a=Math.cos(b),b=Math.sin(b),h=this.a,c=this.c,d=this.tx;this.a=h*a-this.b*b;this.b=h*b+this.b*a;this.c=c*a-this.d*b;this.d=c*b+this.d*a;this.tx=d*a-this.ty*b;this.ty=d*b+this.ty*a};a.skew=function(b,a){b*=c.DEG_TO_RAD;a*=c.DEG_TO_RAD;this.append(Math.cos(a),Math.sin(a),-Math.sin(b),Math.cos(b),0,0)};a.scale=
function(b,a){this.a*=b;this.d*=a;this.tx*=b;this.ty*=a};a.translate=function(b,a){this.tx+=b;this.ty+=a};a.identity=function(){this.alpha=this.a=this.d=1;this.b=this.c=this.tx=this.ty=0;this.shadow=this.compositeOperation=null};a.invert=function(){var b=this.a,a=this.b,h=this.c,c=this.d,d=this.tx,f=b*c-a*h;this.a=c/f;this.b=-a/f;this.c=-h/f;this.d=b/f;this.tx=(h*this.ty-c*d)/f;this.ty=-(b*this.ty-a*d)/f};a.isIdentity=function(){return this.tx==0&&this.ty==0&&this.a==1&&this.b==0&&this.c==0&&this.d==
1};a.decompose=function(b){b==null&&(b={});b.x=this.tx;b.y=this.ty;b.scaleX=Math.sqrt(this.a*this.a+this.b*this.b);b.scaleY=Math.sqrt(this.c*this.c+this.d*this.d);var a=Math.atan2(-this.c,this.d),h=Math.atan2(this.b,this.a);a==h?(b.rotation=h/c.DEG_TO_RAD,this.a<0&&this.d>=0&&(b.rotation+=b.rotation<=0?180:-180),b.skewX=b.skewY=0):(b.skewX=a/c.DEG_TO_RAD,b.skewY=h/c.DEG_TO_RAD);return b};a.reinitialize=function(b,a,h,c,d,f,g,k,i){this.initialize(b,a,h,c,d,f);this.alpha=g||1;this.shadow=k;this.compositeOperation=
i;return this};a.appendProperties=function(b,a,h){this.alpha*=b;this.shadow=a||this.shadow;this.compositeOperation=h||this.compositeOperation};a.prependProperties=function(b,a,h){this.alpha*=b;this.shadow=this.shadow||a;this.compositeOperation=this.compositeOperation||h};a.clone=function(){var b=new c(this.a,this.b,this.c,this.d,this.tx,this.ty);b.shadow=this.shadow;b.alpha=this.alpha;b.compositeOperation=this.compositeOperation;return b};a.toString=function(){return"[Matrix2D (a="+this.a+" b="+this.b+
" c="+this.c+" d="+this.d+" tx="+this.tx+" ty="+this.ty+")]"};c.identity=new c(1,0,0,1,0,0);j.Matrix2D=c})(window);(function(j){var c=function(b,a){this.initialize(b,a)},a=c.prototype;a.x=0;a.y=0;a.initialize=function(b,a){this.x=b==null?0:b;this.y=a==null?0:a};a.clone=function(){return new c(this.x,this.y)};a.toString=function(){return"[Point (x="+this.x+" y="+this.y+")]"};j.Point=c})(window);(function(j){var c=function(b,a,h,c){this.initialize(b,a,h,c)},a=c.prototype;a.x=0;a.y=0;a.width=0;a.height=0;a.initialize=function(b,a,c,e){this.x=b==null?0:b;this.y=a==null?0:a;this.width=c==null?0:c;this.height=e==null?0:e};a.clone=function(){return new c(this.x,this.y,this.width,this.height)};a.toString=function(){return"[Rectangle (x="+this.x+" y="+this.y+" width="+this.width+" height="+this.height+")]"};j.Rectangle=c})(window);(function(j){var c=function(b,a,c,e){this.initialize(b,a,c,e)},a=c.prototype;c.identity=null;a.color=null;a.offsetX=0;a.offsetY=0;a.blur=0;a.initialize=function(b,a,c,e){this.color=b;this.offsetX=a;this.offsetY=c;this.blur=e};a.toString=function(){return"[Shadow]"};a.clone=function(){return new c(this.color,this.offsetX,this.offsetY,this.blur)};c.identity=new c("transparent",0,0,0);j.Shadow=c})(window);(function(j){var c=function(b){this.initialize(b)},a=c.prototype;a.complete=true;a.onComplete=null;a._animations=null;a._frames=null;a._images=null;a._data=null;a._loadCount=0;a._frameHeight=0;a._frameWidth=0;a._numFrames=0;a._regX=0;a._regY=0;a.initialize=function(b){var a,c,e;if(b!=null){if(b.images&&(c=b.images.length)>0){e=this._images=[];for(a=0;a<c;a++){var d=b.images[a];if(!(d instanceof Image)){var f=d,d=new Image;d.src=f}e.push(d);if(!d.getContext&&!d.complete)this._loadCount++,this.complete=
false,function(b){d.onload=function(){b._handleImageLoad()}}(this)}}if(b.frames!=null)if(b.frames instanceof Array){this._frames=[];e=b.frames;for(a=0,c=e.length;a<c;a++)f=e[a],this._frames.push({image:this._images[f[4]?f[4]:0],rect:new Rectangle(f[0],f[1],f[2],f[3]),regX:f[5]||0,regY:f[6]||0})}else c=b.frames,this._frameWidth=c.width,this._frameHeight=c.height,this._regX=c.regX||0,this._regY=c.regY||0,this._numFrames=c.count,this._loadCount==0&&this._calculateFrames();if((c=b.animations)!=null){this._animations=
[];this._data={};for(var g in c){b={name:g};f=c[g];if(isNaN(f))if(f instanceof Array){b.frequency=f[3];b.next=f[2];e=b.frames=[];for(a=f[0];a<=f[1];a++)e.push(a)}else b.frequency=f.frequency,b.next=f.next,e=b.frames=f.frames.slice(0);else e=b.frames=[f];b.next=e.length<2||b.next==false?null:b.next==null||b.next==true?g:b.next;if(!b.frequency)b.frequency=1;this._animations.push(g);this._data[g]=b}}}};a.getNumFrames=function(b){return b==null?this._frames?this._frames.length:this._numFrames:(b=this._data[b],
b==null?0:b.frames.length)};a.getAnimations=function(){return this._animations.slice(0)};a.getAnimation=function(b){return this._data[b]};a.getFrame=function(b){return this.complete&&this._frames&&(frame=this._frames[b])?frame:null};a.toString=function(){return"[SpriteSheet]"};a.clone=function(){var b=new c;b.complete=this.complete;b._animations=this._animations;b._frames=this._frames;b._images=this._images;b._data=this._data;b._frameHeight=this._frameHeight;b._frameWidth=this._frameWidth;b._numFrames=
this._numFrames;b._loadCount=this._loadCount;return b};a._handleImageLoad=function(){if(--this._loadCount==0)this._calculateFrames(),this.complete=true,this.onComplete&&this.onComplete()};a._calculateFrames=function(){if(!(this._frames||this._frameWidth==0)){this._frames=[];for(var b=0,a=this._frameWidth,c=this._frameHeight,e=0,d=this._images;e<d.length;e++){for(var f=d[e],g=(f.width+1)/a|0,k=(f.height+1)/c|0,k=this._numFrames>0?Math.min(this._numFrames-b,g*k):g*k,i=0;i<k;i++)this._frames.push({image:f,
rect:new Rectangle(i%g*a,(i/g|0)*c,a,c),regX:this._regX,regY:this._regY});b+=k}this._numFrames=b}};j.SpriteSheet=c})(window);(function(j){function c(b,a){this.f=b;this.params=a}c.prototype.exec=function(b){this.f.apply(b,this.params)};var a=function(){this.initialize()},b=a.prototype;a.getRGB=function(b,a,c,d){b!=null&&c==null&&(d=a,c=b&255,a=b>>8&255,b=b>>16&255);return d==null?"rgb("+b+","+a+","+c+")":"rgba("+b+","+a+","+c+","+d+")"};a.getHSL=function(b,a,c,d){return d==null?"hsl("+b%360+","+a+"%,"+c+"%)":"hsla("+b%360+","+a+"%,"+c+"%,"+d+")"};a.BASE_64={A:0,B:1,C:2,D:3,E:4,F:5,G:6,H:7,I:8,J:9,K:10,L:11,M:12,N:13,O:14,
P:15,Q:16,R:17,S:18,T:19,U:20,V:21,W:22,X:23,Y:24,Z:25,a:26,b:27,c:28,d:29,e:30,f:31,g:32,h:33,i:34,j:35,k:36,l:37,m:38,n:39,o:40,p:41,q:42,r:43,s:44,t:45,u:46,v:47,w:48,x:49,y:50,z:51,0:52,1:53,2:54,3:55,4:56,5:57,6:58,7:59,8:60,9:61,"+":62,"/":63};a.STROKE_CAPS_MAP=["butt","round","square"];a.STROKE_JOINTS_MAP=["miter","round","bevel"];a._ctx=document.createElement("canvas").getContext("2d");a.beginCmd=new c(a._ctx.beginPath,[]);a.fillCmd=new c(a._ctx.fill,[]);a.strokeCmd=new c(a._ctx.stroke,[]);
b._strokeInstructions=null;b._strokeStyleInstructions=null;b._fillInstructions=null;b._instructions=null;b._oldInstructions=null;b._activeInstructions=null;b._active=false;b._dirty=false;b.initialize=function(){this.clear();this._ctx=a._ctx};b.draw=function(b){this._dirty&&this._updateInstructions();for(var a=this._instructions,c=0,d=a.length;c<d;c++)a[c].exec(b)};b.moveTo=function(b,a){this._activeInstructions.push(new c(this._ctx.moveTo,[b,a]));return this};b.lineTo=function(b,a){this._dirty=this._active=
true;this._activeInstructions.push(new c(this._ctx.lineTo,[b,a]));return this};b.arcTo=function(b,a,e,d,f){this._dirty=this._active=true;this._activeInstructions.push(new c(this._ctx.arcTo,[b,a,e,d,f]));return this};b.arc=function(b,a,e,d,f,g){this._dirty=this._active=true;g==null&&(g=false);this._activeInstructions.push(new c(this._ctx.arc,[b,a,e,d,f,g]));return this};b.quadraticCurveTo=function(b,a,e,d){this._dirty=this._active=true;this._activeInstructions.push(new c(this._ctx.quadraticCurveTo,
[b,a,e,d]));return this};b.bezierCurveTo=function(b,a,e,d,f,g){this._dirty=this._active=true;this._activeInstructions.push(new c(this._ctx.bezierCurveTo,[b,a,e,d,f,g]));return this};b.rect=function(b,a,e,d){this._dirty=this._active=true;this._activeInstructions.push(new c(this._ctx.rect,[b,a,e,d]));return this};b.closePath=function(){if(this._active)this._dirty=true,this._activeInstructions.push(new c(this._ctx.closePath,[]));return this};b.clear=function(){this._instructions=[];this._oldInstructions=
[];this._activeInstructions=[];this._strokeStyleInstructions=this._strokeInstructions=this._fillInstructions=null;this._active=this._dirty=false;return this};b.beginFill=function(b){this._active&&this._newPath();this._fillInstructions=b?[new c(this._setProp,["fillStyle",b])]:null;return this};b.beginLinearGradientFill=function(b,a,e,d,f,g){this._active&&this._newPath();e=this._ctx.createLinearGradient(e,d,f,g);d=0;for(f=b.length;d<f;d++)e.addColorStop(a[d],b[d]);this._fillInstructions=[new c(this._setProp,
["fillStyle",e])];return this};b.beginRadialGradientFill=function(b,a,e,d,f,g,k,i){this._active&&this._newPath();e=this._ctx.createRadialGradient(e,d,f,g,k,i);d=0;for(f=b.length;d<f;d++)e.addColorStop(a[d],b[d]);this._fillInstructions=[new c(this._setProp,["fillStyle",e])];return this};b.beginBitmapFill=function(b,a){this._active&&this._newPath();var e=this._ctx.createPattern(b,a||"");this._fillInstructions=[new c(this._setProp,["fillStyle",e])];return this};b.endFill=function(){this.beginFill();
return this};b.setStrokeStyle=function(b,h,e,d){this._active&&this._newPath();this._strokeStyleInstructions=[new c(this._setProp,["lineWidth",b==null?"1":b]),new c(this._setProp,["lineCap",h==null?"butt":isNaN(h)?h:a.STROKE_CAPS_MAP[h]]),new c(this._setProp,["lineJoin",e==null?"miter":isNaN(e)?e:a.STROKE_JOINTS_MAP[e]]),new c(this._setProp,["miterLimit",d==null?"10":d])];return this};b.beginStroke=function(b){this._active&&this._newPath();this._strokeInstructions=b?[new c(this._setProp,["strokeStyle",
b])]:null;return this};b.beginLinearGradientStroke=function(b,a,e,d,f,g){this._active&&this._newPath();e=this._ctx.createLinearGradient(e,d,f,g);d=0;for(f=b.length;d<f;d++)e.addColorStop(a[d],b[d]);this._strokeInstructions=[new c(this._setProp,["strokeStyle",e])];return this};b.beginRadialGradientStroke=function(b,a,e,d,f,g,k,i){this._active&&this._newPath();e=this._ctx.createRadialGradient(e,d,f,g,k,i);d=0;for(f=b.length;d<f;d++)e.addColorStop(a[d],b[d]);this._strokeInstructions=[new c(this._setProp,
["strokeStyle",e])];return this};b.beginBitmapStroke=function(b,a){this._active&&this._newPath();var e=this._ctx.createPattern(b,a||"");this._strokeInstructions=[new c(this._setProp,["strokeStyle",e])];return this};b.endStroke=function(){this.beginStroke();return this};b.curveTo=b.quadraticCurveTo;b.drawRect=b.rect;b.drawRoundRect=function(b,a,c,d,f){this.drawRoundRectComplex(b,a,c,d,f,f,f,f);return this};b.drawRoundRectComplex=function(b,a,e,d,f,g,k,i){this._dirty=this._active=true;var l=Math.PI,
j=this._ctx.arc,m=this._ctx.lineTo;this._activeInstructions.push(new c(this._ctx.moveTo,[b+f,a]),new c(m,[b+e-g,a]),g>=0?new c(j,[b+e-g,a+g,g,-l/2,0]):new c(j,[b+e,a,-g,l,l/2,true]),new c(m,[b+e,a+d-k]),i>=0?new c(j,[b+e-k,a+d-k,k,0,l/2]):new c(j,[b+e,a+d,-k,-l/2,l,true]),new c(m,[b+i,a+d]),i>=0?new c(j,[b+i,a+d-i,i,l/2,l]):new c(j,[b,a+d,-i,0,-l/2,true]),new c(m,[b,a+f]),f>=0?new c(j,[b+f,a+f,f,l,-l/2]):new c(j,[b,a,-f,l/2,0,true]));return this};b.drawCircle=function(b,a,c){this.arc(b,a,c,0,Math.PI*
2);return this};b.drawEllipse=function(b,a,e,d){this._dirty=this._active=true;var f=e/2*0.5522848,g=d/2*0.5522848,k=b+e,i=a+d,e=b+e/2,d=a+d/2;this._activeInstructions.push(new c(this._ctx.moveTo,[b,d]),new c(this._ctx.bezierCurveTo,[b,d-g,e-f,a,e,a]),new c(this._ctx.bezierCurveTo,[e+f,a,k,d-g,k,d]),new c(this._ctx.bezierCurveTo,[k,d+g,e+f,i,e,i]),new c(this._ctx.bezierCurveTo,[e-f,i,b,d+g,b,d]));return this};b.drawPolyStar=function(b,a,e,d,f,g){this._dirty=this._active=true;f==null&&(f=0);f=1-f;g==
null?g=0:g/=180/Math.PI;var k=Math.PI/d;this._activeInstructions.push(new c(this._ctx.moveTo,[b+Math.cos(g)*e,a+Math.sin(g)*e]));for(var i=0;i<d;i++)g+=k,f!=1&&this._activeInstructions.push(new c(this._ctx.lineTo,[b+Math.cos(g)*e*f,a+Math.sin(g)*e*f])),g+=k,this._activeInstructions.push(new c(this._ctx.lineTo,[b+Math.cos(g)*e,a+Math.sin(g)*e]));return this};b.p=b.decodePath=function(b){for(var c=[this.moveTo,this.lineTo,this.quadraticCurveTo,this.bezierCurveTo],e=[2,2,4,6],d=0,f=b.length,g=[],k=0,
i=0,l=a.BASE_64;d<f;){var j=l[b.charAt(d)],m=j>>3,q=c[m];if(!q||j&3)throw"bad path data";var r=e[m];m||(k=i=0);g.length=0;d++;j=(j>>2&1)+2;for(m=0;m<r;m++){var n=l[b.charAt(d)],s=n>>5?-1:1,n=(n&31)<<6|l[b.charAt(d+1)];j==3&&(n=n<<6|l[b.charAt(d+2)]);n=s*n/10;m%2?k=n+=k:i=n+=i;g[m]=n;d+=j}q.apply(this,g)}return this};b.clone=function(){var b=new a;b._instructions=this._instructions.slice();b._activeInstructions=this._activeInstructions.slice();b._oldInstructions=this._oldInstructions.slice();if(this._fillInstructions)b._fillInstructions=
this._fillInstructions.slice();if(this._strokeInstructions)b._strokeInstructions=this._strokeInstructions.slice();if(this._strokeStyleInstructions)b._strokeStyleInstructions=this._strokeStyleInstructions.slice();b._active=this._active;b._dirty=this._dirty;return b};b.toString=function(){return"[Graphics]"};b.mt=b.moveTo;b.lt=b.lineTo;b.at=b.arcTo;b.bt=b.bezierCurveTo;b.qt=b.quadraticCurveTo;b.a=b.arc;b.r=b.rect;b.cp=b.closePath;b.c=b.clear;b.f=b.beginFill;b.lf=b.beginLinearGradientFill;b.rf=b.beginRadialGradientFill;
b.bf=b.beginBitmapFill;b.ef=b.endFill;b.ss=b.setStrokeStyle;b.s=b.beginStroke;b.ls=b.beginLinearGradientStroke;b.rs=b.beginRadialGradientStroke;b.bs=b.beginBitmapStroke;b.es=b.endStroke;b.dr=b.drawRect;b.rr=b.drawRoundRect;b.rc=b.drawRoundRectComplex;b.dc=b.drawCircle;b.de=b.drawEllipse;b.dp=b.drawPolyStar;b._updateInstructions=function(){this._instructions=this._oldInstructions.slice();this._instructions.push(a.beginCmd);this._fillInstructions&&this._instructions.push.apply(this._instructions,this._fillInstructions);
this._strokeInstructions&&(this._instructions.push.apply(this._instructions,this._strokeInstructions),this._strokeStyleInstructions&&this._instructions.push.apply(this._instructions,this._strokeStyleInstructions));this._instructions.push.apply(this._instructions,this._activeInstructions);this._fillInstructions&&this._instructions.push(a.fillCmd);this._strokeInstructions&&this._instructions.push(a.strokeCmd)};b._newPath=function(){this._dirty&&this._updateInstructions();this._oldInstructions=this._instructions;
this._activeInstructions=[];this._active=this._dirty=false};b._setProp=function(b,a){this[b]=a};j.Graphics=a})(window);(function(j){var c=function(){this.initialize()},a=c.prototype;c.suppressCrossDomainErrors=false;c._hitTestCanvas=document.createElement("canvas");c._hitTestCanvas.width=c._hitTestCanvas.height=1;c._hitTestContext=c._hitTestCanvas.getContext("2d");c._nextCacheID=1;a.alpha=1;a.cacheCanvas=null;a.id=-1;a.mouseEnabled=true;a.name=null;a.parent=null;a.regX=0;a.regY=0;a.rotation=0;a.scaleX=1;a.scaleY=1;a.skewX=0;a.skewY=0;a.shadow=null;a.visible=true;a.x=0;a.y=0;a.compositeOperation=null;a.snapToPixel=
false;a.onPress=null;a.onClick=null;a.onDoubleClick=null;a.onMouseOver=null;a.onMouseOut=null;a.onTick=null;a.filters=null;a.cacheID=0;a._cacheOffsetX=0;a._cacheOffsetY=0;a._cacheDataURLID=0;a._cacheDataURL=null;a._matrix=null;a.initialize=function(){this.id=UID.get();this._matrix=new Matrix2D};a.isVisible=function(){return this.visible&&this.alpha>0&&this.scaleX!=0&&this.scaleY!=0};a.draw=function(b,a){if(a||!this.cacheCanvas)return false;b.drawImage(this.cacheCanvas,this._cacheOffsetX,this._cacheOffsetY);
return true};a.cache=function(b,a,h,e){var d=this.cacheCanvas;if(d==null)d=this.cacheCanvas=document.createElement("canvas");var f=d.getContext("2d");d.width=h;d.height=e;f.setTransform(1,0,0,1,-b,-a);f.clearRect(b,a,d.width,d.height);this.draw(f,true,this._matrix.reinitialize(1,0,0,1,-b,-a));this._cacheOffsetX=b;this._cacheOffsetY=a;this._applyFilters();this.cacheID=c._nextCacheID++};a.updateCache=function(b){var a=this.cacheCanvas,h=this._cacheOffsetX,e=this._cacheOffsetY;if(a==null)throw"cache() must be called before updateCache()";
var d=a.getContext("2d");d.setTransform(1,0,0,1,-h,-e);b?d.globalCompositeOperation=b:d.clearRect(h,e,a.width,a.height);this.draw(d,true);if(b)d.globalCompositeOperation="source-over";this._applyFilters();this.cacheID=c._nextCacheID++};a.uncache=function(){this._cacheDataURL=this.cacheCanvas=null;this.cacheID=this._cacheOffsetX=this._cacheOffsetY=0};a.getCacheDataURL=function(){if(!this.cacheCanvas)return null;if(this.cacheID!=this._cacheDataURLID)this._cacheDataURL=this.cacheCanvas.toDataURL();return this._cacheDataURL};
a.getStage=function(){for(var b=this;b.parent;)b=b.parent;return b instanceof Stage?b:null};a.localToGlobal=function(b,a){var c=this.getConcatenatedMatrix(this._matrix);if(c==null)return null;c.append(1,0,0,1,b,a);return new Point(c.tx,c.ty)};a.globalToLocal=function(b,a){var c=this.getConcatenatedMatrix(this._matrix);if(c==null)return null;c.invert();c.append(1,0,0,1,b,a);return new Point(c.tx,c.ty)};a.localToLocal=function(b,a,c){b=this.localToGlobal(b,a);return c.globalToLocal(b.x,b.y)};a.setTransform=
function(b,a,c,e,d,f,g,k,i){this.x=b||0;this.y=a||0;this.scaleX=c==null?1:c;this.scaleY=e==null?1:e;this.rotation=d||0;this.skewX=f||0;this.skewY=g||0;this.regX=k||0;this.regY=i||0};a.getConcatenatedMatrix=function(b){b?b.identity():b=new Matrix2D;for(var a=this;a!=null;)b.prependTransform(a.x,a.y,a.scaleX,a.scaleY,a.rotation,a.skewX,a.skewY,a.regX,a.regY),b.prependProperties(a.alpha,a.shadow,a.compositeOperation),a=a.parent;return b};a.hitTest=function(b,a){var h=c._hitTestContext,e=c._hitTestCanvas;
h.setTransform(1,0,0,1,-b,-a);this.draw(h);h=this._testHit(h);e.width=0;e.width=1;return h};a.clone=function(){var b=new c;this.cloneProps(b);return b};a.toString=function(){return"[DisplayObject (name="+this.name+")]"};a.cloneProps=function(b){b.alpha=this.alpha;b.name=this.name;b.regX=this.regX;b.regY=this.regY;b.rotation=this.rotation;b.scaleX=this.scaleX;b.scaleY=this.scaleY;b.shadow=this.shadow;b.skewX=this.skewX;b.skewY=this.skewY;b.visible=this.visible;b.x=this.x;b.y=this.y;b.mouseEnabled=
this.mouseEnabled;b.compositeOperation=this.compositeOperation;if(this.cacheCanvas)b.cacheCanvas=this.cacheCanvas.cloneNode(true),b.cacheCanvas.getContext("2d").putImageData(this.cacheCanvas.getContext("2d").getImageData(0,0,this.cacheCanvas.width,this.cacheCanvas.height),0,0)};a.applyShadow=function(b,a){a=a||Shadow.identity;b.shadowColor=a.color;b.shadowOffsetX=a.offsetX;b.shadowOffsetY=a.offsetY;b.shadowBlur=a.blur};a._tick=function(b){if(this.onTick)this.onTick(b)};a._testHit=function(b){try{var a=
b.getImageData(0,0,1,1).data[3]>1}catch(h){if(!c.suppressCrossDomainErrors)throw"An error has occured. This is most likely due to security restrictions on reading canvas pixel data with local or cross-domain images.";}return a};a._applyFilters=function(){if(this.filters&&this.filters.length!=0&&this.cacheCanvas)for(var b=this.filters.length,a=this.cacheCanvas.getContext("2d"),c=this.cacheCanvas.width,e=this.cacheCanvas.height,d=0;d<b;d++)this.filters[d].applyFilter(a,0,0,c,e)};j.DisplayObject=c})(window);(function(j){var c=function(){this.initialize()},a=c.prototype=new DisplayObject;a.children=null;a.DisplayObject_initialize=a.initialize;a.initialize=function(){this.DisplayObject_initialize();this.children=[]};a.isVisible=function(){return this.visible&&this.alpha>0&&this.children.length&&this.scaleX!=0&&this.scaleY!=0};a.DisplayObject_draw=a.draw;a.draw=function(b,a,h){var e=Stage._snapToPixelEnabled;if(this.DisplayObject_draw(b,a))return true;for(var h=h||this._matrix.reinitialize(1,0,0,1,0,0,
this.alpha,this.shadow,this.compositeOperation),a=this.children.length,d=this.children.slice(0),f=0;f<a;f++){var g=d[f];if(g.isVisible()){var k=false,i=g._matrix.reinitialize(h.a,h.b,h.c,h.d,h.tx,h.ty,h.alpha,h.shadow,h.compositeOperation);i.appendTransform(g.x,g.y,g.scaleX,g.scaleY,g.rotation,g.skewX,g.skewY,g.regX,g.regY);i.appendProperties(g.alpha,g.shadow,g.compositeOperation);if(!(g instanceof c&&g.cacheCanvas==null))e&&g.snapToPixel&&i.a==1&&i.b==0&&i.c==0&&i.d==1?b.setTransform(i.a,i.b,i.c,
i.d,i.tx+0.5|0,i.ty+0.5|0):b.setTransform(i.a,i.b,i.c,i.d,i.tx,i.ty),b.globalAlpha=i.alpha,b.globalCompositeOperation=i.compositeOperation||"source-over",(k=i.shadow)&&this.applyShadow(b,k);g.draw(b,false,i);k&&this.applyShadow(b)}}return true};a.addChild=function(b){if(b==null)return b;var a=arguments.length;if(a>1){for(var c=0;c<a;c++)this.addChild(arguments[c]);return arguments[a-1]}b.parent&&b.parent.removeChild(b);b.parent=this;this.children.push(b);return b};a.addChildAt=function(b,a){var c=
arguments.length;if(c>2){for(var a=arguments[e-1],e=0;e<c-1;e++)this.addChildAt(arguments[e],a+e);return arguments[c-2]}b.parent&&b.parent.removeChild(b);b.parent=this;this.children.splice(a,0,b);return b};a.removeChild=function(b){var a=arguments.length;if(a>1){for(var c=true,e=0;e<a;e++)c=c&&this.removeChild(arguments[e]);return c}return this.removeChildAt(this.children.indexOf(b))};a.removeChildAt=function(b){var a=arguments.length;if(a>1){for(var c=[],e=0;e<a;e++)c[e]=arguments[e];c.sort(function(b,
a){return a-b});for(var d=true,e=0;e<a;e++)d=d&&this.removeChildAt(c[e]);return d}if(b<0||b>this.children.length-1)return false;a=this.children[b];if(a!=null)a.parent=null;this.children.splice(b,1);return true};a.removeAllChildren=function(){for(var b=this.children;b.length;)b.pop().parent=null};a.getChildAt=function(b){return this.children[b]};a.sortChildren=function(b){this.children.sort(b)};a.getChildIndex=function(b){return this.children.indexOf(b)};a.getNumChildren=function(){return this.children.length};
a.swapChildrenAt=function(b,a){var c=this.children,e=c[b],d=c[a];e&&d&&(c[b]=d,c[a]=e)};a.swapChildren=function(b,a){for(var c=this.children,e,d,f=0,g=c.length;f<g;f++)if(c[f]==b&&(e=f),c[f]==a&&(d=f),e!=null&&d!=null)break;f!=g&&(c[e]=a,c[d]=b)};a.setChildIndex=function(b,a){for(var c=this.children,e=0,d=c.length;e<d;e++)if(c[e]==b)break;e==d||a<0||a>d||e==a||(c.splice(a,1),a<e&&e--,c.splice(b,e,0))};a.contains=function(b){for(;b;){if(b==this)return true;b=b.parent}return false};a.hitTest=function(b,
a){return this.getObjectUnderPoint(b,a)!=null};a.getObjectsUnderPoint=function(b,a){var c=[],e=this.localToGlobal(b,a);this._getObjectsUnderPoint(e.x,e.y,c);return c};a.getObjectUnderPoint=function(b,a){var c=this.localToGlobal(b,a);return this._getObjectsUnderPoint(c.x,c.y)};a.clone=function(b){var a=new c;this.cloneProps(a);if(b)for(var h=a.children=[],e=0,d=this.children.length;e<d;e++){var f=this.children[e].clone(b);f.parent=a;h.push(f)}return a};a.toString=function(){return"[Container (name="+
this.name+")]"};a._tick=function(b){for(var a=this.children.length-1;a>=0;a--){var c=this.children[a];c._tick&&c._tick(b)}if(this.onTick)this.onTick(b)};a._getObjectsUnderPoint=function(b,a,h,e){var d=DisplayObject._hitTestContext,f=DisplayObject._hitTestCanvas,g=this._matrix,k=e&1&&(this.onPress||this.onClick||this.onDoubleClick)||e&2&&(this.onMouseOver||this.onMouseOut);if(this.cacheCanvas)if(this.getConcatenatedMatrix(g),d.setTransform(g.a,g.b,g.c,g.d,g.tx-b,g.ty-a),d.globalAlpha=g.alpha,this.draw(d),
this._testHit(d)){if(f.width=0,f.width=1,k)return this}else return null;for(var i=this.children.length-1;i>=0;i--){var l=this.children[i];if(l.isVisible()&&l.mouseEnabled)if(l instanceof c)if(k){if(l=l._getObjectsUnderPoint(b,a))return this}else{if(l=l._getObjectsUnderPoint(b,a,h,e),!h&&l)return l}else if(!e||k||e&1&&(l.onPress||l.onClick||l.onDoubleClick)||e&2&&(l.onMouseOver||l.onMouseOut))if(l.getConcatenatedMatrix(g),d.setTransform(g.a,g.b,g.c,g.d,g.tx-b,g.ty-a),d.globalAlpha=g.alpha,l.draw(d),
this._testHit(d))if(f.width=0,f.width=1,k)return this;else if(h)h.push(l);else return l}return null};j.Container=c})(window);(function(j){var c=function(b){this.initialize(b)},a=c.prototype=new Container;c._snapToPixelEnabled=false;a.autoClear=true;a.canvas=null;a.mouseX=null;a.mouseY=null;a.onMouseMove=null;a.onMouseUp=null;a.onMouseDown=null;a.snapToPixelEnabled=false;a.mouseInBounds=false;a.tickOnUpdate=true;a._activeMouseEvent=null;a._activeMouseTarget=null;a._mouseOverIntervalID=null;a._mouseOverX=0;a._mouseOverY=0;a._mouseOverTarget=null;a.Container_initialize=a.initialize;a.initialize=function(b){this.Container_initialize();
this.canvas=b instanceof HTMLCanvasElement?b:document.getElementById(b);this._enableMouseEvents(true)};a.update=function(b){if(this.canvas)this.autoClear&&this.clear(),c._snapToPixelEnabled=this.snapToPixelEnabled,this.tickOnUpdate&&this._tick(b),this.draw(this.canvas.getContext("2d"),false,this.getConcatenatedMatrix(this._matrix))};a.tick=a.update;a.clear=function(){if(this.canvas){var b=this.canvas.getContext("2d");b.setTransform(1,0,0,1,0,0);b.clearRect(0,0,this.canvas.width,this.canvas.height)}};
a.toDataURL=function(b,a){a||(a="image/png");var c=this.canvas.getContext("2d"),e=this.canvas.width,d=this.canvas.height,f;if(b){f=c.getImageData(0,0,e,d);var g=c.globalCompositeOperation;c.globalCompositeOperation="destination-over";c.fillStyle=b;c.fillRect(0,0,e,d)}var k=this.canvas.toDataURL(a);if(b)c.clearRect(0,0,e,d),c.putImageData(f,0,0),c.globalCompositeOperation=g;return k};a.enableMouseOver=function(b){if(this._mouseOverIntervalID)clearInterval(this._mouseOverIntervalID),this._mouseOverIntervalID=
null;if(b==null)b=20;else if(b<=0)return;var a=this;this._mouseOverIntervalID=setInterval(function(){a._testMouseOver()},1E3/Math.min(50,b));this._mouseOverX=NaN;this._mouseOverTarget=null};a.clone=function(){var b=new c(null);this.cloneProps(b);return b};a.toString=function(){return"[Stage (name="+this.name+")]"};a._enableMouseEvents=function(){var b=this,a=j.addEventListener?j:document;a.addEventListener("mouseup",function(a){b._handleMouseUp(a)},false);a.addEventListener("mousemove",function(a){b._handleMouseMove(a)},
false);a.addEventListener("dblclick",function(a){b._handleDoubleClick(a)},false);this.canvas&&this.canvas.addEventListener("mousedown",function(a){b._handleMouseDown(a)},false)};a._handleMouseMove=function(b){if(this.canvas){if(!b)b=j.event;var a=this.mouseInBounds;this._updateMousePosition(b.pageX,b.pageY);if(a||this.mouseInBounds){b=new MouseEvent("onMouseMove",this.mouseX,this.mouseY,this,b);if(this.onMouseMove)this.onMouseMove(b);if(this._activeMouseEvent&&this._activeMouseEvent.onMouseMove)this._activeMouseEvent.onMouseMove(b)}}else this.mouseX=
this.mouseY=null};a._updateMousePosition=function(b,a){var c=this.canvas;do b-=c.offsetLeft,a-=c.offsetTop;while(c=c.offsetParent);if(this.mouseInBounds=b>=0&&a>=0&&b<this.canvas.width&&a<this.canvas.height)this.mouseX=b,this.mouseY=a};a._handleMouseUp=function(b){var a=new MouseEvent("onMouseUp",this.mouseX,this.mouseY,this,b);if(this.onMouseUp)this.onMouseUp(a);if(this._activeMouseEvent&&this._activeMouseEvent.onMouseUp)this._activeMouseEvent.onMouseUp(a);if(this._activeMouseTarget&&this._activeMouseTarget.onClick&&
this._getObjectsUnderPoint(this.mouseX,this.mouseY,null,true,this._mouseOverIntervalID?3:1)==this._activeMouseTarget)this._activeMouseTarget.onClick(new MouseEvent("onClick",this.mouseX,this.mouseY,this._activeMouseTarget,b));this._activeMouseEvent=this._activeMouseTarget=null};a._handleMouseDown=function(b){if(this.onMouseDown)this.onMouseDown(new MouseEvent("onMouseDown",this.mouseX,this.mouseY,this,b));var a=this._getObjectsUnderPoint(this.mouseX,this.mouseY,null,this._mouseOverIntervalID?3:1);
if(a){if(a.onPress instanceof Function&&(b=new MouseEvent("onPress",this.mouseX,this.mouseY,a,b),a.onPress(b),b.onMouseMove||b.onMouseUp))this._activeMouseEvent=b;this._activeMouseTarget=a}};a._testMouseOver=function(){if(!(this.mouseX==this._mouseOverX&&this.mouseY==this._mouseOverY&&this.mouseInBounds)){var b=null;if(this.mouseInBounds)b=this._getObjectsUnderPoint(this.mouseX,this.mouseY,null,3),this._mouseOverX=this.mouseX,this._mouseOverY=this.mouseY;if(this._mouseOverTarget!=b){if(this._mouseOverTarget&&
this._mouseOverTarget.onMouseOut)this._mouseOverTarget.onMouseOut(new MouseEvent("onMouseOut",this.mouseX,this.mouseY,this._mouseOverTarget));if(b&&b.onMouseOver)b.onMouseOver(new MouseEvent("onMouseOver",this.mouseX,this.mouseY,b));this._mouseOverTarget=b}}};a._handleDoubleClick=function(b){if(this.onDoubleClick)this.onDoubleClick(new MouseEvent("onDoubleClick",this.mouseX,this.mouseY,this,b));var a=this._getObjectsUnderPoint(this.mouseX,this.mouseY,null,this._mouseOverIntervalID?3:1);if(a&&a.onDoubleClick instanceof
Function)a.onDoubleClick(new MouseEvent("onPress",this.mouseX,this.mouseY,a,b))};j.Stage=c})(window);(function(j){var c=function(b){this.initialize(b)},a=c.prototype=new DisplayObject;a.image=null;a.snapToPixel=true;a.sourceRect=null;a.DisplayObject_initialize=a.initialize;a.initialize=function(b){this.DisplayObject_initialize();typeof b=="string"?(this.image=new Image,this.image.src=b):this.image=b};a.isVisible=function(){return this.visible&&this.alpha>0&&this.scaleX!=0&&this.scaleY!=0&&this.image&&(this.image.complete||this.image.getContext||this.image.readyState>=2)};a.DisplayObject_draw=a.draw;
a.draw=function(b,a){if(this.DisplayObject_draw(b,a))return true;var c=this.sourceRect;c?b.drawImage(this.image,c.x,c.y,c.width,c.height,0,0,c.width,c.height):b.drawImage(this.image,0,0);return true};a.clone=function(){var b=new c(this.image);this.cloneProps(b);return b};a.toString=function(){return"[Bitmap (name="+this.name+")]"};j.Bitmap=c})(window);(function(j){var c=function(b){this.initialize(b)},a=c.prototype=new DisplayObject;a.onAnimationEnd=null;a.currentFrame=-1;a.currentAnimation=null;a.paused=true;a.spriteSheet=null;a.snapToPixel=true;a.offset=0;a.currentAnimationFrame=0;a._advanceCount=0;a._animation=null;a.DisplayObject_initialize=a.initialize;a.initialize=function(b){this.DisplayObject_initialize();this.spriteSheet=b};a.isVisible=function(){return this.visible&&this.alpha>0&&this.scaleX!=0&&this.scaleY!=0&&this.spriteSheet.complete&&
this.currentFrame>=0};a.DisplayObject_draw=a.draw;a.draw=function(b,a){if(this.DisplayObject_draw(b,a))return true;this._normalizeFrame();var c=this.spriteSheet.getFrame(this.currentFrame);if(c!=null){var e=c.rect;b.drawImage(c.image,e.x,e.y,e.width,e.height,-c.regX,-c.regY,e.width,e.height);return true}};a.play=function(){this.paused=false};a.stop=function(){this.paused=true};a.gotoAndPlay=function(b){this.paused=false;this._goto(b)};a.gotoAndStop=function(b){this.paused=true;this._goto(b)};a.advance=
function(){this._animation?this.currentAnimationFrame++:this.currentFrame++;this._normalizeFrame()};a.clone=function(){var b=new c(this.spriteSheet);this.cloneProps(b);return b};a.toString=function(){return"[BitmapAnimation (name="+this.name+")]"};a._tick=function(b){var a=this._animation?this._animation.frequency:1;!this.paused&&(++this._advanceCount+this.offset)%a==0&&this.advance();if(this.onTick)this.onTick(b)};a._normalizeFrame=function(){var b=this._animation;if(b)if(this.currentAnimationFrame>=
b.frames.length){if(b.next?this._goto(b.next):(this.paused=true,this.currentAnimationFrame=b.frames.length-1,this.currentFrame=b.frames[this.currentAnimationFrame]),this.onAnimationEnd)this.onAnimationEnd(this,b.name)}else this.currentFrame=b.frames[this.currentAnimationFrame];else if(this.currentFrame>=this.spriteSheet.getNumFrames()&&(this.currentFrame=0,this.onAnimationEnd))this.onAnimationEnd(this,null)};a.DisplayObject_cloneProps=a.cloneProps;a.cloneProps=function(b){this.DisplayObject_cloneProps(b);
b.onAnimationEnd=this.onAnimationEnd;b.currentFrame=this.currentFrame;b.currentAnimation=this.currentAnimation;b.paused=this.paused;b.offset=this.offset;b._animation=this._animation;b.currentAnimationFrame=this.currentAnimationFrame};a._goto=function(b){if(isNaN(b)){var a=this.spriteSheet.getAnimation(b);if(a)this.currentAnimationFrame=0,this._animation=a,this.currentAnimation=b,this._normalizeFrame()}else this.currentAnimation=this._animation=null,this.currentFrame=b};j.BitmapAnimation=c})(window);(function(j){var c=function(b){this.initialize(b)},a=c.prototype=new DisplayObject;a.graphics=null;a.DisplayObject_initialize=a.initialize;a.initialize=function(b){this.DisplayObject_initialize();this.graphics=b?b:new Graphics};a.isVisible=function(){return this.visible&&this.alpha>0&&this.scaleX!=0&&this.scaleY!=0&&this.graphics};a.DisplayObject_draw=a.draw;a.draw=function(b,a){if(this.DisplayObject_draw(b,a))return true;this.graphics.draw(b);return true};a.clone=function(b){b=new c(b&&this.graphics?
this.graphics.clone():this.graphics);this.cloneProps(b);return b};a.toString=function(){return"[Shape (name="+this.name+")]"};j.Shape=c})(window);(function(j){var c=function(b,a,c){this.initialize(b,a,c)},a=c.prototype=new DisplayObject;c._workingContext=document.createElement("canvas").getContext("2d");a.text="";a.font=null;a.color=null;a.textAlign=null;a.textBaseline=null;a.maxWidth=null;a.outline=false;a.lineHeight=null;a.lineWidth=null;a.DisplayObject_initialize=a.initialize;a.initialize=function(b,a,c){this.DisplayObject_initialize();this.text=b;this.font=a;this.color=c?c:"#000"};a.isVisible=function(){return Boolean(this.visible&&this.alpha>
0&&this.scaleX!=0&&this.scaleY!=0&&this.text!=null&&this.text!="")};a.DisplayObject_draw=a.draw;a.draw=function(b,a){if(this.DisplayObject_draw(b,a))return true;this.outline?b.strokeStyle=this.color:b.fillStyle=this.color;b.font=this.font;b.textAlign=this.textAlign?this.textAlign:"start";b.textBaseline=this.textBaseline?this.textBaseline:"alphabetic";for(var c=String(this.text).split(/(?:\r\n|\r|\n)/),e=this.lineHeight==null?this.getMeasuredLineHeight():this.lineHeight,d=0,f=0,g=c.length;f<g;f++){var k=
b.measureText(c[f]).width;if(this.lineWidth==null||k<this.lineWidth)this._drawTextLine(b,c[f],d);else{for(var k=c[f].split(/(\s)/),i=k[0],l=1,j=k.length;l<j;l+=2)b.measureText(i+k[l]+k[l+1]).width>this.lineWidth?(this._drawTextLine(b,i,d),d+=e,i=k[l+1]):i+=k[l]+k[l+1];this._drawTextLine(b,i,d)}d+=e}return true};a.getMeasuredWidth=function(){return this._getWorkingContext().measureText(this.text).width};a.getMeasuredLineHeight=function(){return this._getWorkingContext().measureText("M").width*1.2};
a.clone=function(){var b=new c(this.text,this.font,this.color);this.cloneProps(b);return b};a.toString=function(){return"[Text (text="+(this.text.length>20?this.text.substr(0,17)+"...":this.text)+")]"};a.DisplayObject_cloneProps=a.cloneProps;a.cloneProps=function(b){this.DisplayObject_cloneProps(b);b.textAlign=this.textAlign;b.textBaseline=this.textBaseline;b.maxWidth=this.maxWidth;b.outline=this.outline;b.lineHeight=this.lineHeight;b.lineWidth=this.lineWidth};a._getWorkingContext=function(){var b=
c._workingContext;b.font=this.font;b.textAlign=this.textAlign?this.textAlign:"start";b.textBaseline=this.textBaseline?this.textBaseline:"alphabetic";return b};a._drawTextLine=function(b,a,c){this.outline?b.strokeText(a,0,c,this.maxWidth):b.fillText(a,0,c,this.maxWidth||65535)};j.Text=c})(window);(function(j){var c=function(){throw"SpriteSheetUtils cannot be instantiated";};c._workingCanvas=document.createElement("canvas");c._workingContext=c._workingCanvas.getContext("2d");c.addFlippedFrames=function(a,b,j,h){if(b||j||h){var e=0;b&&c._flip(a,++e,true,false);j&&c._flip(a,++e,false,true);h&&c._flip(a,++e,true,true)}};c.extractFrame=function(a,b){isNaN(b)&&(b=a.getAnimation(b).frames[0]);var j=a.getFrame(b);if(!j)return null;var h=j.rect,e=c._workingCanvas;e.width=h.width;e.height=h.height;
c._workingContext.drawImage(j.image,h.x,h.y,h.width,h.height,0,0,h.width,h.height);j=new Image;j.src=e.toDataURL("image/png");return j};c._flip=function(a,b,j,h){for(var e=a._images,d=c._workingCanvas,f=c._workingContext,g=e.length/b,k=0;k<g;k++){var i=e[k];i.__tmp=k;d.width=i.width;d.height=i.height;f.setTransform(j?-1:1,0,0,h?-1:1,j?i.width:0,h?i.height:0);f.drawImage(i,0,0);var l=new Image;l.src=d.toDataURL("image/png");l.width=i.width;l.height=i.height;e.push(l)}f=a._frames;d=f.length/b;for(k=
0;k<d;k++){var i=f[k],o=i.rect.clone(),l=e[i.image.__tmp+g*b],m={image:l,rect:o,regX:i.regX,regY:i.regY};if(j)o.x=l.width-o.x-o.width,m.regX=o.width-i.regX;if(h)o.y=l.height-o.y-o.height,m.regY=o.height-i.regY;f.push(m)}j="_"+(j?"h":"")+(h?"v":"");h=a._animations;a=a._data;e=h.length/b;for(k=0;k<e;k++){f=h[k];i=a[f];g={name:f+j,frequency:i.frequency,next:i.next,frames:[]};i.next&&(g.next+=j);f=i.frames;i=0;for(l=f.length;i<l;i++)g.frames.push(f[i]+d*b);a[g.name]=g;h.push(g.name)}};j.SpriteSheetUtils=
c})(window);(function(j){var c=function(b){this.initialize(b)},a=c.prototype=new DisplayObject;a.htmlElement=null;a._style=null;a.DisplayObject_initialize=a.initialize;a.initialize=function(b){typeof b=="string"&&(b=document.getElementById(b));this.DisplayObject_initialize();this.mouseEnabled=false;if(this.htmlElement=b)this._style=b.style,this._style.position="absolute",this._style.transformOrigin=this._style.webkitTransformOrigin=this._style.msTransformOrigin=this._style.MozTransformOrigin="0% 0%"};a.isVisible=
function(){return this.htmlElement!=null};a.draw=function(){if(this.htmlElement!=null){var b=this._matrix,a=this.htmlElement;a.style.opacity=""+b.alpha;a.style.visibility=this.visible?"visible":"hidden";a.style.transform=a.style.webkitTransform=a.style.oTransform=a.style.msTransform=["matrix("+b.a,b.b,b.c,b.d,b.tx,b.ty+")"].join(",");a.style.MozTransform=["matrix("+b.a,b.b,b.c,b.d,b.tx+"px",b.ty+"px)"].join(",");return true}};a.cache=function(){};a.uncache=function(){};a.updateCache=function(){};
a.hitTest=function(){};a.localToGlobal=function(){};a.globalToLocal=function(){};a.localToLocal=function(){};a.clone=function(){var a=new c;this.cloneProps(a);return a};a.toString=function(){return"[DOMElement (name="+this.name+")]"};a._tick=function(a){if(this.htmlElement!=null&&(this.htmlElement.style.visibility="hidden",this.onTick))this.onTick(a)};j.DOMElement=c})(window);(function(j){var c=function(){this.initialize()},a=c.prototype;a.initialize=function(){};a.getBounds=function(){return new Rectangle(0,0,0,0)};a.applyFilter=function(){};a.toString=function(){return"[Filter]"};a.clone=function(){return new c};j.Filter=c})(window);(function(j){var c=function(){throw"Touch cannot be instantiated";};c.isSupported=function(){return"ontouchstart"in j};c.enable=function(a){if(a!=null&&c.isSupported())a._primaryTouchId=-1,a._handleTouchMoveListener=null,a.canvas.addEventListener("touchstart",function(b){c._handleTouchStart(a,b)},false),document.addEventListener("touchend",function(b){c._handleTouchEnd(a,b)},false)};c._handleTouchStart=function(a,b){b.preventDefault();if(a._primaryTouchId==-1){a._handleTouchMoveListener=a._handleTouchMoveListener||
function(b){c._handleTouchMove(a,b)};document.addEventListener("touchmove",a._handleTouchMoveListener,false);var j=b.changedTouches[0];a._primaryTouchId=j.identifier;a._updateMousePosition(j.pageX,j.pageY);a._handleMouseDown(j)}};c._handleTouchMove=function(a,b){var j=c._findPrimaryTouch(a,b.changedTouches);j&&a._handleMouseMove(j)};c._handleTouchEnd=function(a,b){var j=c._findPrimaryTouch(a,b.changedTouches);if(j)a._primaryTouchId=-1,a._handleMouseUp(j),document.removeEventListener("touchmove",a._handleTouchMoveListener),
a._handleTouchMoveListener=null};c._findPrimaryTouch=function(a,b){for(var c=b.length,h=0;h<c;h++){var e=b[h];if(e.identifier==a._primaryTouchId)return e}return null};j.Touch=c})(window);
;
	new TestMain();
}
TestMain.prototype.completionHandler = function(successful) {
	try {
		js.Lib.eval("testResult(" + successful + ");");
	} catch( e ) {
	}
}
TestMain.prototype.__class__ = TestMain;
massive.munit.AssertionException = function(msg,info) {
	if( msg === $_ ) return;
	massive.munit.MUnitException.call(this,msg,info);
	this.type = massive.haxe.util.ReflectUtil.here({ fileName : "AssertionException.hx", lineNumber : 49, className : "massive.munit.AssertionException", methodName : "new"}).className;
}
massive.munit.AssertionException.__name__ = ["massive","munit","AssertionException"];
massive.munit.AssertionException.__super__ = massive.munit.MUnitException;
for(var k in massive.munit.MUnitException.prototype ) massive.munit.AssertionException.prototype[k] = massive.munit.MUnitException.prototype[k];
massive.munit.AssertionException.prototype.__class__ = massive.munit.AssertionException;
massive.munit.async.AsyncFactory = function(observer) {
	if( observer === $_ ) return;
	this.observer = observer;
	this.asyncDelegateCount = 0;
}
massive.munit.async.AsyncFactory.__name__ = ["massive","munit","async","AsyncFactory"];
massive.munit.async.AsyncFactory.prototype.observer = null;
massive.munit.async.AsyncFactory.prototype.asyncDelegateCount = null;
massive.munit.async.AsyncFactory.prototype.createHandler = function(testCase,handler,timeout,info) {
	var delegate = new massive.munit.async.AsyncDelegate(testCase,handler,timeout,info);
	delegate.observer = this.observer;
	this.asyncDelegateCount++;
	this.observer.asyncDelegateCreatedHandler(delegate);
	return delegate.delegateHandler;
}
massive.munit.async.AsyncFactory.prototype.__class__ = massive.munit.async.AsyncFactory;
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
StringTools = function() { }
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && s.substr(0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && s.substr(slen - elen,elen) == end;
}
StringTools.isSpace = function(s,pos) {
	var c = s.charCodeAt(pos);
	return c >= 9 && c <= 13 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return s.substr(r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return s.substr(0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.rpad = function(s,c,l) {
	var sl = s.length;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		s += c.substr(0,l - sl);
		sl = l;
	} else {
		s += c;
		sl += cl;
	}
	return s;
}
StringTools.lpad = function(s,c,l) {
	var ns = "";
	var sl = s.length;
	if(sl >= l) return s;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		ns += c.substr(0,l - sl);
		sl = l;
	} else {
		ns += c;
		sl += cl;
	}
	return ns + s;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
StringTools.fastCodeAt = function(s,index) {
	return s.cca(index);
}
StringTools.isEOF = function(c) {
	return c != c;
}
StringTools.prototype.__class__ = StringTools;
massive.munit.util.MathUtil = function(p) {
}
massive.munit.util.MathUtil.__name__ = ["massive","munit","util","MathUtil"];
massive.munit.util.MathUtil.round = function(value,precision) {
	value = value * Math.pow(10,precision);
	return Math.round(value) / Math.pow(10,precision);
}
massive.munit.util.MathUtil.prototype.__class__ = massive.munit.util.MathUtil;
$_ = {}
js.Boot.__res = {}
js.Boot.__init();
{
	Object.prototype.iterator = function() {
      var o = this.instanceKeys();
      var y = this;
      return {
        cur : 0,
        arr : o,
        hasNext: function() { return this.cur < this.arr.length; },
        next: function() { return y[this.arr[this.cur++]]; }
      };
    }
	Object.prototype.instanceKeys = function(proto) {
      var keys = [];
      proto = !proto;
      for(var i in this) {
        if(proto && Object.prototype[i]) continue;
        keys.push(i);
      }
      return keys;
    }
}
js["XMLHttpRequest"] = window.XMLHttpRequest?XMLHttpRequest:window.ActiveXObject?function() {
	try {
		return new ActiveXObject("Msxml2.XMLHTTP");
	} catch( e ) {
		try {
			return new ActiveXObject("Microsoft.XMLHTTP");
		} catch( e1 ) {
			throw "Unable to create XMLHttpRequest object.";
		}
	}
}:(function($this) {
	var $r;
	throw "Unable to create XMLHttpRequest object.";
	return $r;
}(this));
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
	var d = Date;
	d.now = function() {
		return new Date();
	};
	d.fromTime = function(t) {
		var d1 = new Date();
		d1["setTime"](t);
		return d1;
	};
	d.fromString = function(s) {
		switch(s.length) {
		case 8:
			var k = s.split(":");
			var d1 = new Date();
			d1["setTime"](0);
			d1["setUTCHours"](k[0]);
			d1["setUTCMinutes"](k[1]);
			d1["setUTCSeconds"](k[2]);
			return d1;
		case 10:
			var k = s.split("-");
			return new Date(k[0],k[1] - 1,k[2],0,0,0);
		case 19:
			var k = s.split(" ");
			var y = k[0].split("-");
			var t = k[1].split(":");
			return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
		default:
			throw "Invalid date format : " + s;
		}
	};
	d.prototype["toString"] = function() {
		var date = this;
		var m = date.getMonth() + 1;
		var d1 = date.getDate();
		var h = date.getHours();
		var mi = date.getMinutes();
		var s = date.getSeconds();
		return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d1 < 10?"0" + d1:"" + d1) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
	};
	d.prototype.__class__ = d;
	d.__name__ = ["Date"];
}
massive.munit.async.AsyncDelegate.DEFAULT_TIMEOUT = 400;
massive.munit.client.HTTPClient.DEFAULT_SERVER_URL = "http://localhost:2000";
massive.munit.client.HTTPClient.DEFAULT_ID = "HTTPClient";
massive.munit.client.HTTPClient.CLIENT_HEADER_KEY = "munit-clientId";
massive.munit.client.HTTPClient.PLATFORM_HEADER_KEY = "munit-platformId";
massive.munit.client.HTTPClient.queue = [];
massive.munit.client.HTTPClient.responsePending = false;
massive.munit.TestClassHelper.META_TAG_BEFORE_CLASS = "BeforeClass";
massive.munit.TestClassHelper.META_TAG_AFTER_CLASS = "AfterClass";
massive.munit.TestClassHelper.META_TAG_BEFORE = "Before";
massive.munit.TestClassHelper.META_TAG_AFTER = "After";
massive.munit.TestClassHelper.META_TAG_TEST = "Test";
massive.munit.TestClassHelper.META_TAG_ASYNC_TEST = "AsyncTest";
massive.munit.TestClassHelper.META_TAG_IGNORE = "Ignore";
massive.munit.TestClassHelper.META_PARAM_ASYNC_TEST = "Async";
massive.munit.TestClassHelper.META_TAG_TEST_DEBUG = "TestDebug";
massive.munit.TestClassHelper.META_TAGS = ["BeforeClass","AfterClass","Before","After","Test","AsyncTest","TestDebug"];
massive.munit.Assert.assertionCount = 0;
ExampleTest.__meta__ = { fields : { beforeClass : { BeforeClass : null}, afterClass : { AfterClass : null}, setup : { Before : null}, tearDown : { After : null}, testExample : { Test : null}, testAsyncExample : { AsyncTest : null}, testExampleThatOnlyRunsWithDebugFlag : { TestDebug : null}}};
massive.munit.client.PrintClientBase.DEFAULT_ID = "simple";
massive.munit.client.PrintClient.DEFAULT_ID = "print";
massive.munit.client.RichPrintClient.DEFAULT_ID = "RichPrintClient";
v042.EaselJsTest.__meta__ = { fields : { beforeClass : { BeforeClass : null}, afterClass : { AfterClass : null}, setup : { Before : null}, tearDown : { After : null}, testExample : { Test : null}, testThatCanvasElementWorks : { Test : null}, testThatDisplayObjectContainsMethodsAndProperties : { Test : null}, testThatContainerContainsMethodsAndProperties : { Test : null}, testThatStageContainsMethodsAndProperties : { Test : null}, testAsyncExample : { AsyncTest : null}, testExampleThatOnlyRunsWithDebugFlag : { TestDebug : null}}};
v042.EaselJsTest.displayObjectProperties = ["snapToPixel","visible","mouseEnabled","parent","cacheID","alpha","skewX","skewY","scaleX","scaleY","rotation","x","regX","regY","id","name","y"];
v042.EaselJsTest.displayObjectMethods = ["cache","clone","draw","getCacheDataURL","getConcatenatedMatrix","getStage","globalToLocal","hitTest","isVisible","localToGlobal","localToLocal","setTransform","toString","uncache","updateCache"];
v042.EaselJsTest.containerProperties = ["children","DisplayObject_draw","DisplayObject_initialize"];
v042.EaselJsTest.containerMethods = ["addChild","addChildAt","contains","getChildAt","getChildIndex","getNumChildren","getObjectsUnderPoint","getObjectUnderPoint","removeAllChildren","removeChild","setChildIndex","sortChildren","swapChildren","swapChildrenAt"];
massive.munit.client.JUnitReportClient.DEFAULT_ID = "junit";
massive.munit.util.Timer.arr = new Array();
js.Lib.onerror = null;
TestMain.main()