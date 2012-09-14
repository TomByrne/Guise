package ;

class MacroIssue  extends SuperClass<TypeParam>{
	public function new() {
		super(function():TypeParam { return new TypeParam(); } );
	}
}

class TypeParam implements ITypeParamRestraint{
	public function new(){}
}

@:autoBuild(MyMacro.inject())
class SuperClass<TypeParamType : ITypeParamRestraint> 
{
	public function new(layerInfoFact:Void->TypeParamType){}
}
interface ITypeParamRestraint {}





