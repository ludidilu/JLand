package game.battle
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import data.resource.ResourcePublic;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class BattleMap extends Sprite
	{
		private var bgContainer:Sprite;
		private var mapContainer:Sprite;
		private var selectedFrameContaienr:Sprite;
		
		private var unitWidth:Number;
		
		private var mapWidth:int;
		private var mapHeight:int;
		
		private var size:int;
		
		public var dic:Dictionary;
		
		private var selectedFrame:Sprite;
		
		private var point1:Point = new Point;
		private var point2:Point = new Point;
		
		private var selectedUnit:BattleMapUnit;
		
		public var moveFun:Function;

		private var movePoint2:Point = new Point;
		private var movePoint1:Point = new Point;
		
		private var tmpPoint:Point = new Point;
		private var tmpPoint2:Point = new Point;
		
		private var tmpRect:Rectangle = new Rectangle;
		
		public function BattleMap()
		{
			unitWidth = ResourcePublic.getTexture("blackFrame").height * 0.5 + 2;
			
			bgContainer = new Sprite;
			
			var quad:Quad = new Quad(10000,10000);
			
			quad.x = -0.5 * quad.width;
			quad.y = -0.5 * quad.height;
			
			quad.alpha = 0;
			
			bgContainer.addChild(quad);
			
			bgContainer.x = -0.5 * Starling.current.backBufferWidth;
			bgContainer.y = -0.5 * Starling.current.backBufferHeight;
			
			bgContainer.flatten();
			
			addChild(bgContainer);
			
			mapContainer = new Sprite;
			
			mapContainer.touchable = false;
			
			addChild(mapContainer);
			
			bgContainer.addEventListener(TouchEvent.TOUCH,bgBeTouch);
			
			selectedFrameContaienr = new Sprite;
			
			selectedFrameContaienr.touchable = false;
			
			selectedFrame = new Sprite;
			
			var img:Image = new Image(ResourcePublic.getTexture("blackFrame"));
			
			img.x = -0.5 * img.width;
			img.y = -0.5 * img.height;
			
			selectedFrame.addChild(img);
			selectedFrame.flatten();
			
			selectedFrame.visible = false;
			
			selectedFrameContaienr.addChild(selectedFrame);
			
			addChild(selectedFrameContaienr);
		}
		
		
		
		public function start(_mapWidth:int,_mapHeight:int,_size:int,_dic:Dictionary):void{
			
			mapContainer.unflatten();
			
			mapContainer.removeChildren();
			
			dic = new Dictionary;
			
			mapWidth = _mapWidth;
			mapHeight = _mapHeight;
			
			size = _size;
			
			for(var i:int = 0 ; i < mapWidth ; i++){
				
				for(var m:int = 0 ; m < mapWidth ; m++){
					
					if(m == mapWidth - 1 && i % 2 == 1){
						
						break;
					}
					
					var id:int = i * mapWidth - int(i  * 0.5) + m;
					
					if(_dic[id] != null){
					
						var sp:BattleMapUnit = new BattleMapUnit(this,id);
						
						sp.isMine = _dic[id] == 1;
						
						sp.refresh();
						
						sp.x = unitWidth * 1.5 + ((i % 2) == 0 ? 0 : (unitWidth * 0.5 * Math.sqrt(3))) + m * unitWidth * Math.sqrt(3);
						
						sp.y = unitWidth * 1.5 + i * unitWidth * 1.5;
						
						mapContainer.addChild(sp);
						
						dic[sp.id] = sp;
					}
				}
			}
			
			mapContainer.flatten();
		}
		
		public function refresh(_dic:Dictionary):void{
			
			mapContainer.unflatten();
			
			for each(var unit:BattleMapUnit in dic){
				
				var type:int = _dic[unit.id];
				
				if(unit.isMine != type == 1){
					
					unit.isMine = type == 1;
					
					unit.refresh();
				}
			}
			
			mapContainer.flatten();
		}

		public function touchBegin(_unit:BattleMapUnit,_globalX:Number,_globalY:Number):void{
			
			var hero:BattleHero = Battle.instance.heroData[_unit.id];
			
			if(hero != null){
			
				Battle.instance.showHeroDetail(_globalX,_globalY,hero.csv.id);
				
				setSelectedUnit(_unit);
				
				if(!Battle.instance.isActioned && hero.isMine && Battle.instance.canMoveData != null && Battle.instance.canMoveData.indexOf(hero.pos) != -1){
					
					moveFun = readyToHeroMove;
					
				}else{
					
					moveFun = readyToContainerMove;
				}
				
				return;
			}
			
			var card:BattleCard = Battle.instance.summonDic[_unit.id];
			
			if(card != null){
				
				Battle.instance.cardTouchBegin(card,_globalX,_globalY);
				
				return;
			}
			
			clearSelectedUnit();
			
			Battle.instance.hideHeroDetail();
			
			movePoint2.x = _globalX;
			movePoint2.y = _globalY;
			
			movePoint1.x = Battle.instance.gameContainerX;
			movePoint1.y = Battle.instance.gameContainerY;
			
			moveFun = move;
		}
		
		private function readyToContainerMove(_globalX:Number,_globalY:Number):void{
			
			tmpPoint.x = selectedUnit.x;
			tmpPoint.y = selectedUnit.y;
			
			localToGlobal(tmpPoint,tmpPoint2);
			
			tmpPoint.x = _globalX;
			tmpPoint.y = _globalY;
			
			if(Point.distance(tmpPoint,tmpPoint2) > unitWidth * Battle.instance.gameContainerScale){
				
				clearSelectedUnit();
				
				Battle.instance.hideHeroDetail();
				
				movePoint2.x = _globalX;
				movePoint2.y = _globalY;
				
				movePoint1.x = Battle.instance.gameContainerX;
				movePoint1.y = Battle.instance.gameContainerY;
				
				moveFun = move;
			}
		}
		
		private function readyToHeroMove(_globalX:Number,_globalY:Number):void{
			
			tmpPoint.x = selectedUnit.x;
			tmpPoint.y = selectedUnit.y;
			
			localToGlobal(tmpPoint,tmpPoint2);
			
			tmpPoint.x = _globalX;
			tmpPoint.y = _globalY;
			
			if(Point.distance(tmpPoint,tmpPoint2) > unitWidth * Battle.instance.gameContainerScale){
				
				var hero:BattleHero = Battle.instance.heroData[selectedUnit.id];
				
				if(Battle.instance.money > 0 || hero.pos in Battle.instance.moveDic){
					
					moveFun = heroMove;
					
				}else{
					
					Battle.instance.moneyTremble();
					
					moveFun = null;
				}
			}
		}
		
		private function heroMove(_globalX:Number,_globalY:Number):void{
			
			var hero:BattleHero = Battle.instance.heroData[selectedUnit.id];
			
			tmpPoint.x = selectedUnit.x;
			tmpPoint.y = selectedUnit.y;
			
			localToGlobal(tmpPoint,tmpPoint2);
			
			tmpPoint.x = _globalX;
			tmpPoint.y = _globalY;
			
			if(Point.distance(tmpPoint,tmpPoint2) < unitWidth * Battle.instance.gameContainerScale){
				
				Battle.instance.heroMove(hero,-1);
				
				return;
			}
			
			var angle:Number = Math.atan2(_globalY - tmpPoint2.y,_globalX - tmpPoint2.x);
			
			if(angle >= -Math.PI / 6 && angle < Math.PI / 6){
				
				var target:int = hero.pos + 1;
				
			}else if(angle >= Math.PI / 6 && angle < Math.PI * 0.5){
				
				target = hero.pos + mapWidth;
				
			}else if(angle >= Math.PI * 0.5 && angle < Math.PI * 5 / 6){
				
				target = hero.pos + mapWidth - 1;
				
			}else if(angle >= -Math.PI * 0.5 && angle < -Math.PI / 6){
				
				target = hero.pos - mapWidth + 1;
				
			}else if(angle >= -Math.PI * 5 / 6 && angle < -Math.PI * 0.5){
				
				target = hero.pos - mapWidth;
				
			}else{
				
				target = hero.pos - 1;
			}
			
			Battle.instance.heroMove(hero,target);
		}
		
		private function move(_globalX:Number,_globalY:Number):void{
			
			Battle.instance.gameContainerX = movePoint1.x + _globalX - movePoint2.x;
			Battle.instance.gameContainerY = movePoint1.y + _globalY - movePoint2.y;
		}
		
		public function touchEnd(_unit:BattleMapUnit,_globalX:Number,_globalY:Number):void{
			
			if(moveFun == Battle.instance.cardMove1){
				
				Battle.instance.cardTouchEnd(Battle.instance.nowChooseCard,_globalX,_globalY);
				
			}else{
				
				moveFun = null;
			}
		}
		
		private function bgBeTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(bgContainer);
			
			if(touch != null){
				
				if(touch.phase == TouchPhase.BEGAN){
					
					Battle.instance.clearNowChooseCard();

					var unit:BattleMapUnit = getTouchUnit(touch.globalX,touch.globalY);
					
					if(unit != null){
						
						touchBegin(unit,touch.globalX,touch.globalY);
						
					}else{
						
						clearSelectedUnit();
						
						Battle.instance.hideHeroDetail();
						
						movePoint2.x = touch.globalX;
						movePoint2.y = touch.globalY;
						
						movePoint1.x = Battle.instance.gameContainerX;
						movePoint1.y = Battle.instance.gameContainerY;
						
						moveFun = move;
					}
					
				}else if(touch.phase == TouchPhase.ENDED){
					
					unit = getTouchUnit(touch.globalX,touch.globalY);
					
					touchEnd(unit,touch.globalX,touch.globalY);

				}else if(touch.phase == TouchPhase.MOVED){
					
					if(moveFun != null){
					
						moveFun(touch.globalX,touch.globalY);
					}
				}
			}
		}
		
		public function getTouchUnit(_globalX:int,_globalY:int):BattleMapUnit{
			
			tmpPoint.x = _globalX;
			tmpPoint.y = _globalY;
			
			this.globalToLocal(tmpPoint,tmpPoint2);
			
			var localX:Number = tmpPoint2.x;
			var localY:Number = tmpPoint2.y;
			
			var b:int = Math.floor((localY - unitWidth * 0.5) / unitWidth / 1.5);
			
			if(b == mapHeight){
				
				b = mapHeight - 1;
			}
			
			if(b >= 0 && b < mapHeight){
				
				if(b % 2 == 0){
					
					var a:int = Math.floor((localX - unitWidth * 0.5) / unitWidth / Math.sqrt(3));
					
					if(a == mapWidth){
						
						a = mapWidth - 1;
					}
					
					if(a < 0 || a >= mapWidth){
						
						return null;
					}
					
				}else{
					
					a = Math.floor((localX - unitWidth * 0.5 - unitWidth * 0.5 * Math.sqrt(3)) / unitWidth / Math.sqrt(3));
					
					if(a == -1){
						
						a = 0;
						
					}else if(a == mapWidth - 1){
						
						a = mapWidth - 2;
					}
					
					if(a < 0 || a >= mapWidth - 1){
						
						return null;
					}
				}
				
				var index:int = b * mapWidth - int(b  * 0.5) + a;
				
				point1.x = unitWidth * 1.5 + ((b % 2) == 0 ? 0 : (unitWidth * 0.5 * Math.sqrt(3))) + a * unitWidth * Math.sqrt(3);
				point1.y = unitWidth * 1.5 + b * unitWidth * 1.5;
				
				point2.x = localX;
				point2.y = localY;
				
				var dis:Number = Point.distance(point2,point1);
				
				var resultUnit:BattleMapUnit = dic[index];
				
				var vec:Vector.<int> = BattlePublic.getNeighbourPosVec(mapWidth,size,dic,index);
				
				for each(var i:int in vec){
					
					var unit:BattleMapUnit = dic[i];
					
					point1.x = unit.x;
					point1.y = unit.y;
					
					if(Point.distance(point2,point1) < dis){
						
						resultUnit = unit;
						
						break;
					}
				}
				
				if(resultUnit != null){
					
					point1.x = resultUnit.x;
					point1.y = resultUnit.y;
					
					dis = Point.distance(point2,point1);
					
					if(dis > unitWidth){
						
						return null;
					}
				}
				
				return resultUnit;
				
			}else{
				
				return null;
			}
		}
		
		public function getSelectedUnit():BattleMapUnit{
			
			return selectedUnit;
		}
		
		public function setSelectedUnit(_unit:BattleMapUnit):void{
			
			selectedUnit = _unit;
			
			selectedFrame.visible = true;
			
			selectedFrame.x = selectedUnit.x;
			selectedFrame.y = selectedUnit.y;
		}
		
		public function clearSelectedUnit():void{
			
			if(selectedUnit != null){
				
				selectedFrame.visible = false;
				
				selectedUnit = null;
			}
		}
	}
}