package guiseSkins.styled.styles;
import composure.core.ComposeItem;
import composure.utilTraits.Furnisher;
import guise.controls.ControlLayers;
import guise.controls.ControlTags;
import guiseSkins.styled.BoxLayer;
import guiseSkins.styled.FilterLayer;
import guiseSkins.styled.FramingLayer;
import guiseSkins.styled.DefaultStyleTrans;
import guiseSkins.styled.SimpleShapeLayer;
import guiseSkins.styled.TextStyleLayer;
import guise.traits.states.ControlStates;
import guiseSkins.styled.Styles;
import nme.Assets;
import nme.text.Font;
import guise.platform.types.TextAccessTypes;
import guise.platform.types.DisplayAccessTypes;
import guise.controls.ControlLogic;

/**
 * ...
 * @author Tom Byrne
 */

class ChutzpahStyle 
{
	private static var _labelTextStyle:TextLabelStyle;
	private static var _inputTextStyle:TextLabelStyle;
	private static var _labelTextAlign:FramingStyle;
	private static var _inputTextAlign:FramingStyle;
	
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
	
	private static var _inputBackNorm:BoxStyle;
	private static var _inputBackFocus:BoxStyle;
	
	private static var _buttonFiltNorm:Array<FilterType>;
	private static var _buttonFiltDown:Array<FilterType>;
	
	private static var _styleTransitioner:DefaultStyleTrans;

	public static function install(within:ComposeItem):Void 
	{
		NormalLayering.install(within);
		ControlLogic.install(within);
		
		if(_buttonBackNorm==null){
		
			var font = Assets.getFont ("assets/fonts/HelveticaNeueLTPro-Bd.otf");
			//var font = Assets.getFont ("assets/fonts/HelveticaNeueLTPro-Bd.ttf");
			//var font = Assets.getFont ("assets/fonts/HelveticaNeueLTCom-Bd.ttf");
			
			var fontData = (font==null?TfSans:Tf(font.fontName));
		
			_styleTransitioner = new DefaultStyleTrans() ;
		
			_buttonBackNorm = BsCapsule(		FsHLinearGradient([ { c:0xffffff, a:1, fract:0 }, { c:0xeeeeee, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])));
			_buttonBackOver = BsCapsule(		FsHLinearGradient([ { c:0xffffff, a:1, fract:0 }, { c:0xeeeeee, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])));
			_buttonBackDownUnsel = BsCapsule(	FsHLinearGradient([ { c:0xdadada, a:1, fract:0 }, { c:0xececec, a:1, fract:1 } ]), SsNone);
			
			_buttonBackSelNorm = BsCapsule(		FsHLinearGradient([ { c:0xdadada, a:1, fract:0 }, { c:0xececec, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])));
			_buttonBackSelOver = BsCapsule(		FsHLinearGradient([ { c:0xdadada, a:1, fract:0 }, { c:0xececec, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])));
		
			_inputBackNorm = BsRectComplex(		FsHLinearGradient([ { c:0xffffff, a:1, fract:0 }, { c:0xeeeeee, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])), CSame(CsCirc(5)));
			_inputBackFocus = BsRectComplex(	FsHLinearGradient([ { c:0xdadada, a:1, fract:0 }, { c:0xececec, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])), CSame(CsCirc(5)));
			
		
			_toggleBackNorm = BsCapsule(		FsHLinearGradient([ { c:0xffffff, a:1, fract:0 }, { c:0xeeeeee, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])), Fixed(26), Fixed(12), FromWidth(0.5,-13), FromHeight(0.5,-6));
			_toggleBackSelNorm = BsCapsule(		FsHLinearGradient([ { c:0xdeefff, a:1, fract:0 }, { c:0xc8d7e5, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])), Fixed(26), Fixed(12), FromWidth(0.5,-13), FromHeight(0.5,-6));
			
			_toggleNormUnsel = 	SsEllipse(	FsHLinearGradient([ { c:0xffffff, a:1, fract:0 }, { c:0xeeeeee, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])), Fixed(16), Fixed(16), FromWidth(0.5,-15), FromHeight(0.5,-9));
			_toggleOverUnsel = 	SsEllipse(	FsHLinearGradient([ { c:0xffffff, a:1, fract:0 }, { c:0xeeeeee, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])), Fixed(16), Fixed(16), FromWidth(0.5,-15), FromHeight(0.5,-9));
			_toggleNormSel = 	SsEllipse(	FsHLinearGradient([ { c:0xdadada, a:1, fract:0 }, { c:0xececec, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])), Fixed(16), Fixed(16), FromWidth(0.5, -1), FromHeight(0.5,-9));
			_toggleOverSel = 	SsEllipse(	FsHLinearGradient([ { c:0xdadada, a:1, fract:0 }, { c:0xececec, a:1, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, a:1, fract:0 }, { c:0xdddddd, a:1, fract:1 } ])), Fixed(16), Fixed(16), FromWidth(0.5, -1), FromHeight(0.5,-9));
			
			
			_buttonFiltNorm = [DropShadow(1, Math.PI/2, 2, 0x000000, 0.56)];
			_buttonFiltDown = [DropShadow(1, Math.PI / 2, 4, 0x000000, 0.42, true)];
			
			_labelTextStyle = Tls(Trs(fontData, 11, 0x8e8e8e, [TmBold()]), false, TcUpper, AaSmooth);
			_inputTextStyle = Tls(Trs(fontData, 11, 0x8e8e8e, [TmBold()]), true, TcUpper, AaSmooth);
			_labelTextAlign = Frame(ConstrainMin, ScaleDownOnly(), ScaleDownOnly(), 0,6,0,6);
			_inputTextAlign = Frame(Fill,ScaleAlways,ScaleDownOnly(), 2,3,2,3);
			
			_buttonTextFiltNorm = [DropShadow(1, Math.PI/2, 1, 0xffffff, 0.65)];
		}
		
		var furnisher = new Furnisher(TextButtonTag, [TFact(buttonBacking), TFact(buttonFilter), TFact(labelText), TFact(labelTextAlign), TFact(textFilt(ControlLayers.LABEL_TEXT))]);
		furnisher.addTrait(TInst(_styleTransitioner));
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(TextLabelTag, [TFact(labelText), TFact(labelTextAlign), TFact(textFilt(ControlLayers.LABEL_TEXT))]);
		furnisher.addTrait(TInst(_styleTransitioner));
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(TextInputTag, [TFact(inputBacking), TFact(inputFilter), TFact(inputText), TFact(inputTextAlign), TFact(textFilt(ControlLayers.INPUT_TEXT))]);
		furnisher.addTrait(TInst(_styleTransitioner));
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(ToggleButtonTag, [TFact(toggleBacking), TFact(toggleFilter), TFact(toggleHandle), TFact(toggleHandleFilter)]);
		furnisher.addTrait(TInst(_styleTransitioner));
		within.addTrait(furnisher);
	}
	private static function buttonBacking(tag:Dynamic):BoxLayer {
		var boxLayer:BoxLayer = new BoxLayer(ControlLayers.BACKING);
		boxLayer.normalStyle = _buttonBackNorm;
		boxLayer.addStyle([ButtonOverState.OVER, SelectedState.UNSELECTED], _buttonBackOver);
		boxLayer.addStyle([ButtonDownState.DOWN, SelectableState.UNSELECTABLE], _buttonBackDownUnsel, 1);
		boxLayer.addStyle([SelectedState.SELECTED, ButtonOverState.OUT], _buttonBackSelNorm);
		boxLayer.addStyle([SelectedState.SELECTED, ButtonOverState.OVER], _buttonBackSelOver);
		return boxLayer;
	}
	private static function toggleBacking(tag:Dynamic):BoxLayer {
		var boxLayer:BoxLayer = new BoxLayer(ControlLayers.BACKING);
		boxLayer.normalStyle = _toggleBackNorm;
		boxLayer.addStyle([SelectedState.SELECTED], _toggleBackSelNorm);
		return boxLayer;
	}
	private static function labelText(tag:Dynamic):TextStyleLayer {
		return new TextStyleLayer(ControlLayers.LABEL_TEXT, _labelTextStyle);
	}
	private static function inputText(tag:Dynamic):TextStyleLayer {
		return new TextStyleLayer(ControlLayers.INPUT_TEXT, _inputTextStyle);
	}
	private static function textFilt(layerName:String):Dynamic->FilterLayer {
		return function(tag:Dynamic):FilterLayer{
			var filterLayer:FilterLayer = new FilterLayer(layerName);
			filterLayer.normalStyle = _buttonTextFiltNorm;
			return filterLayer;
		}
	}
	private static function buttonFilter(tag:Dynamic):FilterLayer {
		var filterLayer:FilterLayer = new FilterLayer(ControlLayers.BACKING);
		filterLayer.normalStyle = _buttonFiltNorm;
		filterLayer.addStyle([ButtonDownState.DOWN], _buttonFiltDown);
		return filterLayer;
	}
	private static function toggleFilter(tag:Dynamic):FilterLayer {
		var filterLayer:FilterLayer = new FilterLayer(ControlLayers.BACKING);
		filterLayer.normalStyle = _buttonFiltDown;
		return filterLayer;
	}
	private static function toggleHandleFilter(tag:Dynamic):FilterLayer {
		var filterLayer:FilterLayer = new FilterLayer(ControlLayers.CONTROL_HANDLE);
		filterLayer.normalStyle = _buttonFiltNorm;
		filterLayer.addStyle([ButtonDownState.DOWN], _buttonFiltDown);
		return filterLayer;
	}
	
	private static function inputTextAlign(tag:Dynamic):FramingLayer {
		return new FramingLayer(ControlLayers.INPUT_TEXT, _inputTextAlign);
	}
	private static function labelTextAlign(tag:Dynamic):FramingLayer {
		return new FramingLayer(ControlLayers.LABEL_TEXT, _labelTextAlign);
	}
	
	private static function inputBacking(tag:Dynamic):BoxLayer {
		var boxLayer:BoxLayer = new BoxLayer(ControlLayers.BACKING);
		boxLayer.normalStyle = _inputBackNorm;
		boxLayer.addStyle([FocusState.FOCUSED], _inputBackFocus);
		return boxLayer;
	}
	private static function inputFilter(tag:Dynamic):FilterLayer {
		var boxFilterLayer:FilterLayer = new FilterLayer(ControlLayers.BACKING);
		boxFilterLayer.normalStyle = _buttonFiltNorm;
		boxFilterLayer.addStyle([FocusState.FOCUSED], _buttonFiltDown);
		return boxFilterLayer;
	}
	
	private static function toggleHandle(tag:Dynamic):SimpleShapeLayer {
		var shape:SimpleShapeLayer = new SimpleShapeLayer(ControlLayers.CONTROL_HANDLE);
		shape.normalStyle = _toggleNormUnsel;
		shape.addStyle([ButtonOverState.OVER, SelectedState.UNSELECTED], _toggleOverUnsel);
		shape.addStyle([SelectedState.SELECTED, ButtonOverState.OUT], _toggleNormSel);
		shape.addStyle([SelectedState.SELECTED, ButtonOverState.OVER], _toggleOverSel);
		return shape;
	}
}