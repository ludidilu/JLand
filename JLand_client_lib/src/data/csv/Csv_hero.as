package data.csv
{
	import flash.utils.Dictionary;

	public class Csv_hero extends Csv
	{
		public static var dic:Dictionary = new Dictionary;
		public static var length:int;
		
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
		
		public var heroType:Csv_heroType;
		
		public static function fix():void{
			
			for each(var unit:Csv_hero in dic){
				
				unit.heroType = Csv_heroType.dic[unit.type];
			}
		}
	}
}