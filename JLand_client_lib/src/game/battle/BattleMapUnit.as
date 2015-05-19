package game.battle
{
	import data.resource.ResourceFont;
	import data.resource.ResourcePublic;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	public class BattleMapUnit extends Sprite
	{
//		private static const stateVec:Vector.<String> = Vector.<String>(["blackFrame","redFrame","redFrame"]);
		
		private var map:BattleMap;
		
		public var id:int;
		public var isMine:Boolean;
		public var state:int;
		
		private var bg:Image;
		private var frame:Image;
		
		private var tf:TextField;
		
		public function BattleMapUnit(_map:BattleMap,_id:int)
		{
			map = _map;
			
			id = _id;
			
			addEventListener(TouchEvent.TOUCH,beTouch);
		}
		
		public function refresh():void{
			
			if(bg == null){
				
				bg = new Image(ResourcePublic.getTexture(isMine ? "greenBg" : "redBg"));
				
				bg.x = -0.5 * bg.width;
				bg.y = -0.5 * bg.height;
				
				addChild(bg);
				
				frame = new Image(ResourcePublic.getTexture("blackFrame"));
				
				frame.x = -0.5 * frame.width;
				frame.y = -0.5 * frame.height;
				
				addChild(frame);
				
				tf = new TextField(30,30,String(id),ResourceFont.fontName,14,0x0);
				
				addChild(tf);
				
				tf.x = -55;
				
			}else{
				
				bg.texture = ResourcePublic.getTexture(isMine ? "greenBg" : "redBg");
			}
			
			if(state == 0){
				
				frame.visible = false;
				
			}else{
				
				frame.visible = true;
			}
		}
		
		private function beTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(this);
			
			if(touch != null){
				
				if(touch.phase == TouchPhase.BEGAN){
					
					map.touchBegin(this,touch.globalX,touch.globalY);
					
				}else if(touch.phase == TouchPhase.ENDED){
				
					map.touchEnd(this,touch.globalX,touch.globalY);
				}
			}
		}
	}
}