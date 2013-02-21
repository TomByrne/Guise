package guise.layout.simple;

import guise.layout.simple.StackLayout;

class HStackLayout extends StackLayout
{
	public function new(?topGap:Float, ?bottomGap:Float, ?leftGap:Float, ?rightGap:Float, ?itemGap:Float) 
	{
		super(StackDirection.HORIZONTAL);
		this.topGap = topGap;
		this.bottomGap = bottomGap;
		this.leftGap = leftGap;
		this.rightGap = rightGap;
		this.itemGap = itemGap;
	}
	
}

typedef HStackLayoutInfo = StackLayoutInfo;
typedef HStackSizePolicy = StackLayout.StackSizePolicy;