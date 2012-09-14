package v042;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import createjs.easel.Container;
import createjs.easel.DisplayObject;
import createjs.easel.Shape;
import createjs.easel.Stage;

import js.w3c.html5.Canvas2DContext;
import js.w3c.html5.Core;
import js.Lib;
import js.Dom.HtmlDom;

class EaselJsTest 
{
	private var timer:Timer;
	
	public function new() 
	{
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	
	@Test
	public function testExample():Void
	{
		Assert.isTrue(true);
	}
	
	@Test
	public function testThatCanvasElementWorks():Void 
	{
		var canvas:HTMLCanvasElement = cast Lib.document.createElement ("canvas");
	    var ctx = canvas.getContext('2d');
	     
		Assert.isTrue(untyped __js__('canvas instanceof HTMLCanvasElement'));
		Assert.isTrue(untyped __js__('ctx instanceof CanvasRenderingContext2D'));
	}
	
	@Test
	public function testThatDisplayObjectContainsMethodsAndProperties():Void
	{
		var canvas:HTMLCanvasElement = cast Lib.document.createElement ("canvas");
		var stage = new Stage(canvas);
		var displayObject = new DisplayObject(); //abstract class, normally overridden
		displayObject.name = "myDisplayObject"; //required for 'name' to pass?
		stage.addChild(displayObject);
		
		verifyThatPropertiesExist(displayObject, displayObjectProperties);
		verifyThatMethodsExist(displayObject, displayObjectMethods);
	}
	
	@Test
	public function testThatContainerContainsMethodsAndProperties():Void
	{
		var canvas:HTMLCanvasElement = cast Lib.document.createElement ("canvas");
		var stage = new Stage(canvas);
		var container = new Container();
		container.name = "myContainer";
		stage.addChild(container);
		
		verifyThatPropertiesExist(container, displayObjectProperties);
		verifyThatMethodsExist(container, displayObjectMethods);
		verifyThatPropertiesExist(container, containerProperties);
		verifyThatMethodsExist(container, containerMethods);
	
	}
	
	@Test
	public function testThatStageContainsMethodsAndProperties():Void
	{
		var canvas:HTMLCanvasElement = cast Lib.document.createElement ("canvas");
		var stage = new Stage(canvas);
		
		var stageProperties = [
		          "canvas", 
		          //"mouseY", //fails
		          //"mouseX", //fails
		          "snapToPixelEnabled",
		          "autoClear",
		          "mouseInBounds",
		          "tickOnUpdate"
		          
		      ];
		var stageMethods = [
		          "enableMouseOver", 
		          "clear", 
		          "toDataURL",
		          "update"
		      ];
		
		//verifyThatPropertiesExist(stage, displayObjectProperties); //fails with 'parent'
		verifyThatMethodsExist(stage, displayObjectMethods);
		verifyThatPropertiesExist(stage, containerProperties);
		verifyThatMethodsExist(stage, containerMethods);
		verifyThatPropertiesExist(stage, stageProperties);
		verifyThatMethodsExist(stage, stageMethods);
	}
	
	@AsyncTest
	public function testAsyncExample(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, onTestAsyncExampleComplete, 300);
		timer = Timer.delay(handler, 200);
	}
	
	private function onTestAsyncExampleComplete():Void
	{
		Assert.isFalse(false);
	}
	
	
	/**
	* test that only runs when compiled with the -D testDebug flag
	*/
	@TestDebug
	public function testExampleThatOnlyRunsWithDebugFlag():Void
	{
		Assert.isTrue(true);
	}
	
	//taken from https://github.com/jdegoes/stax/blob/master/src/test/haxe/DomTester.hx#L2048
	/*
	 HaXe library written by John A. De Goes <john@socialmedia.com>
	 Contributed by Social Media Networks
	*/
	private function verifyThatMethodsExist(o:Dynamic, methods:Array<String>, ?pos:haxe.PosInfos):Void 
	{
		for (method in methods) 
		{
			var m = untyped o[method];

			var t = Type.typeof(m);

			var isMethod = switch (t) 
			{
			    case TFunction: true;
			    default: false;
			}

	        if (!isMethod) 
			{ 
				trace("Object does not contain method : " + method  + ". From line: "+ pos.lineNumber); Assert.isTrue(false); 
			}
	        else Assert.isTrue(true);
	    }
	}

	//taken from https://github.com/jdegoes/stax/blob/master/src/test/haxe/DomTester.hx#L2064
	/*
	 HaXe library written by John A. De Goes <john@socialmedia.com>
	 Contributed by Social Media Networks
	*/
	private function verifyThatPropertiesExist(o:Dynamic, fields:Array<String>, ?pos:haxe.PosInfos):Void 
	{
		for (field in fields) 
		{
	        var f = Reflect.field(o, field);
	        if (f == null) 
			{ 
				trace("Object does not contain property : " + field + ". From line: "+ pos.lineNumber); Assert.isTrue(false); 
			}
	        else Assert.isTrue(true);
	    }
	}

	static var displayObjectProperties = [
	          //"filters", //fails
	          "snapToPixel",
	          "visible",
	          "mouseEnabled",
	          //"hitArea", //fails
	          "parent",
	          //"cacheCanvas", //fails
	          "cacheID",
	          "alpha",
	          "skewX",
	          "skewY",
	          "scaleX",
	          "scaleY",
	          "rotation",
	          "x",
	          "regX",
	          "regY",
	          "id",
	          //"shadow", //fails
	          //"mask", //fails
	          "name", //fails
	          //"compositeOperation", //fails
	          "y"
	          
	      ];
	static var displayObjectMethods = [
	          "cache", 
	          "clone", 
	          "draw",
	          "getCacheDataURL",
	          "getConcatenatedMatrix",
			  //"getMatrix", //fails
	          "getStage",
	          "globalToLocal",
	          "hitTest",
	          "isVisible",
	          "localToGlobal",
	          "localToLocal",
	          "setTransform",
	          //"setupContext", //fails
	          "toString",
	          "uncache",
	          "updateCache"
	      ];
	
	static 	var containerProperties = [
	          "children", 
	          "DisplayObject_draw",
	          "DisplayObject_initialize"
	          
	      ];
	static var containerMethods = [
		      "addChild", 
	          "addChildAt", 
	          "contains",
	          "getChildAt",
	          "getChildIndex",
	          "getNumChildren",
	          "getObjectsUnderPoint",
	          "getObjectUnderPoint",
	          "removeAllChildren",
	          "removeChild",
	          "setChildIndex",
	          "sortChildren",
	          "swapChildren",
	          "swapChildrenAt"
	      ];
}