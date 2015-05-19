package data.csv
{
	public class Csv_hero extends Csv
	{
		
		public static const TYPE_VEC:Vector.<String> = Vector.<String>(["步","弓","枪","骑"]);
		
		public var name:String;
		public var picName:String;
		public var type:int;
		public var star:int;
		public var maxHp:int;
		public var atk:int;
		public var maxPower:int;
		
		public var skillCondition:Vector.<int>;
		public var skillConditionArg:Vector.<int>;
		
		public var comment:String;
	}
}