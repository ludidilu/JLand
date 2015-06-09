package
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import csv.Csv;
	
	public class JLand_heroCreater extends Sprite
	{
		public static const csvPath:String = "c:/inetpub/wwwroot/JLand/data/csv/";
		
		private static const list:Vector.<String> = Vector.<String>(["bu","gong","qiang","qi","wall","bao","pao","sai"]);
		
		public function JLand_heroCreater()
		{
			Csv.init(csvPath,Vector.<String>([Csv_heroData.NAME]),Vector.<Class>([Csv_heroData]),getCsv);
		}
		
		private function getCsv():void{
			
			var str:String = "";
			
			var id:int = 1;
			
			var dic:Dictionary = Csv.getDic(Csv_heroData.NAME);
			
			for each(var unit:Csv_heroData in dic){
				
				var tmpList:Vector.<String> = list.concat();
				
				for(var i:int = 0 ; i < 5 ; i++){
				
					str = str + id + "," + "player" + id + "," + id + ",";
					
					var type:int = int(Math.random() * tmpList.length);
					
					var typeName:String = tmpList[type];
					
					tmpList.splice(type,1);
					
					var attNum:int = unit.attNum + unit[typeName] - unit.hpNum;
					
					var hp:int = 1;
					
					var addHp:int = int(Math.random() * int(attNum / unit.hpNum));
					
					
					
					hp = hp + addHp;
					
					attNum = attNum - addHp * unit.hpNum;
					
					var atk:int = int(attNum / unit.atkNum);
					
					str = str + list.indexOf(typeName) + "," + unit.star + "," + hp + "," + atk + "," + unit.power + ",100,100\r\n";
					
					id++;
				}
			}
			
			var file:File = new File("c:/a.csv");
			
			var fs:FileStream = new FileStream;
			
			fs.open(file,FileMode.WRITE);
			
			fs.writeUTFBytes(str);
			
			fs.close();
			
			trace("over!!!");
		}
	}
}