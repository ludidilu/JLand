package data.resource
{
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	
	import data.Data;
	
	import loader.SuperURLLoader;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;

	public class ResourceFont
	{
		public static const fontName:String = "myFont";
		
		private static var fontXML:XML;
		
		private static const fileName:String = "font.xml";
		private static var callBack:Function;
		
		public static function init(_callBack:Function):void{
			
			callBack = _callBack;
			
			SuperURLLoader.load(Data.path + Resource.path + fileName,URLLoaderDataFormat.TEXT,getXML);
		}
		
		private static function getXML(e:Event):void{
			
			fontXML = new XML(e.target.data);
			
			createFont();
		}
		
		private static function createFont():void{
			
			var bitmapFont:BitmapFont = new BitmapFont(ResourceHero.getTexture("font"),fontXML);
			
			//注册
			TextField.registerBitmapFont(bitmapFont,fontName);
			
			callBack();
		}
	}
}