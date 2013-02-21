package guise.layout.simple;

import guise.layout.simple.StackLayout;

class VStackLayout extends StackLayout
{
	public function new(?topGap:Float, ?bottomGap:Float, ?leftGap:Float, ?rightGap:Float, ?itemGap:Float) 
	{
		super(StackDirection.VERTICAL);
		this.topGap = topGap;
		this.bottomGap = bottomGap;
		this.leftGap = leftGap;
		this.rightGap = rightGap;
		this.itemGap = itemGap;
	}
	
}

typedef VStackLayoutInfo = StackLayoutInfo;
typedef VStackSizePolicy = StackLayout.StackSizePolicy;