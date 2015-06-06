package data.csv
{
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import data.Data;
	
	import loader.SuperURLLoader;

	public class Csv
	{
		private static var callBack:Function;
		private static const path:String = "csv/";
		private static var loadNum:int = 4;
		
//		private static var dic:Dictionary = new Dictionary;
		
		private static const VECTOR_NAME1:String = "Vector.<";
		private static const VECTOR_NAME2:String = ">";
		private static var clsDic:Dictionary;
		
		public var id:int;
		
		public function Csv()
		{
		}
		
		public static function init(_callBack:Function = null):void{
			
			callBack = _callBack;
			
			clsDic = new Dictionary;
			
			clsDic["str"] = "String";
			clsDic["int"] = "int";
			clsDic["boo"] = "Boolean";
			
			loadCsv("connect",Csv_connect,getCsv);
			loadCsv("map",Csv_map,getCsv);
			loadCsv("heroType",Csv_heroType,getCsv);
			loadCsv("hero",Csv_hero,getCsv);
		}
		
//		public static function getCsvUnit(_name:String):CsvUnit{
//			
//			return dic[_name];
//		}
		
		private static function getCsv():void{
			
			loadNum--;
			
			if(loadNum == 0){
				
				Csv_hero.fix();
				
				if(callBack != null){
					
					callBack();
					
					callBack = null;
				}
			}
		}
		
		private static function loadCsv(_name:String,_class:Class,_callBack:Function = null):void{
			
			SuperURLLoader.load(Data.path + path + _name + ".csv",URLLoaderDataFormat.TEXT,getCsvData,_name,_class,_callBack);
		}
		
		private static function getCsvData(e:Event,_name:String,_cls:Class,_callBack:Function):void{
			
			var nameVec:Array;
			var typeVec:Array;
			
			var str:String = e.target.data;
			
			var strVec:Array = str.split("\r\n");
			
			var index:int;
			
			for each(var tmpStr:String in strVec){
				
				if(tmpStr == "" || tmpStr.indexOf("//") != -1){
					
					continue;
				}
				
				if(index == 0){
					
					nameVec = tmpStr.split(",");
					
				}else if(index == 1){
					
					typeVec = tmpStr.split(",");
					
				}else{
					
					var tmpStr2:Array = tmpStr.split(",");
					
					var o:Object = new _cls;
					
					for(var i:int = 0 ; i < nameVec.length ; i++){
						
						if(!o.hasOwnProperty(nameVec[i])){
							
							continue;
						}
						
						if(i >= tmpStr2.length){
							
							var ss:String = "";
							
						}else{
							
							ss = tmpStr2[i];
						}
						
						var strLength:int = typeVec[i].length;
						
						var type:String = typeVec[i].slice(0,3);
						
						var times:int = (strLength - 3) * 0.5;
						
						o[nameVec[i]] = split(ss,times,type);
					}
					
					_cls.dic[o.id] = o;
				}
				
				index++;
			}
			
			_cls.length = index - 2;
			
			if(_callBack != null){
				
				_callBack();
			}
		}
		
		private static function split(_str:String,_times:int,_type:String):Object{
			
			if(_str == "null"){
				
				return null;
			}
			
			if(_times == 0){
				
				switch(_type){
					
					case "int":
						
						return int(_str);
						
					case "str":
						
						return _str;
						
					default:
						
						if(_str == "false"){
							
							return false;
							
						}else{
							
							return true;
						}
				}
			}
			
			if(_str != ""){
				
				var splitStr:String = "";
				
				for(var i:int = 0 ; i < _times ; i++){
					
					splitStr = splitStr + "$";
				}
				
				var arr:Array = _str.split(splitStr);
				
			}else{
				
				arr = new Array;
			}
			
			var tmpStr:String = clsDic[_type];
			
			for(i = 0 ; i < _times ; i++){
				
				tmpStr = VECTOR_NAME1 + tmpStr + VECTOR_NAME2;
			}
			
			var cls:Class = Class(getDefinitionByName(tmpStr));
			
			var objVec:Object = new cls;
			
			for(i = 0 ; i < arr.length ; i++){
				
				objVec[i] = split(arr[i],_times - 1,_type);
			}
			
			return objVec;
		}
	}
}