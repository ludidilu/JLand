package game.battle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;

import data.dataCsv.hero.Csv_hero;
import data.dataMap.MapUnit;

public class BattleAI {
	
	public static void start(MapUnit _mapUnit, HashMap<Integer, Integer> _map, HashMap<Integer, BattleHero> _heroMap, HashMap<Integer, Integer> _userCards, ArrayList<Integer> _canMoveHeroUidArr, int _userMoney, HashMap<Integer, Integer> _summonData, HashMap<Integer, Integer> _moveData){
		
		HashMap<Integer, Csv_hero> canMoveHeroMap = new HashMap<>();
		
		for(int pos : _canMoveHeroUidArr){
			
			BattleHero hero = _heroMap.get(pos);
			
			if(!hero.isHost){
				
				canMoveHeroMap.put(pos, hero.csv);
			}
		}
		
		HashMap<Integer, Csv_hero> summonData = new HashMap<>();
		
		Iterator<Entry<Integer, Integer>> iter = _userCards.entrySet().iterator();
			
		while(iter.hasNext() && _userMoney > 0){
			
			Entry<Integer, Integer> entry = iter.next();
			
			int uid = entry.getKey();
			
			int cardID = entry.getValue();
			
			Csv_hero hero = Csv_hero.dic.get(cardID);
			
			if(_userMoney >= hero.star){
				
				float r = (float)_userMoney / (hero.star + canMoveHeroMap.size());
				
				if(Math.random() < r){
					
					int pos = getSummonPos(_mapUnit.neighbourPosMap,_map,_heroMap,summonData,hero);
					
					if(pos != -1){
						
						summonData.put(pos, hero);
						
						_summonData.put(uid, pos);
						
						_userMoney = _userMoney - hero.star;
						
						if(hero.type == 3){
							
							canMoveHeroMap.put(pos, hero);
						}
					}
				}
			}
		}
		
		
		
		
		
		if(_userMoney == 0 || canMoveHeroMap.size() == 0){
			
			return;
		}
		
		if(_userMoney < canMoveHeroMap.size()){
			
			int allMoveUnitStar = 0;
			
			HashMap<Integer, Csv_hero> tmpMap = new HashMap<>();
			
			HashMap<Integer, Integer> tmpMap2 = new HashMap<>();
			
			Iterator<Entry<Integer, Csv_hero>> iter2 = canMoveHeroMap.entrySet().iterator();
			
			while(iter2.hasNext()){
				
				Entry<Integer, Csv_hero> entry = iter2.next();
				
				int pos = entry.getKey();
				
				Csv_hero hero = entry.getValue();
				
				if(canHitEnemy(_mapUnit.neighbourPosMap,_heroMap,hero,pos)){
					
					tmpMap2.put(pos, hero.star);
					
					allMoveUnitStar = allMoveUnitStar + hero.star;
					
				}else{
					
					tmpMap2.put(pos, hero.star * 2);
					
					allMoveUnitStar = allMoveUnitStar + hero.star * 2;
				}
			}
			
			int tmpMoney = _userMoney;
			
			while(tmpMoney > 0){
				
				int randomStar = (int)(Math.random() * allMoveUnitStar);
				
				iter2 = canMoveHeroMap.entrySet().iterator();
				
				while(iter2.hasNext()){
					
					Entry<Integer, Csv_hero> entry = iter2.next();
					
					int pos = entry.getKey();
					
					Csv_hero hero = entry.getValue();
					
					int star = hero.star;
					
					if(randomStar < star){
						
						tmpMap.put(pos, hero);
						
						iter2.remove();
						
						tmpMoney = tmpMoney - 1;
						
						allMoveUnitStar = allMoveUnitStar - tmpMap2.get(pos);
						
						break;
						
					}else{
						
						randomStar = randomStar - tmpMap2.get(pos);
					}
				}
			}
			
			canMoveHeroMap = tmpMap;
		}
		
		Iterator<Entry<Integer, Csv_hero>> iter2 = canMoveHeroMap.entrySet().iterator();
		
		while(iter2.hasNext()){
			
			Entry<Integer, Csv_hero> entry = iter2.next();
			
			int pos = entry.getKey();
			Csv_hero hero = entry.getValue();
			
			int targetPos = getMovePos(_mapUnit.neighbourPosMap,_map,_heroMap,summonData,canMoveHeroMap,hero,pos);
			
			if(targetPos != -1){
				
				_moveData.put(pos, BattlePublic.getDirection(_mapUnit.mapWidth, pos, targetPos));
			}
		}
	}
	
	private static int getSummonPos(HashMap<Integer, int[]> _neighbourPosMap, HashMap<Integer, Integer> _map, HashMap<Integer, BattleHero> _heroMap, HashMap<Integer, Csv_hero> _summonData, Csv_hero _hero){
		
		int[] tmpArrX = new int[12];
		
		ArrayList<Integer> posArr = new ArrayList<>();
		
		ArrayList<Integer> scoreArr = new ArrayList<>();
		
		int allScore = 0;
		
		Iterator<Entry<Integer, Integer>> iter = _map.entrySet().iterator();
		
		while(iter.hasNext()){
			
			Entry<Integer, Integer> entry = iter.next();
			
			int pos = entry.getKey();
			
			int type = entry.getValue();
			
			if(type == 2 && _heroMap.get(pos) == null && !_summonData.containsKey(pos)){
				
				posArr.add(pos);
				
				int tmpScore = 0;
				
				int[] tmpArr = _neighbourPosMap.get(pos);//先找1格外的地图格子
				
				for(int pos2 : tmpArr){
					
					if(pos2 == -1){
						
						continue;
					}
					
					int type2 = _map.get(pos2);
					
					if(type2 == 1){//是敌人地盘  加2分
						
						tmpScore = tmpScore + 2;
						
						allScore = allScore + 2;
						
						BattleHero targetHero = _heroMap.get(pos2);
						
						if(targetHero != null){//如果有敌人
							
							if(_hero.type == 3){//自己是骑兵  加3分
								
								tmpScore = tmpScore + 3;
								
								allScore = allScore + 3;
								
							}else{
							
								if(targetHero.csv.type == 1){//如果敌人是弓兵
									
									if(_hero.type == 0 || _hero.type == 2){//如果自己是步兵或者枪兵  加3分
										
										tmpScore = tmpScore + 3;
										
										allScore = allScore + 3;
									}
									
								}else{//如果敌人不是弓兵  减2分
									
									tmpScore = tmpScore - 2;
									
									allScore = allScore - 2;
								}
							}
						}
					}
				}
						
				BattlePublic.getPosInNeighbour2(_neighbourPosMap, pos, tmpArrX);//再找2格外的地图格子
				
				for(int m = 0 ; m < 12 ; m++){
					
					int pos3 = tmpArrX[m];
					
					if(pos3 == -1){
						
						continue;
					}
					
					int type3 = _map.get(pos3);
					
					if(type3 == 1){//如果是敌人地盘  加1分
						
						tmpScore = tmpScore + 1;
						
						allScore = allScore + 1;
						
						BattleHero targetHero = _heroMap.get(pos3);
						
						if(targetHero != null){//如果有敌人
							
							if(_hero.type == 1 || _hero.type == 2){//如果自己是弓兵或者枪兵
								
								if(targetHero.csv.type == 1 || targetHero.csv.type == 2){//如果敌人是弓兵或者枪兵
									
									if(m % 2 == 1){//如果不会被攻击到  加3分
										
										tmpScore = tmpScore + 3;
										
										allScore = allScore + 3;
										
									}else{//如果会被攻击到  减2分
									
										tmpScore = tmpScore - 2;
										
										allScore = allScore - 2;
									}
									
								}else{//如果敌人是步兵或者骑兵
								
									if(m % 2 == 0){//如果可以攻击到  加3分
									
										tmpScore = tmpScore + 3;
										
										allScore = allScore + 3;
									}
								}
								
							}else if(_hero.type == 0){//如果自己是步兵
								
								if(targetHero.csv.type == 1 || targetHero.csv.type == 2){//如果敌人是弓兵或者枪兵
									
									if(m % 2 == 0){//如果会被攻击到  减2分
										
										tmpScore = tmpScore - 2;
										
										allScore = allScore - 2;
										
									}else{//如果不会被攻击到  加2分
										
										tmpScore = tmpScore + 2;
										
										allScore = allScore + 2;
									}
									
								}else{//如果敌人是步兵或者骑兵  加1分
									
									tmpScore = tmpScore + 1;
									
									allScore = allScore + 1;
								}
							}
						}
					}
				}
				
				scoreArr.add(tmpScore);
			}
		}
		
		if(allScore > 0){
			
			int randomScore = (int)(Math.random() * allScore);
			
			for(int i = 0 ; i < scoreArr.size() ; i++){
				
				int nowScore = scoreArr.get(i);
				
				if(randomScore < nowScore){
					
					return posArr.get(i);
					
				}else{
					
					randomScore = randomScore - nowScore;
				}
			}
			
			return -1;
			
		}else{
			
			return -1;
		}
	}
	
	private static int getMovePos(HashMap<Integer, int[]> _neighbourPosMap, HashMap<Integer, Integer> _map, HashMap<Integer, BattleHero> _heroMap, HashMap<Integer, Csv_hero> _summonData, HashMap<Integer, Csv_hero> _moveMap, Csv_hero _hero, int _pos){
		
		ArrayList<Integer> posArr = new ArrayList<>();
		
		ArrayList<Integer> scoreArr = new ArrayList<>();
		
		int allScore = 0;
		
		int[] tmpArr = _neighbourPosMap.get(_pos);
		
		for(int pos : tmpArr){
			
			if(pos != -1){
				
				if(_summonData.containsKey(pos)){
					
					if(_moveMap.containsKey(pos)){
						
						posArr.add(pos);
						
						int score = getMovePosScore(_neighbourPosMap, _map, _heroMap, _hero, pos);
						
						scoreArr.add(score);
						
						allScore = allScore + score;
					}
					
				}else{
					
					BattleHero hero = _heroMap.get(pos);
					
					if(hero != null){
						
						if(!hero.isHost){
							
							if(_moveMap.containsKey(pos)){
								
								posArr.add(pos);
								
								int score = getMovePosScore(_neighbourPosMap, _map, _heroMap, _hero, pos);
								
								scoreArr.add(score);
								
								allScore = allScore + score;
							}
						}
						
					}else{
						
						posArr.add(pos);
						
						int score = getMovePosScore(_neighbourPosMap, _map, _heroMap, _hero, pos);
						
						if(_map.get(pos) == 1){
							
							score = score + 3;
						}
						
						scoreArr.add(score);
						
						allScore = allScore + score;
					}
				}
			}
		}
		
		
		
		
		if(allScore > 0){
			
			int randomScore = (int)(Math.random() * allScore);
			
			for(int i = 0 ; i < scoreArr.size() ; i++){
				
				int nowScore = scoreArr.get(i);
				
				if(randomScore < nowScore){
					
					return posArr.get(i);
					
				}else{
					
					randomScore = randomScore - nowScore;
				}
			}
			
			return -1;
			
		}else{
			
			return -1;
		}
	}
	
	private static int getMovePosScore(HashMap<Integer, int[]> _neighbourPosMap, HashMap<Integer, Integer> _map, HashMap<Integer, BattleHero> _heroMap, Csv_hero _hero, int _pos){
		
		int[] tmpArrX = new int[12];
		
		int score = 0;
		
		int[] tmpArr = _neighbourPosMap.get(_pos);//先找1格外的地图格子
		
		for(int pos2 : tmpArr){
			
			if(pos2 == -1){
				
				continue;
			}
			
			int type2 = _map.get(pos2);
			
			if(type2 == 1){//是敌人地盘  加2分
				
				score = score + 3;
				
				BattleHero targetHero = _heroMap.get(pos2);
				
				if(targetHero != null){//如果有敌人
					
					if(targetHero.csv.type == 1){//如果敌人是弓兵
						
						if(_hero.type == 0 || _hero.type == 2){//如果自己是步兵或者枪兵  加3分
							
							score = score + 3;
						}
						
					}else{//如果敌人不是弓兵
						
						if(_hero.type == 0 || _hero.type == 2 || _hero.type == 3){//如果自己是步兵、枪兵或者枪兵  加2分
							
							score = score + 2;
						}
					}
				}
			}
		}
				
		BattlePublic.getPosInNeighbour2(_neighbourPosMap, _pos, tmpArrX);//再找2格外的地图格子
		
		for(int m = 0 ; m < 12 ; m++){
			
			int pos3 = tmpArrX[m];
			
			if(pos3 == -1){
				
				continue;
			}
			
			int type2 = _map.get(pos3);
			
			if(type2 == 1){//是敌人地盘  加2分
				
				score = score + 2;
			
				BattleHero targetHero = _heroMap.get(pos3);
				
				if(targetHero != null){//如果有敌人
					
					if(_hero.type == 1){//如果自己是弓兵
						
						if(m % 2 == 0){//如果可以攻击到  加3分
								
							score = score + 3;
						}
							
					}else if(_hero.type == 2){//如果自己是枪兵
						
						if(m % 2 == 0){
							
							BattleHero targetHero2 = _heroMap.get((_pos + pos3) / 2);
							
							if(targetHero2 == null){
								
								score = score + 2;
							}
						}
					}
				}
			}
		}
		
		return score;
	}
	
	private static boolean canHitEnemy(HashMap<Integer, int[]> _neighbourPosMap, HashMap<Integer, BattleHero> _heroMap, Csv_hero _hero, int _pos){
		
		int[] tmpArr = _neighbourPosMap.get(_pos);
		
		for(int i = 0 ; i < 6 ; i++){
			
			int pos = tmpArr[i];
			
			if(pos != -1){
				
				if(_hero.type == 0 || _hero.type == 3){
				
					BattleHero targetHero = _heroMap.get(pos);
					
					if(targetHero != null && targetHero.isHost){
						
						return true;
					}
					
				}else if(_hero.type == 1){
					
					pos = _neighbourPosMap.get(pos)[i];
					
					if(pos != -1){
						
						BattleHero targetHero = _heroMap.get(pos);
						
						if(targetHero != null && targetHero.isHost){
							
							return true;
						}
					}
					
				}else{
					
					BattleHero targetHero = _heroMap.get(pos);
					
					if(targetHero != null){
						
						if(targetHero.isHost){
						
							return true;
						}
						
					}else{
						
						pos = _neighbourPosMap.get(pos)[i];
						
						if(pos != -1){
							
							targetHero = _heroMap.get(pos);
							
							if(targetHero != null && targetHero.isHost){
								
								return true;
							}
						}
					}
				}
			}
		}
		
		return false;
	}
}
