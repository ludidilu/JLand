package game.battle
{
	import flash.utils.Dictionary;

	public class BattlePublic
	{
		public static function getNeighbourPosVec(_mapWidth:int,_size:int,_dic:Dictionary,_pos:int):Vector.<int>{
			
			var vec:Vector.<int> = new Vector.<int>;
			
			if(_pos % (_mapWidth * 2 - 1) != 0){
				
				if(_pos > _mapWidth - 1){
				
					var p:int = _pos - _mapWidth;
					
					if(_dic[p] != null){
						
						vec.push(p);
					}
				}
				
				if(_pos < _size - _mapWidth){
					
					p = _pos + _mapWidth - 1;
					
					if(_dic[p] != null){
						
						vec.push(p);
					}
				}
				
				if(_pos % (_mapWidth * 2 - 1) != _mapWidth){
					
					p = _pos - 1;
					
					if(_dic[p] != null){
						
						vec.push(p);
					}
				}
			}
			
			if(_pos % (_mapWidth * 2 - 1) != _mapWidth - 1){
				
				if(_pos > _mapWidth - 1){
					
					p = _pos - _mapWidth + 1;
					
					if(_dic[p] != null){
						
						vec.push(p);
					}
				}
				
				if(_pos < _size - _mapWidth){
					
					p = _pos + _mapWidth;
					
					if(_dic[p] != null){
						
						vec.push(p);
					}
				}
				
				if(_pos % (_mapWidth * 2 - 1) != _mapWidth * 2 - 2){
					
					p = _pos + 1;
					
					if(_dic[p] != null){
						
						vec.push(p);
					}
				}
			}
			
			return vec;
		}
		
		public static function getDirect(_isHost:Boolean,_mapWidth:int,_pos:int,_target:int):int{
			
			var dis:int = _target - _pos;
			
			switch(dis){
				
				case 1:
					
					if(_isHost){
						
						return 1;
						
					}else{
						
						return 4;
					}
				
				case -1:
					
					if(_isHost){
						
						return 4;
						
					}else{
						
						return 1;
					}
					
				case _mapWidth:
					
					if(_isHost){
						
						return 2;
						
					}else{
						
						return 5;
					}
					
				case -_mapWidth:
					
					if(_isHost){
						
						return 5;
						
					}else{
						
						return 2;
					}
					
				case _mapWidth - 1:
					
					if(_isHost){
						
						return 3;
						
					}else{
						
						return 0;
					}
					
				default:
					
					if(_isHost){
						
						return 0;
						
					}else{
						
						return 3;
					}
			}
		}
		
		public static function getAttackerPos(_mapWidth:int,_pos:int,_num:int,_attackerVec:Vector.<int>):Vector.<int>{
			
			var vec:Vector.<int> = new Vector.<int>(_num,true);
			
			if(_num == 2){
				
				for(var i:int = 0 ; i < _attackerVec.length ; i++){
					
					var dir1:int = getDirection(_mapWidth,_pos,_attackerVec[i]);
					
					for(var m:int = 0 ; m < _attackerVec.length ; m++){
						
						if(i == m){
							
							continue;
						}
						
						var dir2:int = getDirection(_mapWidth,_pos,_attackerVec[m]);
						
						var result:int = Math.abs(dir1 - dir2);
						
						if(result != 1 && result != 5){
							
							vec[0] = _attackerVec[i];
							vec[1] = _attackerVec[m];
							
							return vec;
						}
					}
				}
				
			}else{
				
				for(i = 0 ; i < _attackerVec.length ; i++){
					
					dir1 = getDirection(_mapWidth,_pos,_attackerVec[i]);
					
					for(m = 0 ; m < _attackerVec.length ; m++){
						
						if(m == i){
							
							continue;
						}
						
						dir2 = getDirection(_mapWidth,_pos,_attackerVec[m]);
						
						for(var n:int = 0 ; n < _attackerVec.length ; n++){
							
							if(n == m || n == i){
								
								continue;
							}
							
							var dir3:int = getDirection(_mapWidth,_pos,_attackerVec[n]);
							
							result = Math.pow(2,dir1) + Math.pow(2,dir2) + Math.pow(2,dir3);
							
							if(result == 21 || result == 42){
								
								vec[0] = _attackerVec[i];
								vec[1] = _attackerVec[m];
								vec[2] = _attackerVec[n];
								
								return vec;
							}
						}
					}
				}
			}
			
			return vec;
		}
		
		private static function getDirection(_mapWidth:int,_pos:int,_target:int):int{
			
			var dis:int = _target - _pos;
			
			switch(dis){
				
				case 1:
				case 2:
					
					return 1;
					
				case -1:
				case -2:
					
					return 4;
					
				case -_mapWidth:
				case -2 * _mapWidth:
					
					return 5;
					
				case -_mapWidth + 1:
				case -2 * _mapWidth + 2:
					
					return 0;
					
				case _mapWidth:
				case 2 * _mapWidth:
					
					return 2;
					
				default:
					
					return 3;
						
			}
		}
	}
}