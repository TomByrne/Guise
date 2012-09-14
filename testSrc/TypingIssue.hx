package ;

class TypingIssue 
{

	public function new() 
	{
		registerType(ISpecific1, createClass1);
		registerType(ISpecific2, createClass2);
	}
	private function registerType < MyKlass : MyType, MyType : IGeneral > (type:Class<MyType>, creator:Void->MyKlass):Void {
		
	}
	private function createClass1():SpecificClass1 {
		return null;
	}
	private function createClass2():SpecificClass2 {
		return null;
	}
	
}
interface IGeneral { }

interface ISpecific1 implements IGeneral{}
interface ISpecific2 implements IGeneral{}

interface SpecificClass1 implements ISpecific1{}
interface SpecificClass2 implements ISpecific2{}