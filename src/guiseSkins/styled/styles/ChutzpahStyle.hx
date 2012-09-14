package guiseSkins.styled.styles;
import composure.core.ComposeItem;
import composure.utilTraits.Furnisher;
import guise.controls.ControlLayers;
import guise.traits.tags.ControlTags;
import guiseSkins.styled.BoxLayer;
import guiseSkins.styled.FilterLayer;
import guiseSkins.styled.FramingLayer;
import guiseSkins.styled.DefaultStyleTrans;
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
		
			_buttonBackNorm = BsCapsule(		FsHLinearGradient([ { c:0xffffff, fract:0 }, { c:0xeeeeee, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, fract:0 }, { c:0xdddddd, fract:1 } ])));
			_buttonBackOver = BsCapsule(		FsHLinearGradient([ { c:0xffffff, fract:0 }, { c:0xeeeeee, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, fract:0 }, { c:0xdddddd, fract:1 } ])));
			_buttonBackDownUnsel = BsCapsule(	FsHLinearGradient([ { c:0xdadada, fract:0 }, { c:0xececec, fract:1 } ]), SsNone);
			
			_buttonBackSelNorm = BsCapsule(		FsHLinearGradient([ { c:0xdadada, fract:0 }, { c:0xececec, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, fract:0 }, { c:0xdddddd, fract:1 } ])));
			_buttonBackSelOver = BsCapsule(		FsHLinearGradient([ { c:0xdadada, fract:0 }, { c:0xececec, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, fract:0 }, { c:0xdddddd, fract:1 } ])));
		
			_inputBackNorm = BsRectComplex(		FsHLinearGradient([ { c:0xffffff, fract:0 }, { c:0xeeeeee, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, fract:0 }, { c:0xdddddd, fract:1 } ])), CSame(CsCirc(5)));
			_inputBackFocus = BsRectComplex(	FsHLinearGradient([ { c:0xdadada, fract:0 }, { c:0xececec, fract:1 } ]), SsSolid(1, FsHLinearGradient([ { c:0xa5a5a5, fract:0 }, { c:0xdddddd, fract:1 } ])), CSame(CsCirc(5)));
			
			
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
	}
	private static function buttonBacking():BoxLayer {
		var boxLayer:BoxLayer = new BoxLayer(ControlLayers.BACKING);
		boxLayer.normalStyle = _buttonBackNorm;
		boxLayer.addStyle([ButtonOverState.OVER, SelectedState.UNSELECTED], _buttonBackOver);
		boxLayer.addStyle([ButtonDownState.DOWN, SelectableState.UNSELECTABLE], _buttonBackDownUnsel, 1);
		boxLayer.addStyle([SelectedState.SELECTED, ButtonOverState.OUT], _buttonBackSelNorm);
		boxLayer.addStyle([SelectedState.SELECTED, ButtonOverState.OVER], _buttonBackSelOver);
		return boxLayer;
	}
	private static function labelText():TextStyleLayer {
		return new TextStyleLayer(ControlLayers.LABEL_TEXT, _labelTextStyle);
	}
	private static function inputText():TextStyleLayer {
		return new TextStyleLayer(ControlLayers.INPUT_TEXT, _inputTextStyle);
	}
	private static function textFilt(layerName:String):Void->FilterLayer {
		return function():FilterLayer{
			var boxFilterLayer:FilterLayer = new FilterLayer(layerName);
			boxFilterLayer.normalStyle = _buttonTextFiltNorm;
			return boxFilterLayer;
		}
	}
	private static function buttonFilter():FilterLayer {
		var boxFilterLayer:FilterLayer = new FilterLayer(ControlLayers.BACKING);
		boxFilterLayer.normalStyle = _buttonFiltNorm;
		boxFilterLayer.addStyle([ButtonDownState.DOWN], _buttonFiltDown);
		return boxFilterLayer;
	}
	
	private static function inputTextAlign():FramingLayer {
		return new FramingLayer(ControlLayers.INPUT_TEXT, _inputTextAlign);
	}
	private static function labelTextAlign():FramingLayer {
		return new FramingLayer(ControlLayers.LABEL_TEXT, _labelTextAlign);
	}
	
	private static function inputBacking():BoxLayer {
		var boxLayer:BoxLayer = new BoxLayer(ControlLayers.BACKING);
		boxLayer.normalStyle = _inputBackNorm;
		boxLayer.addStyle([FocusState.FOCUSED], _inputBackFocus);
		return boxLayer;
	}
	private static function inputFilter():FilterLayer {
		var boxFilterLayer:FilterLayer = new FilterLayer(ControlLayers.BACKING);
		boxFilterLayer.normalStyle = _buttonFiltNorm;
		boxFilterLayer.addStyle([FocusState.FOCUSED], _buttonFiltDown);
		return boxFilterLayer;
	}
}