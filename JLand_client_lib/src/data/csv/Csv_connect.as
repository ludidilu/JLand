package data.csv
{
	import flash.utils.Dictionary;

	public class Csv_connect extends Csv
	{	
		public static var dic:Dictionary = new Dictionary;
		public static var length:int;
		
		public var methodName:String;
		public var arg:Vector.<String>;
		public var type:int;
	}
}