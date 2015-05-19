package data
{
	import data.csv.Csv;
	import data.map.Map;
	import data.resource.Resource;

	public class Data
	{
		public static const path:String = "http://127.0.0.1/JLand/data/";
		
		private static var callBack:Function;
		
		private static var initNum:int = 2;
		
		public function Data()
		{
		}
		
		public static function init(_callBack:Function = null):void{
			
			callBack = _callBack;
			
			Resource.init(oneInitOK);
			
			Csv.init(oneInitOK);
		}
		
		private static function oneInitOK():void{
			
			initNum--;
			
			if(initNum == 0){
			
				Map.init(mapInitOK);
			}
		}
		
		private static function mapInitOK():void{
			
			if(callBack != null){
				
				callBack();
				
				callBack = null;
			}
		}
	}
}