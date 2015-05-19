package data.resource
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.Dictionary;
	
	import data.Data;
	
	import loader.SuperLoader;
	import loader.SuperURLLoader;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class ResourceHero
	{
		private static var publicAtlas:TextureAtlas;
		private static var publicTexture:Texture;
		private static var publicXML:XML;
		
		private static const fileName:String = "hero";
		private static var dic:Dictionary = new Dictionary;
		
		private static var textureLoaded:Boolean;
		private static var xmlLoaded:Boolean;
		
		private static var callBack:Function;
		
		public function ResourceHero()
		{
		}
		
		
		public static function init(_callBack:Function):void{
			
			callBack = _callBack;
			
			SuperLoader.load(Data.path + Resource.path + fileName + ".png",getPic);
			
			SuperURLLoader.load(Data.path + Resource.path + fileName + ".xml",URLLoaderDataFormat.TEXT,getXML);
		}
		
		private static function getPic(e:Event):void{
			
			var bitmap:Bitmap = e.target.loader.content;
			
			publicTexture = Texture.fromBitmap(bitmap,false);
			
			bitmap.bitmapData.dispose();
			
			if(xmlLoaded){
				
				createAtlas();
				
			}else{
				
				textureLoaded = true;
			}
		}
		
		private static function getXML(e:Event):void{
			
			publicXML = new XML(e.target.data); 
			
			if(textureLoaded){
				
				createAtlas();
				
			}else{
				
				xmlLoaded = true;
			}
		}
		
		private static function createAtlas():void{
			
			publicAtlas = new TextureAtlas(publicTexture,publicXML);
			
			var nameVec:Vector.<String> = publicAtlas.getNames();
			
			for each(var str:String in nameVec){
				
				dic[str] = publicAtlas.getTexture(str);
			}
			
			callBack();
		}
		
		public static function getTexture(_name:String):Texture{
			
			return dic[_name];
		}
	}
}


