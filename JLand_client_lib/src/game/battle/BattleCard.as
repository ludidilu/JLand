package game.battle
{
	import data.csv.Csv_hero;
	import data.resource.ResourceFont;
	import data.resource.ResourceHero;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class BattleCard extends Sprite
	{
		private static const fontSize:int = 20;
		
		public var csv:Csv_hero;
		
		private var img:Image;
		
		public var uid:int;
		
		private var typeTf:TextField;
		private var starTf:TextField;
		private var hpTf:TextField;
		private var atkTf:TextField;
		
		public function BattleCard()
		{
			super();
			
			addEventListener(TouchEvent.TOUCH,beTouch);
		}
		
		public function refresh():void{
			
			unflatten();
			
			if(img == null){
				
				img = new Image(ResourceHero.getTexture(csv.picName));
				
				img.x = -0.5 * img.width;
				img.y = -0.5 * img.height;
				
				addChild(img);
				
				typeTf = new TextField(img.width,img.height,Csv_hero.TYPE_VEC[csv.type],ResourceFont.fontName,fontSize,0xFFFFFF);
				
				typeTf.hAlign = HAlign.LEFT;
				typeTf.vAlign = VAlign.TOP;
				
				typeTf.x = img.x;
				typeTf.y = img.y;
				
				addChild(typeTf);
				
				starTf = new TextField(img.width,img.height,String(csv.star),ResourceFont.fontName,fontSize,0xFFFFFF);
				
				starTf.hAlign = HAlign.RIGHT;
				starTf.vAlign = VAlign.TOP;
				
				starTf.x = img.x;
				starTf.y = img.y;
				
				addChild(starTf);
				
				hpTf = new TextField(img.width,img.height,String(csv.maxHp),ResourceFont.fontName,fontSize,0xFFFFFF);
				
				hpTf.hAlign = HAlign.RIGHT;
				hpTf.vAlign = VAlign.BOTTOM;
				
				hpTf.x = img.x;
				hpTf.y = img.y;
				
				addChild(hpTf);
				
				atkTf = new TextField(img.width,img.height,String(csv.atk),ResourceFont.fontName,fontSize,0xFFFFFF);
				
				atkTf.hAlign = HAlign.LEFT;
				atkTf.vAlign = VAlign.BOTTOM;
				
				atkTf.x = img.x;
				atkTf.y = img.y;
				
				addChild(atkTf);
				
			}else{
				
				img.texture = ResourceHero.getTexture(csv.picName);
			}
			
			flatten();
		}
		
		private function beTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(this);
			
			if(touch != null){
				
				if(touch.phase == TouchPhase.BEGAN){
				
					Battle.instance.cardTouchBegin(this,touch.globalX,touch.globalY);
					
				}else if(touch.phase == TouchPhase.MOVED){
					
					Battle.instance.cardTouchMove(this,touch.globalX,touch.globalY);
					
				}else if(touch.phase == TouchPhase.ENDED){
					
					Battle.instance.cardTouchEnd(this,touch.globalX,touch.globalY);
				}
			}
		}
	}
}