package guiseSkins.styled.styles;
import haxe.macro.Context;
import haxe.macro.Expr;

class StyleGenerator 
{

	@:macro public static function path(path:String):Expr {
		return interpXmlFile(path);
	}
	@:macro public static function trace(e:Expr):Expr {
		trace(e);
		return e;
	}
	
	#if macro
	
	private static function interpXmlFile(path:String):Expr {
		var content = sys.io.File.getContent(path);
		return interpXml(Xml.parse(content).firstElement());
	}
	
	private static function interpXml(xml:Xml):Expr {
		var pos = Context.currentPos();
		
		var tags:Array<Expr> = [];
		for (child in xml.elements()) {
			switch(child.nodeName) {
				case "tag": interpTag(child, tags);
				default: // ignore
			}
		}
		
		if (tags.length>0) {
			tags.unshift(macro var trait:AbstractTrait = new AbstractTrait());
			tags.unshift(macro var injector:Injector);
			tags.push(macro within.addTrait(trait));
		}
		
		return {expr:EBlock(tags), pos:pos};
	}
	private static function interpTag(tag:Xml, addTo:Array<Expr>):Void {
		var pos = Context.currentPos();
		
		var type:String = tag.get("type");
		
		var handleType:String;
		if (tag.get("isEnum") == "true") {
			handleType = type.substr(0, type.lastIndexOf("."));
		}else {
			handleType = type;
		}
		
		var catchType:Expr = createIdent(type);
		var handleType:ComplexType = createComplexType(handleType);
		
		var addBlock:Array<Expr> = [];
		var removeBlock:Array<Expr> = [];
		for (child in tag.elements()) {
			switch(child.nodeName) {
				case "layer": interpLayer(child, addBlock, removeBlock);
			}
		}
		
		var addExpr = { expr:EBlock(addBlock), pos:pos };
		var removeExpr = { expr:EBlock(removeBlock), pos:pos };
		var addHandler:Expr = macro function(trait:$handleType, item:ComposeItem):Void $addExpr;
		var removeHandler:Expr = macro function(trait:$handleType, item:composure.core.ComposeItem):Void $removeExpr;
		addTo.push(macro injector = new Injector($catchType, $addHandler, $removeHandler, true, true));
		addTo.push(macro injector.passThroughItem = true);
		addTo.push(macro trait.addInjector(injector));
	}
	private static function interpLayer(tag:Xml, addBlock:Array<Expr>, removeBlock:Array<Expr>):Void {
		var pos = Context.currentPos();
		var natStr:String = tag.get("natures");
		var natArr:Array<Expr> = [];
		
		if(natStr!=null && natStr.length>0){
			var natures:Array<String> = natStr.split(",");
			
			for (naturePath in natures) {
				natArr.push(createIdent(naturePath));
			}
		}
		var layerName = Context.makeExpr(tag.get("name"), pos);
		var natureExpr:Expr = { expr : EArrayDecl(natArr), pos:pos };
		addBlock.push(macro item.addTrait(new LayerAccessRequire($layerName, $natureExpr)));
		
		// need to figure out how best to remove traits
	}
	private static function createComplexType(typePath:String):ComplexType {
		var parts = typePath.split(".");
		return  TPath( { name : parts.pop(), pack : parts, params : [], sub : null } );
	}
	private static function createIdent(typePath:String):Expr {
		var pos = Context.currentPos();
		
		if ((typePath.charAt(0) == "'" && typePath.charAt(typePath.length - 1) == "'") || 
			(typePath.charAt(0) == '"' && typePath.charAt(typePath.length - 1) == '"')) {
				
			return { expr : EConst(CString(typePath.substring(1, typePath.length-1))), pos:pos };
		}
		var bracket = typePath.indexOf("(");
		var paramsE:Array<Expr>;
		if (bracket != -1) {
			var params = typePath.substring(bracket + 1, typePath.length - 1).split(",");
			typePath = typePath.substr(0, bracket);
			paramsE = [];
			for (param in params) {
				paramsE.push(createIdent(param));
			}
		}else {
			paramsE = null;
		}
		var parts = typePath.split(".");
		var ret:Expr;
		for (part in parts) {
			if (ret == null) {
				ret = { expr : EConst(CIdent(part)), pos:pos };
			}else {
				ret = { expr : EField( ret, part), pos : pos };
			}
		}
		if (paramsE != null) {
			return { expr:ECall(ret, paramsE), pos:pos };
		}else{
			return ret;
		}
	}
	
	#end
}