package xmlTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Tools;

class CodeGenMacro 
{

	@:macro public static function path(path:String, ?scope:Expr):Expr {
		return interpXmlFile(path, scope);
	}
	/*@:macro public static function trace(e:Expr):Expr {
		trace(e);
		return macro null;
	}*/
	
	#if macro
	
	private static function interpXmlFile(path:String, ?scope:Expr):Expr {
		var pos = Context.currentPos();
		
		var content = sys.io.File.getContent(path);
		return interpXml(Xml.parse(content).firstElement(), scope);
	}
	
	private static function interpXml(xml:Xml, ?scope:Expr):Expr {
		var pos = Context.currentPos();
		
		var exprs:Array<Expr> = [];
		interpElement(scope, xml, exprs);
		if(exprs.length==1){
			return exprs[0];
		}else {
			return { expr:EBlock(exprs), pos:pos };
		}
	}
	private static function interpElement(within:Expr, tag:Xml, addTo:Array<Expr>):Void {
		switch(tag.nodeName) {
			case "obj": interpObj(within, tag, addTo);
			case "class": interpClass(within, tag, addTo);
			default: trace("Unknown tag: "+tag.nodeName);
		}
	}
	private static function interpClass(within:Expr, tag:Xml, addTo:Array<Expr>):Void {
		var pos = Context.currentPos();
		var classpath:String = tag.get("classpath");
		
		var fields:Array<Field> = [];
		for (child in tag.elements()) {
			switch(child.nodeName) {
				case "meth": interpMeth(child, fields);
				default: trace("Unknown tag: "+child.nodeName);
			}
		}
			
		var pack = classpath.split(".");
		var name:String = pack.pop();
		var typeDef:TypeDefinition = { pack:pack, name:name, pos:pos , meta:[], params:[], isExtern:false, kind:TDClass(), fields:fields};
		Context.defineType(typeDef);
		var classE:Expr = Context.parse(classpath, pos);
		addTo.push(Context.parse(classpath, pos));
	}
	private static function interpMeth(tag:Xml, addTo:Array<Field>):Void {
		var pos = Context.currentPos();
		var name:String = tag.get("name");
		var access:Array<Access> = [];
		if (tag.get("static") == "true") access.push(AStatic);
		if (tag.get("public") == "true") access.push(APublic);
		
		var args:Array<FunctionArg> = [];
		for (att in tag.attributes()) {
			var nameStart:String = att.substr(0, 2);
			if (nameStart=="a-") {
				createArg(args, att.substr(2), tag.get(att), false);
			}
		}
		
		for (child in tag.elements()) {
			var nameStart:String = child.nodeName.substr(0, 2);
			if (nameStart == "a-") {
				createArg(args, child.nodeName.substr(2), child.get("value"), child.get("opt")=="true");
			}
		}
		var scope:String = tag.get("scope");
		var scopeE:Expr;
		if (scope != null && scope.length != 0) {
			scopeE = Context.parse(scope, pos);
		}
		
		var exprs:Array<Expr> = [];
		interpBlock(scopeE, tag, exprs);
		var expr:Expr;
		if(exprs.length==1){
			expr = exprs[0];
		}else {
			expr = { expr:EBlock(exprs), pos:pos };
		}
		var func:Function = { args:args, ret:createComplexType(tag.get("ret")), expr:{ expr:EBlock(exprs), pos:pos }, params:[] };
		addTo.push({ name:name, access:access, kind:FFun(func), pos:pos});
	}
	private static function createArg(addTo:Array<FunctionArg>, name:String, value:String, opt:Bool):Void {
		addTo.push( { name:name, opt:opt, type:createComplexType(value)} );
	}
	private static function createComplexType(type:String):Null<ComplexType> {
		if (type == null || type.length == 0) {
			return null;
		}else {
			var pack = type.split(".");
			var name:String = pack.pop();
			return TPath( { pack:pack, name:name, params:[] } ) ;
		}
	}
	private static function interpObj(within:Expr, tag:Xml, addTo:Array<Expr>):Void {
		var pos = Context.currentPos();
		
		var type:String = tag.get("type");
		var nameE:Expr;
		var subWithin:Expr;
		if(type!=null && type.length>0){
			var params:String = tag.get("params");
			if (params == null) params = "";
			
			var name:String = tag.get("name");
			if(name==null || name.length==0)name = "obj_" + addTo.length;
			nameE = Context.parse(name, pos);
			
			// instantiate
			var instant = Context.parse("new " + type + "(" + params + ")", pos);
			addTo.push( { expr : EVars([ { expr : instant, name : name, type : null } ]), pos : pos } );
			
			subWithin = nameE;
		}else {
			subWithin = within;
		}
		
		var subExprs:Array<Expr> = [];
		interpBlock(subWithin, tag, subExprs);
		
		if (subExprs.length>0) {
			addTo.push( { expr : EBlock(subExprs), pos : pos } );
		}
		
		if(type!=null && type.length>0){
			// add to parent
			var addCall:String = tag.get("addCall");
			if (addCall != null && addCall.length > 0) {
				if (within == null) {
					addTo.push( { expr : ECall( Context.parse(addCall, pos), [ nameE ]), pos : pos } );
				}else {
					addTo.push( { expr : ECall( { expr : EField( within, addCall), pos : pos }, [ nameE ]), pos : pos } );
				}
			}
		}
	}
	private static function interpBlock(within:Expr, tag:Xml, addTo:Array<Expr>):Void {
		for (att in tag.attributes()) {
			var nameStart:String = att.substr(0, 2);
			if (nameStart=="m-") {
				callMethod(addTo, within, att.substr(2), tag.get(att));
			}else if (nameStart == "p-") {
				setProp(addTo, within, att.substr(2), tag.get(att));
			}
		}
		
		for (child in tag.elements()) {
			var nameStart:String = child.nodeName.substr(0, 2);
			if (nameStart == "m-") {
				callMethod(addTo, within, child.nodeName.substr(2), child.get("params"));
				
			}else if (nameStart == "p-") {
				setProp(addTo, within, child.nodeName.substr(2), child.get("value"));
				
			}else if (nameStart == "a-") {
				// ignore
				
			}else{
				interpElement(within, child, addTo);
			}
		}
	}
	private static function setProp(addTo:Array<Expr>, within:Expr, prop:String, value:String):Void {
		var pos = Context.currentPos();
		var field:Expr;
		if (within == null) {
			field = Context.parse(prop, pos);
		}else {
			field = { expr : EField(within, prop), pos : pos };
		}
		addTo.push( { expr : EBinop(OpAssign, field, Context.parse(value, pos)), pos : pos } );
	}
	private static function callMethod(addTo:Array<Expr>, within:Expr, meth:String, params:String):Void {
		var pos = Context.currentPos();
		var argsE:Expr = Context.parse("[" + params + "]", pos);
		var args:Array<Expr>;
		switch(argsE.expr) {
			case EArrayDecl(arr):
				args = arr;
			default: throw "Something went wrong";
		}
		var field:Expr;
		if (within == null) {
			field = Context.parse(meth, pos);
		}else {
			field = { expr : EField(within, meth), pos : pos };
		}
		addTo.push( { expr : ECall( field, args), pos : pos } );
	}
	
	#end
}