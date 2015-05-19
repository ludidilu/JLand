package game.battle
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import data.resource.ResourcePublic;
	
	import publicTools.tools.UpdateFrameUtil;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class BattleMap extends Sprite
	{
		private var bgContainer:Sprite;
		private var mapContainer:Sprite;
		
		private var unitWidth:Number;
		
		private var mapWidth:int;
		private var mapHeight:int;
		
		private var size:int;
		
		public var dic:Dictionary;
		
		private var point1:Point = new Point;
		private var point2:Point = new Point;
		
		private var touchBeginUnit:BattleMapUnit;
		private var selectedUnit:BattleMapUnit;
		
		private var isMoving:Boolean;
		private var movePoint2:Point = new Point;
		private var movePoint1:Point = new Point;
		
		private var tmpPoint:Point = new Point;
		private var tmpPoint2:Point = new Point;
		
		public function BattleMap()
		{
			unitWidth = ResourcePublic.getTexture("blackFrame").height * 0.5 + 2;
			
			dic = new Dictionary;
			
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
			
			addChild(mapContainer);
			
			bgContainer.addEventListener(TouchEvent.TOUCH,bgBeTouch);
		}
		
		
		
		public function start(_mapWidth:int,_mapHeight:int,_size:int,_dic:Dictionary):void{
			
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

		public function touchBegin(_unit:BattleMapUnit,_x:Number,_y:Number):void{
			
			point1.x = _x;
			point1.y = _y;
			
			this.globalToLocal(point1,point2);
			
			point1.x = _unit.x;
			point1.y = _unit.y;
			
			var dis:Number = Point.distance(point2,point1);
			
			var vec:Vector.<int> = BattlePublic.getNeighbourPosVec(mapWidth,size,dic,_unit.id);
			
			for each(var i:int in vec){
				
				var unit:BattleMapUnit = dic[i];
				
				point1.x = unit.x;
				point1.y = unit.y;
				
				if(Point.distance(point2,point1) < dis){
					
					_unit = unit;
					
					break;
				}
			}
			
			if(Battle.instance.heroData[_unit.id] != null || Battle.instance.summonDic[_unit.id] != null){
				
				touchBeginUnit = _unit;
				
				return;
				
			}else if(Battle.instance.nowSummonCard != null && Battle.instance.mapData[_unit.id] == 1){
				
				touchBeginUnit = _unit;
				
				return;
			}
			
			clearSelectedUnit();
			
			if(Battle.instance.nowSummonCard == null){
			
				Battle.instance.hideHeroDetail();
			}
			
//			trace("touch mapContainer and start move!");
			
			movePoint2.x = _x;
			movePoint2.y = _y;
			
			movePoint1.x = Battle.instance.gameContainerX;
			movePoint1.y = Battle.instance.gameContainerY;
			
			isMoving = true;
			
			UpdateFrameUtil.addUpdateFrame(move);
		}
		
		private function move():void{
			
			Battle.instance.gameContainerX = movePoint1.x + Starling.current.nativeStage.mouseX - movePoint2.x;
			Battle.instance.gameContainerY = movePoint1.y + Starling.current.nativeStage.mouseY - movePoint2.y;
		}
		
		public function touchEnd(_unit:BattleMapUnit,_x:Number,_y:Number):void{
			
			if(isMoving){
				
//				trace("touch mapContainer and move end!");
				
				isMoving = false;
				
				UpdateFrameUtil.delUpdateFrame(move);
				
				return;
			}
			
			point1.x = _x;
			point1.y = _y;
			
			this.globalToLocal(point1,point2);
			
			point1.x = _unit.x;
			point1.y = _unit.y;
			
			var dis:Number = Point.distance(point2,point1);
			
			var vec:Vector.<int> = BattlePublic.getNeighbourPosVec(mapWidth,size,dic,_unit.id);
			
			for each(var i:int in vec){
				
				var unit:BattleMapUnit = dic[i];
				
				point1.x = unit.x;
				point1.y = unit.y;
				
				var tmpDis:Number = Point.distance(point2,point1);
				
				if(tmpDis < dis){
					
					dis = tmpDis;
					
					_unit = unit;
				}
			}
			
			if(dis < unitWidth){
				
				if(touchBeginUnit == _unit){
					
					if(selectedUnit != _unit){
						
//						trace("click hero:",_unit.id);
						
						if(Battle.instance.heroData[_unit.id] != null){
							
							if(Battle.instance.nowSummonCard != null){
								
								Battle.instance.clearNowSummonCard();
							}
							
							tmpPoint.x = _unit.x;
							tmpPoint.y = _unit.y;
							
							localToGlobal(tmpPoint,tmpPoint2);
							
							Battle.instance.showHeroDetail(tmpPoint2.x,tmpPoint2.y,Battle.instance.heroData[_unit.id].csv.id);
						
//							trace("skill:",Battle.instance.heroData[_unit.id].csv.comment);
							
						}else if(Battle.instance.summonDic[_unit.id] != null){
							
							if(Battle.instance.nowSummonCard != null){
								
								Battle.instance.clearNowSummonCard();
							}
							
							tmpPoint.x = _unit.x;
							tmpPoint.y = _unit.y;
							
							localToGlobal(tmpPoint,tmpPoint2);
							
							Battle.instance.showHeroDetail(tmpPoint2.x,tmpPoint2.y,Battle.instance.summonDic[_unit.id].csv.id);
							
						}else{
							
							if(Battle.instance.nowSummonCard != null){
								
								Battle.instance.summon(_unit.id);
								
								return;
							}
						}
						
						mapContainer.unflatten();
						
						clearSelectedUnit();
						
						_unit.state = 1;
						
						_unit.refresh();
						
						selectedUnit = _unit;
						
						mapContainer.flatten();
						
					}else{
						
						if(Battle.instance.summonDic[_unit.id] != null){
							
							Battle.instance.unSummon(_unit.id);
							
						}else{
							
//							trace("click same hero!");
						}
					}
					
				}else{
					
					if(selectedUnit == touchBeginUnit){
						
						if(selectedUnit != null){
						
							Battle.instance.heroMove(selectedUnit.id,_unit.id);
						}
						
//						trace("move hero:",selectedUnit.id,"--->",_unit.id);
						
					}else{
						
//						trace("click another hero and move out!");
					}
				}
				
			}else{
				
//				trace("click hero and move too far!");
			}
			
			touchBeginUnit = null;
		}
		
		private function bgBeTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(bgContainer);
			
			if(touch != null){
				
				if(touch.phase == TouchPhase.BEGAN){
					
//					trace("touch bgContainer and start move!");
					
					clearSelectedUnit();
					
					movePoint2.x = touch.globalX;
					movePoint2.y = touch.globalY;
					
					movePoint1.x = Battle.instance.gameContainerX;
					movePoint1.y = Battle.instance.gameContainerY;
					
					isMoving = true;
					
					UpdateFrameUtil.addUpdateFrame(move);
					
					if(Battle.instance.nowSummonCard == null){
						
						Battle.instance.hideHeroDetail();
					}
					
				}else if(touch.phase == TouchPhase.ENDED){
					
//					trace("touch bgContainer and move end!");
					
					isMoving = false;
					
					UpdateFrameUtil.delUpdateFrame(move);
				}
			}
		}
		
		public function clearSelectedUnit():void{
			
			if(selectedUnit != null){
				
				mapContainer.unflatten();
				
				selectedUnit.state = 0;
				
				selectedUnit.refresh();
				
				selectedUnit = null;
				
				mapContainer.flatten();
			}
		}
	}
}