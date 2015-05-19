package game.battle
{
	import data.csv.Csv;
	import data.csv.CsvUnit;
	import data.csv.Csv_hero;
	import data.resource.ResourceFont;
	import data.resource.ResourceHero;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class BattleHeroDetailPanel extends Sprite
	{
		private var img:Image;
		private var nameTf:TextField;
		private var typeTf:TextField;
		private var starTf:TextField;
		private var hpTf:TextField;
		private var powerTf:TextField;
		private var atkTf:TextField;
//		private var defTf:TextField;
//		private var wisTf:TextField;
		private var commentTf:TextField;
		
		private var bg:Sprite;
		private var ui:Sprite;
		
		private var csvUnit:CsvUnit;
		
		public function BattleHeroDetailPanel()
		{
			super();
			
			csvUnit = Csv.getCsvUnit("hero");
			
			bg = new Sprite;
			
			bg.addChild(new Quad(300,200,0xFFFFFF00));
			
			bg.flatten();
			
			addChild(bg);
			
			ui = new Sprite;
			
			addChild(ui);
			
			addEventListener(TouchEvent.TOUCH,beTouch);
		}
		
		private function beTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(this,TouchPhase.ENDED);
				
			if(touch != null){
				
				this.visible = false;
			}
		}
		
		public function setData(_heroID:int):void{
			
			var csv:Csv_hero = csvUnit.dic[_heroID];
			
			if(img == null){
				
				img = new Image(ResourceHero.getTexture(csv.picName));
				
				ui.addChild(img);
				
				img.x = 10;
				img.y = 10;
				
				nameTf = new TextField(60,30,csv.name,ResourceFont.fontName,24);
				
				nameTf.hAlign = HAlign.LEFT;
				nameTf.vAlign = VAlign.TOP;
				
				nameTf.x = 80;
				nameTf.y = 10;
				
				ui.addChild(nameTf);
				
				typeTf = new TextField(60,30,Csv_hero.TYPE_VEC[csv.type],ResourceFont.fontName,24);
				
				typeTf.hAlign = HAlign.LEFT;
				typeTf.vAlign = VAlign.TOP;
				
				typeTf.x = 150;
				typeTf.y = 10;
				
				ui.addChild(typeTf);
				
				starTf = new TextField(60,30,String(csv.star),ResourceFont.fontName,24);
				
				starTf.hAlign = HAlign.LEFT;
				starTf.vAlign = VAlign.TOP;
				
				starTf.x = 220;
				starTf.y = 10;
				
				ui.addChild(starTf);
				
				hpTf = new TextField(100,30,"hp:" + csv.maxHp,ResourceFont.fontName,24);
				
				hpTf.hAlign = HAlign.LEFT;
				hpTf.vAlign = VAlign.TOP;
				
				hpTf.x = 80;
				hpTf.y = 40;
				
				ui.addChild(hpTf);
				
				powerTf = new TextField(100,30,"power:" + csv.maxPower,ResourceFont.fontName,24);
				
				powerTf.hAlign = HAlign.LEFT;
				powerTf.vAlign = VAlign.TOP;
				
				powerTf.x = 190;
				powerTf.y = 40;
				
				ui.addChild(powerTf);
				
				atkTf = new TextField(70,30,"atk:" + csv.atk,ResourceFont.fontName,24);
				
				atkTf.hAlign = HAlign.LEFT;
				atkTf.vAlign = VAlign.TOP;
				
				atkTf.x = 80;
				atkTf.y = 70;
				
				ui.addChild(atkTf);
				
//				defTf = new TextField(70,30,"def:" + csv.def,ResourceFont.fontName,24);
//				
//				defTf.hAlign = HAlign.LEFT;
//				defTf.vAlign = VAlign.TOP;
//				
//				defTf.x = 150;
//				defTf.y = 70;
//				
//				ui.addChild(defTf);
//				
//				wisTf = new TextField(70,30,"wis:" + csv.wis,ResourceFont.fontName,24);
//				
//				wisTf.hAlign = HAlign.LEFT;
//				wisTf.vAlign = VAlign.TOP;
//				
//				wisTf.x = 220;
//				wisTf.y = 70;
//				
//				ui.addChild(wisTf);
				
				commentTf = new TextField(280,100,csv.comment,"Verdana",20);
				
				commentTf.hAlign = HAlign.LEFT;
				commentTf.vAlign = VAlign.TOP;
				
				commentTf.x = 10;
				commentTf.y = 100;
				
				ui.addChild(commentTf);
				
			}else{
				
				ui.unflatten();
				
				img.texture = ResourceHero.getTexture(csv.picName);
				
				nameTf.text = csv.name;
				
				typeTf.text = Csv_hero.TYPE_VEC[csv.type];
				
				starTf.text = String(csv.star);
				
				hpTf.text = "hp:" + csv.maxHp;
				
				powerTf.text = "power:" + csv.maxPower;
				
				atkTf.text = "atk:" + csv.atk;
				
//				defTf.text = "def:" + csv.def;
//				
//				wisTf.text = "wis:" + csv.wis;
				
				commentTf.text = csv.comment;
			}
			
			ui.flatten();
		}
	}
}