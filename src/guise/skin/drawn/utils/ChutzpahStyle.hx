package guise.skin.drawn.utils;
import composure.core.ComposeItem;
import composure.injectors.Injector;
import composure.traits.AbstractTrait;
import composure.utilTraits.Furnisher;
import guise.controls.ControlLayers;
import guise.controls.ControlTags;
import guise.controls.data.INumRange;
import guise.layer.LayerAccessRequire;
import guise.skin.drawn.BoxLayer;
import guise.skin.drawn.FilterLayer;
import guise.skin.drawn.utils.DrawnStyleTrans;
import guise.skin.drawn.SimpleShapeLayer;
import guise.skin.drawn.TextStyleLayer;
import guise.states.ControlStates;
import guise.skin.values.Bind;
import guise.skin.values.Calc;
import guise.skin.values.IValue;
import guise.skin.values.Value;
import nme.Assets;
import nme.text.Font;
import guise.layout.IBoxPos;
import guise.accessTypes.IFilterableAccess;
import guise.accessTypes.ITextOutputAccess;
import guise.skin.drawn.utils.DrawnStyles;
import xmlTools.CodeGenMacro;


class ChutzpahStyle 
{
	private static var _labelTextStyle:TextLabelStyle;
	private static var _inputTextStyle:TextLabelStyle;
	//private static var _labelTextAlign:FramingStyle;
	//private static var _inputTextAlign:FramingStyle;
	
	private static var _buttonTextFiltNorm:Array<FilterType>;
	
	private static var _buttonBackNorm:BoxStyle;
	private static var _buttonBackOver:BoxStyle;
	private static var _buttonBackDownUnsel:BoxStyle;
	private static var _buttonBackSelNorm:BoxStyle;
	private static var _buttonBackSelOver:BoxStyle;
	
	private static var _toggleBackNorm:BoxStyle;
	private static var _toggleBackSelNorm:BoxStyle;
	
	private static var _toggleNormUnsel:ShapeStyle;
	private static var _toggleOverUnsel:ShapeStyle;
	private static var _toggleNormSel:ShapeStyle;
	private static var _toggleOverSel:ShapeStyle;
	
	private static var _hSliderBackNorm:BoxStyle;
	
	private static var _sliderX:IValue;
	private static var _sliderY:IValue;
	private static var _sliderNorm:ShapeStyle;
	private static var _sliderOver:ShapeStyle;
	
	private static var _inputBackNorm:BoxStyle;
	private static var _inputBackFocus:BoxStyle;
	
	private static var _buttonFiltNorm:Array<FilterType>;
	private static var _buttonFiltDown:Array<FilterType>;
	
	private static var _styleTransitioner:DrawnStyleTrans;

	public static function install(within:ComposeItem):Void 
	{
		NormalLayering.install(within);
		//ControlLogic.install(within);
		
		if(_buttonBackNorm==null){
		
			//var font = Assets.getFont ("assets/fonts/HelveticaNeueLTPro-Bd.otf");
			var font = Assets.getFont ("assets/fonts/HelveticaNeueLTPro-Bd.ttf");
			//var font = Assets.getFont ("assets/fonts/HelveticaNeueLTCom-Bd.ttf");
			
			var fontData = (font==null?TfSans:Tf(font.fontName));
		
			_styleTransitioner = new DrawnStyleTrans() ;
			
			var normStroke 			= SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ]));
			var overStroke 			= SsSolid(1, FsHLinearGradient([ { c:0x959595, a:1, fract:0 }, { c:0xbbbbbb, a:1, fract:1 } ]));
			var normGradient 	= FsHLinearGradient([ { c:0xffffff, a:1, fract:0 }, { c:0xeeeeee, a:1, fract:1 } ]);
			var overGradient 	= FsHLinearGradient([ { c:0xffffff, a:1, fract:0 }, { c:0xf3f3f3, a:1, fract:1 } ]);
			var downGradient 	= FsHLinearGradient([ { c:0xdadada, a:1, fract:0 }, { c:0xececec, a:1, fract:1 } ]);
			var blueGradient 	= FsHLinearGradient([ { c:0xdeefff, a:1, fract:0 }, { c:0xc8d7e5, a:1, fract:1 } ]);
		
			_buttonBackNorm = BsCapsule(		normGradient, normStroke);
			_buttonBackOver = BsCapsule(		overGradient, overStroke);
			_buttonBackDownUnsel = BsCapsule(	downGradient, SsNone);
			
			_buttonBackSelNorm = BsCapsule(		downGradient, normStroke);
			_buttonBackSelOver = BsCapsule(		downGradient, overStroke);
		
			_inputBackNorm = BsRectComplex(		normGradient, normStroke, CSame(CsCirc(5)));
			_inputBackFocus = BsRectComplex(	downGradient, overStroke, CSame(CsCirc(5)));
			
		
			_toggleBackNorm = BsCapsule(		normGradient, normStroke, new Value(26), new Value(12), val(IBoxPos, "w", "sizeChanged", 0.5,-13), val(IBoxPos, "h", "sizeChanged",0.5,-6));
			_toggleBackSelNorm = BsCapsule(		blueGradient, normStroke, new Value(26), new Value(12), val(IBoxPos, "w", "sizeChanged", 0.5,-13), val(IBoxPos, "h", "sizeChanged",0.5,-6));
			
			_toggleNormUnsel = 	SsEllipse(	normGradient, normStroke, new Value(16), new Value(16), val(IBoxPos, "w", "sizeChanged", 0.5,-15), val(IBoxPos, "h", "sizeChanged", 0.5,-9));
			_toggleOverUnsel = 	SsEllipse(	overGradient, overStroke, new Value(16), new Value(16), val(IBoxPos, "w", "sizeChanged", 0.5,-15), val(IBoxPos, "h", "sizeChanged", 0.5,-9));
			_toggleNormSel = 	SsEllipse(	normGradient, normStroke, new Value(16), new Value(16), val(IBoxPos, "w", "sizeChanged", 0.5, -1), val(IBoxPos, "h", "sizeChanged", 0.5,-9));
			_toggleOverSel = 	SsEllipse(	overGradient, overStroke, new Value(16), new Value(16), val(IBoxPos, "w", "sizeChanged", 0.5, -1), val(IBoxPos, "h", "sizeChanged", 0.5,-9));
			
		
			_hSliderBackNorm = BsCapsule(		normGradient, normStroke, null, new Value(12), null, val(IBoxPos, "h", "sizeChanged",0.5,-6));
			
			_sliderX = new Calc(Add, [new Calc(Multiply, [new Bind(INumRange, "valueNorm", "rangeChanged"), new Calc(Add, [new Bind(IBoxPos, "w", "sizeChanged"), new Value(-4)])]), new Value(4)]);
			_sliderY = val(IBoxPos, "h", "sizeChanged", 0.5);
			_sliderNorm = 	SsMulti([SsEllipse(	normGradient, normStroke, new Value(16), new Value(16), new Value(-8), new Value(-8)),
										SsEllipse(	FsSolid(0xc1c1c1), SsSolid(1, FsHLinearGradient([ { c:0x979797, a:1, fract:0 }, { c:0xfefefe, a:1, fract:1 } ])), new Value(5), new Value(5), new Value(-2.5), new Value(-2.5))]);
			_sliderOver = 	SsMulti([SsEllipse(	overGradient, overStroke, new Value(16), new Value(16), new Value(-8), new Value(-8)),
										SsEllipse(	FsSolid(0xc1c1c1), SsSolid(1, FsHLinearGradient([ { c:0x979797, a:1, fract:0 }, { c:0xfefefe, a:1, fract:1 } ])), new Value(5), new Value(5), new Value(-2.5), new Value(-2.5))]);
			
			
			_buttonFiltNorm = [DropShadow(1, Math.PI/2, 2, 0x000000, 0.56)];
			_buttonFiltDown = [DropShadow(1, Math.PI / 2, 4, 0x000000, 0.42, true)];
			
			_labelTextStyle = Tls(Trs(fontData, 11, 0x8e8e8e, [TmBold()]), false, TcUpper, AaSmooth, HAlign.Center, VAlign.Middle);
			_inputTextStyle = Tls(Trs(fontData, 11, 0x8e8e8e, [TmBold()]), true, TcUpper, AaSmooth, null, VAlign.Middle, new Value(5), new Value(5), new Value(5), new Value(5));
			//_labelTextAlign = Frame(ConstrainMin, ScaleDownOnly(), ScaleDownOnly(), 0,6,0,6);
			//_inputTextAlign = Frame(Fill,ScaleAlways,ScaleDownOnly(), 2,3,2,3);
			
			_buttonTextFiltNorm = [DropShadow(1, Math.PI/2, 1, 0xffffff, 0.65)];
		}
		
		var furnisher = new Furnisher(TextButtonTag(false), [TFact(buttonBacking), TFact(buttonBackingFilt), TFact(labelText)/*, TFact(labelTextAlign)*/]);
		furnisher.add(TInst(_styleTransitioner));
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(TextLabelTag, [TFact(labelText), TFact(labelTextFilt)]);
		furnisher.add(TInst(_styleTransitioner));
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(TextInputTag, [TFact(inputBacking), TFact(inputBackingFilt), TFact(inputText), TFact(inputTextFilt)]);
		furnisher.add(TInst(_styleTransitioner));
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(ToggleButtonTag, [TFact(toggleBacking), TFact(toggleBackingFilt), TFact(toggleHandle), TFact(toggleHandleFilt)]);
		furnisher.add(TInst(_styleTransitioner));
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(SliderTag(false), [TFact(hSliderBacking), TFact(sliderHandle), TFact(sliderHandleFilt)]);
		furnisher.checkEnumParams = [0];
		furnisher.add(TInst(_styleTransitioner));
		within.addTrait(furnisher);
		
		//FurnisherMacro.trace(guise.controls.ControlTags.TextButtonTag(true));
		CodeGenMacro.path("/../../../../../Styles/Chutzpah.xml").install(within);
		
		
		/*{
		var trait:AbstractTrait = new AbstractTrait();
		var injector:Injector;
		injector = new Injector(guise.controls.ControlTags.TextInputTag, function(trait:guise.controls.ControlTags, item:composure.core.ComposeItem):Void { item.addTrait(new LayerAccessRequire("inputText", [guise.accessTypes.ITextInputAccess, guise.accessTypes.ITextOutputAccess, guise.accessTypes.IBoxPosAccess, guise.accessTypes.IFilterableAccess])); }, function(trait:guise.controls.ControlTags, item:composure.core.ComposeItem):Void { }, true, true);
		injector.passThroughItem = true;
		trait.addInjector(injector);
		//within.addTrait(trait);
		}*/
	}
	private static function val(traitType:Dynamic, prop:String, changeSignal:String, multi:Float=1, offset:Float=0):IValue {
		var ret:IValue = new Bind(traitType, prop, changeSignal);
		if (multi != 1) {
			ret = new Calc(Multiply, [ret, new Value(multi)]);
		}
		if (offset != 0) {
			ret = new Calc(Add, [ret, new Value(offset)]);
		}
		return ret;
	}
	private static function buttonBacking(tag:Dynamic):BoxLayer {
		var boxLayer:BoxLayer = new BoxLayer(ControlLayers.BACKING);
		boxLayer.normalStyle = _buttonBackNorm;
		boxLayer.addStyle([SelectedState.SELECTED, ButtonOverState.OUT], _buttonBackSelNorm);
		boxLayer.addStyle([SelectedState.SELECTED, ButtonOverState.OVER], _buttonBackSelOver);
		boxLayer.addStyle([ButtonOverState.OVER, SelectedState.UNSELECTED], _buttonBackOver);
		boxLayer.addStyle([ButtonDownState.DOWN, SelectableState.UNSELECTABLE], _buttonBackDownUnsel, 1);
		
		return boxLayer;
	}
	private static function buttonBackingFilt(tag:Dynamic):FilterLayer {
		var filterLayer:FilterLayer = new FilterLayer(ControlLayers.BACKING);
		filterLayer.normalStyle = _buttonFiltNorm;
		filterLayer.addStyle([ButtonDownState.DOWN], _buttonFiltDown);
		
		return filterLayer;
	}
	private static function toggleBacking(tag:Dynamic):BoxLayer {
		var boxLayer:BoxLayer = new BoxLayer(ControlLayers.BACKING);
		boxLayer.normalStyle = _toggleBackNorm;
		boxLayer.addStyle([SelectedState.SELECTED], _toggleBackSelNorm);
		
		return boxLayer;
	}
	private static function toggleBackingFilt(tag:Dynamic):FilterLayer {
		var filterLayer:FilterLayer = new FilterLayer(ControlLayers.BACKING);
		filterLayer.normalStyle = _buttonFiltDown;
		
		return filterLayer;
	}
	private static function hSliderBacking(tag:Dynamic):BoxLayer {
		var boxLayer:BoxLayer = new BoxLayer(ControlLayers.BACKING);
		boxLayer.normalStyle = _hSliderBackNorm;
		return boxLayer;
	}
	private static function labelText(tag:Dynamic):TextStyleLayer {
		var textLayer = new TextStyleLayer(ControlLayers.LABEL_TEXT, _labelTextStyle);
		return textLayer;
	}
	private static function labelTextFilt(tag:Dynamic):FilterLayer {
		var filterLayer:FilterLayer = new FilterLayer(ControlLayers.LABEL_TEXT);
		filterLayer.normalStyle = _buttonTextFiltNorm;
		
		return filterLayer;
	}
	private static function inputText(tag:Dynamic):TextStyleLayer {
		var textLayer = new TextStyleLayer(ControlLayers.INPUT_TEXT, _inputTextStyle);
		return textLayer;
	}
	private static function inputTextFilt(tag:Dynamic):FilterLayer {
		var filterLayer:FilterLayer = new FilterLayer(ControlLayers.INPUT_TEXT);
		filterLayer.normalStyle = _buttonTextFiltNorm;
		
		return filterLayer;
	}
	
	private static function inputBacking(tag:Dynamic):BoxLayer {
		var boxLayer:BoxLayer = new BoxLayer(ControlLayers.BACKING);
		boxLayer.normalStyle = _inputBackNorm;
		boxLayer.addStyle([FocusState.FOCUSED], _inputBackFocus);
		
		return boxLayer;
	}
	private static function inputBackingFilt(tag:Dynamic):FilterLayer {
		var filterLayer:FilterLayer = new FilterLayer(ControlLayers.BACKING);
		filterLayer.normalStyle = _buttonFiltNorm;
		filterLayer.addStyle([FocusState.FOCUSED], _buttonFiltDown);
		
		return filterLayer;
	}
	
	private static function toggleHandle(tag:Dynamic):SimpleShapeLayer {
		var shape:SimpleShapeLayer = new SimpleShapeLayer(ControlLayers.CONTROL_HANDLE);
		shape.normalStyle = _toggleNormUnsel;
		shape.addStyle([ButtonOverState.OVER, SelectedState.UNSELECTED], _toggleOverUnsel);
		shape.addStyle([SelectedState.SELECTED, ButtonOverState.OUT], _toggleNormSel);
		shape.addStyle([SelectedState.SELECTED, ButtonOverState.OVER], _toggleOverSel);
		
		return shape;
	}
	
	private static function toggleHandleFilt(tag:Dynamic):FilterLayer {
		var filterLayer:FilterLayer = new FilterLayer(ControlLayers.CONTROL_HANDLE);
		filterLayer.normalStyle = _buttonFiltNorm;
		filterLayer.addStyle([ButtonDownState.DOWN], _buttonFiltDown);
		
		return filterLayer;
	}
	
	private static function sliderHandle(tag:Dynamic):SimpleShapeLayer {
		var shape:SimpleShapeLayer = new SimpleShapeLayer(ControlLayers.CONTROL_HANDLE);
		shape.xValue = _sliderX;
		shape.yValue = _sliderY;
		shape.normalStyle = _sliderNorm;
		shape.addStyle([ButtonOverState.OVER], _sliderOver);
		
		return shape;
	}
	private static function sliderHandleFilt(tag:Dynamic):FilterLayer {
		var filterLayer:FilterLayer = new FilterLayer(ControlLayers.CONTROL_HANDLE);
		filterLayer.normalStyle = _buttonFiltNorm;
		filterLayer.addStyle([ButtonDownState.DOWN], _buttonFiltDown);
		
		return filterLayer;
	}
}