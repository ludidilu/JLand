package publicTools.connect
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import data.csv.Csv;
	import data.csv.CsvUnit;
	import data.csv.Csv_connect;
	
	import starling.core.Starling;

	public class Connect
	{
		private static var sk:Socket;
		private static const url:String = "127.0.0.1";
		private static var port:int;
		private static var callBack:Function;
		
		private static var i:int,m:int,n:int;
		private static var str:String;
		private static var length:int = -1;
		private static var debugSendStr:String;
		
		private static var arr:Array;
		private static var arr2:Array;
		private static var method:Function;
		private static var strLength:int;
		private static var times:int;
		
		private static const VECTOR_NAME1:String = "Vector.<";
		private static const VECTOR_NAME2:String = ">";
		
		private static var clsDic:Dictionary;
		
		private static var csvUnit:CsvUnit;
		
		public function Connect()
		{
		}
		
		public static function init(_port:int,_callBack:Function = null):void{
			
			clsDic = new Dictionary;
			
			clsDic["str"] = "String";
			clsDic["int"] = "int";
			clsDic["boo"] = "Boolean";
			
			port = _port;
			
			callBack = _callBack;
			
			csvUnit = Csv.getCsvUnit("connect");
			
			sk = new Socket;
			
			sk.addEventListener(Event.CONNECT,connected);
			sk.addEventListener(Event.CLOSE,closed);
			sk.addEventListener(IOErrorEvent.IO_ERROR,error);
			
			connect();
		}
		
		public static function connect():void{
			
			sk.connect(url,port);
		}
		
		private static function connected(e:Event):void{
			
			trace("连接服务器成功");
			
			sk.addEventListener(ProgressEvent.SOCKET_DATA,getData);
			
			if(callBack != null){
				
				callBack();
				
				callBack = null;
			}
		}
		
		private static function getData(e:ProgressEvent):void{
			
			while((sk.bytesAvailable > 3 && length == -1) || (sk.bytesAvailable == length)){
				
				if(length == -1){
				
					length = sk.readInt();
				}

				if(length <= sk.bytesAvailable){
					
					str = sk.readMultiByte(length,"UTF-8");
					
					handleData(str);
					
					length = -1;
				}
			}
		}
		
		private static function handleData(_str:String):void{
			
//			trace("getData:",_str);
			
			arr = _str.split("\n");
			
			var unit:Csv_connect = csvUnit.dic[arr.shift()];
			
			trace("收到服务器的包:",unit.methodName);
			
			if(unit.type == 1){
				
				Starling.current.touchable = true;
			}
			
			method = Connect_handle[unit.methodName];
			
			for(i = 0 ; i < unit.arg.length ; i++){
				
				strLength = unit.arg[i].length;
				
				str = unit.arg[i].slice(0,3);
				
				times = (strLength - 3) * 0.5;
				
				arr[i] = split(arr[i],times,str);
			}
			
			method.apply(null,arr);
		}
		
		private static function closed(e:Event):void{
			
			trace("connection closed");
		}
		
		private static function error(e:IOErrorEvent):void{
			
			trace("connection error");
			
			throw new Error("connection error");
		}
		
		internal static function sendData(_id:int,arg:Array):void{
			
			Starling.current.touchable = false;
			
			debugSendStr = _id + "\n";
			
			sk.writeUTFBytes(_id + "\n");
			
			var unit:Csv_connect = csvUnit.dic[_id];
			
			for(i = 0 ; i < unit.arg.length ; i++){
				
				strLength = unit.arg[i].length;

				times = (strLength - 3) * 0.5;
				
				sk.writeUTFBytes(concat(arg[i],times) + "\n");
				
				debugSendStr = debugSendStr + concat(arg[i],times) + "\n";
			}
			
			sk.writeUTFBytes("end\n");
			
			debugSendStr = debugSendStr + "end\n";
			
//			trace("发包:****",debugSendStr,"******");
			
			sk.flush();
		}
		
		public static function disconnect():void{
			
			sk.close();
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
			
			var index:int = _str.indexOf(":");
			
			var num:int = int(_str.slice(0,index));
			
			_str = _str.slice(index + 1);
			
			if(num != 0){
				
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
		
		private static function concat(_obj:Object,_times:int):String{
			
			if(_obj == null){
				
				return "null";
			}
			
			if(_times == 0){
				
				return String(_obj);
			}
			
			var str:String = _obj.length + ":";
			
			if(_obj.length == 0){
				
				return str;
			}
			
			var concatStr:String = "";
			
			for(var i:int = 0 ; i < _times ; i++){
				
				concatStr = concatStr + "$";
			}
			
			for(i = 0 ; i < _obj.length - 1; i++){
				
				str = str + concat(_obj[i],_times - 1) + concatStr;
			}
			
			str = str + concat(_obj[i],_times - 1);

			return str;
		}
	}
}