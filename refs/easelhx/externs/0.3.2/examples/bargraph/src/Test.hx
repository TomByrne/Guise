// based on barChart example found at http://easeljs.com
import js.Lib;
import js.DomCanvas;
import easelhx.display.Stage;
import easelhx.display.Container;
import easelhx.display.Shape;
import easelhx.display.Text;
import easelhx.display.Graphics;
import easelhx.utils.Ticker;

class Test {
	
	var canvas : DomCanvas;
	var stage : Stage;
	var barPadding : Float;
	var barHeight : Float;
	var maxValue : Float;
	var count : Int;
	var barValues : Array<Int>;
	var bars : Array<Container>;

	public function new() {
		init();
	}
	
	function init() {
		
		barPadding = 7.;
		barHeight = 0.;
		maxValue = 50.;
		count = 0;
		barValues = [];
		bars = [];
		
		canvas = cast Lib.document.getElementById("testCanvas");
		trace("canvas "+canvas);
		stage =  new Stage(canvas);
		// enabled mouse over / out events
		stage.enableMouseOver(10);
		
		// generate some random data:
		var numBars = 4 + Math.ceil( Math.random()*6 );
		var max = 0; 
		for( i in 0...numBars ) {
			var val = 1 + Math.ceil( Math.random()*maxValue );
			if( val > max )
				max = val;
			barValues.push(val);
		}
		
		// calculate the bar width and height based on number of bars and width of canvas:
		var barWidth = (canvas.width-150-(numBars-1)*barPadding)/numBars;
		barHeight = canvas.height-150;
		
		// create a shape to draw the background into:
		var bg = new Shape();
		stage.addChild(bg);
	
		// draw the "shelf" at the bottom of the graph:
		// note how the drawing instructions can be chained together.
		bg.graphics.beginStroke("#444")
			.moveTo(40, canvas.height-69.5)
			.lineTo(canvas.width-70, canvas.height-69.5)
			.endStroke()
			.beginFill("#222")
			.moveTo(canvas.width-70, canvas.height-70)
			.lineTo(canvas.width-60, canvas.height-80)
			.lineTo(50, canvas.height-80)
			.lineTo(40, canvas.height-70)
			.closePath();
			
		// draw the horizontal lines in the background:
		for( i in 0...9 ) {
			bg.graphics.beginStroke((i%2 == 0) ? "#333" : "#444")
				.moveTo(50,(canvas.height-80-i/8*barHeight)+0.5)
				.lineTo(canvas.width-60,(canvas.height-80-i/8*barHeight)+0.5);
		}
		
		// add the graph title:
		var label = new Text("Bar Graph Example", "bold 30px Arial", "#FFF");
		label.textAlign = "center";
		label.x = canvas.width/2;
		label.y = 50;
		stage.addChild(label);
		
		// draw the bars:
		for( i in 0...numBars ) {
			// each bar is assembled in it's own Container, to make them easier to work with:
			var bar = new Container();
			//bar.mouseEnabled = false;
			bar.mouseEnabled = true;
			// this will determine the color of each bar, save as a property of the bar for use in drawBar:
			var hue = getHueForBarIndex(i, numBars);
			
			// draw the front panel of the bar, this will be scaled to the right size in drawBar:
			var front = new Shape();
			front.graphics.beginLinearGradientFill(
					[Graphics.getHSL(hue,100,60,0.9), Graphics.getHSL(hue,100,20,0.75)], [0.,1.], 0, -100, barWidth, 0
				)
				.drawRect(0,-100,barWidth,100);
				
			// draw the top of the bar, this will be positioned vertically in drawBar:
			var top = new Shape();
			top.graphics.beginFill(Graphics.getHSL(hue,100,70,0.9))
				.moveTo(10,-10)
				.lineTo(10+barWidth,-10)
				.lineTo(barWidth,0)
				.lineTo(0,0)
				.closePath();
			
			
			// if this has the max value, we can draw the star into the top:
			if( barValues[i] == max ) {
				top.graphics.beginFill("rgba(0,0,0,0.45)").drawPolyStar(barWidth/2, 31, 7, 5, 0.6, -90).closePath();
			}
				
			// prepare the side of the bar, this will be drawn dynamically in drawBar:
			var right = new Shape();
			right.x = barWidth-0.5;
			
			// create the label at the bottom of the bar:
			var label = new Text("Label "+i, "16px Arial", "#FFF");
			label.textAlign = "center";
			label.x = barWidth/2;
			label.maxWidth = barWidth;
			label.y = 26;
			label.alpha = 0.5;
			
			// draw the tab that is placed under the label:
			var tab = new Shape();
			tab.graphics.beginFill(Graphics.getHSL(hue,100,20))
				.drawRoundRectComplex(0,1,barWidth,38,0,0,10,10);
			
			// create the value label that will be populated and positioned by drawBar:
			var value = new Text("","bold 14px Arial","#000");
			value.textAlign = "center";
			value.x = barWidth / 2;
			value.alpha = 0.45;
			
			// add all of the elements to the bar Container:
			//bar.addChild(right,front,top,value,tab,label);
			bar.addChild(right);
			bar.addChild(front);
			bar.addChild(top);
			bar.addChild(value);
			bar.addChild(tab);
			bar.addChild(label);
			
			// position the bar, and add it to the stage:
			bar.x = i*(barWidth+barPadding)+60;
			bar.y = canvas.height-70;
			
			
			bar.onPress = function(e):Void{
				trace("onPress: "+ i);
				e.onMouseMove = function(ev) {
					trace("mouse mov");
				}
			};
			
			bar.onMouseOver = function(e){
				trace("onMouseOver: "+ i);
			};
			
			bar.onMouseOut = function(e){
				trace("onMouseOut: "+ i);
			};
			/*
			bar.onClick = function(e):Void{
				trace("hello: "+ i);
			};
			*/
			stage.addChild(bar);
			bars.push(bar);
			
			// draw the bar with an initial value of 0:
			drawBar(bar, 0, i);
		}
		
		// set up the count for animation based on the number of bars:
		count = numBars*10;
		
		// start the tick and point it at the window so we can do some work before updating the stage:
		Ticker.setInterval(50);		// 50 ms = 20 fps
		Ticker.addListener(this);
	}

	function tick() {
		// if we are on the last frame of animation, then remove the tick listener:
		if (--count == 1) { Ticker.removeListener(this); }
		
		// animate the bars in one at a time:
		var c = bars.length*10-count;
		var index = Std.int(c/10);
		var bar = bars[index];
		drawBar(bar, (c%10+1)/10*barValues[index], index);
		
		// update the stage:
		stage.tick();
	}
	
	function drawBar( bar : Container, value : Float, ?index : Int = 0 ) {
		
		// calculate bar height:
		var h = value/maxValue*barHeight;
		
		var hue = getHueForBarIndex(index, bars.length);
		
		// update the value label:
		var val : Text = cast bar.getChildAt(3);
		val.text = Std.string( Std.int(value) );
		val.visible = (h>28);
		val.y = -h+22;
		
		// scale the front panel, and position the top:
		bar.getChildAt(1).scaleY = h/100;
		bar.getChildAt(2).y = -h+0.5; // the 0.5 eliminates gaps from numerical precision issues.
		
		// redraw the side bar (we can't just scale it because of the angles):
		var right : Shape = cast bar.getChildAt(0);
		right.graphics.clear()
			.beginFill(Graphics.getHSL(hue,90,15,0.7))
			.moveTo(0,0)
			.lineTo(0,-h)
			.lineTo(10,-h-10)
			.lineTo(10,-10)
			.closePath();
	}
	
	function getHueForBarIndex( i : Int, numBars : Int ) : Int {
		return Std.int( i / numBars * 360 );
	}

	public static function main() {
		new Test();
	}
}
