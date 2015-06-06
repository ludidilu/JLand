package data.map
{
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import data.Data;
	import data.csv.Csv_map;
	
	import loader.SuperURLLoader;

	public class Map
	{
		private static const path:String = "map/";
		
		private static var dic:Dictionary;
		
		private static var loadNum:int;
		
		private static var callBack:Function;
		
		public static function init(_callBack:Function = null):void{
			
			callBack = _callBack;
			
			loadNum = Csv_map.length;
			
			dic = new Dictionary;
			
			for each(var unit:Csv_map in Csv_map.dic){
				
				SuperURLLoader.load(Data.path + path + unit.name,URLLoaderDataFormat.BINARY,loadMapOK,unit.id);
			}
		}
		
		private static function loadMapOK(e:Event,_id:int):void{
			
			var byteArray:ByteArray = e.target.data;
			
			var unit:MapUnit = new MapUnit;
			
			unit.mapWidth = byteArray.readInt();
			
			unit.mapHeight = byteArray.readInt();
			
			var length:int = byteArray.readInt();
			
			for(var i:int = 0 ; i < length ; i++){
				
				var pos:int = byteArray.readInt();
				
				var state:int = byteArray.readInt();
				
				unit.dic[pos] = state;
			}
			
			unit.init();
			
			dic[_id] = unit;
			
			loadNum--;
			
			if(loadNum == 0){
				
				if(callBack != null){
					
					callBack();
					
					callBack = null;
				}
			}
		}
		
		public static function getMap(_id:int):MapUnit{
			
			return dic[_id];
		}
	}
}