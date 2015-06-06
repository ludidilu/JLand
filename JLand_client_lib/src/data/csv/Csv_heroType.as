package data.csv
{
	import flash.utils.Dictionary;

	public class Csv_heroType extends Csv
	{
		public static var dic:Dictionary = new Dictionary;
		public static var length:int;
		
		public var name:String;
		public var attackType:int;
		public var attackRange:int;
	}
}