package guise.utils;

/**
 * ...
 * @author Tom Byrne
 */

class TitleCase 
{

	public static function toTitleCase(str:String):String 
	{
		var newString:String="";
		var myArray:Array<String> = str.split(" ");
		for (i in 0...myArray.length) {
			if (i > 0) newString += " ";
			var part:String = myArray[i];
			newString+=part.substr(0,1).toUpperCase();
			newString+=part.substr(1,part.length).toLowerCase();
		}
		return newString;
	}
	
}