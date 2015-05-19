package game.battle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import publicTools.PublicTools;

public class BattlePublic {

	public static int getDirection(int _mapWidth, int _pos, int _target){
		
		int r = _target - _pos;
		
		if(r == 1){
			
			return 1;
			
		}else if(r == -1){
			
			return 4;
			
		}else if(r == _mapWidth){
			
			return 2;
			
		}else if(r == -_mapWidth){
			
			return 5;
					
		}else if(r == _mapWidth - 1){
			
			return 3;
			
		}else{
			
			return 0;
		}
	}
	
	public static void getPosInNeighbour2(HashMap<Integer, int[]> _neighbourPosMap, int _pos, int[] _result){
		
		int[] arr = _neighbourPosMap.get(_pos);
		
		for(int i = 0 ; i < 6 ; i++){
			
			int pos = arr[i];
			
			if(pos != -1){
				
				int[] arr2 = _neighbourPosMap.get(pos);
				
				if(i == 5){
					
					_result[i * 2] = arr2[i];
					_result[i * 2 + 1] = arr2[0];
					
				}else{
					
					_result[i * 2] = arr2[i];
					_result[i * 2 + 1] = arr2[i + 1];
				}
				
			}else{
				
				_result[i * 2] = -1;
				_result[i * 2 + 1] = -1;
			}
		}
	}
	
	//type 0所有 1敌方 2友方
	public static void getHerosAndDirectionInRange(HashMap<Integer, int[]> _neighbourPosMap,HashMap<Integer, BattleHero> _heroDic,BattleHero _hero,int _type,ArrayList<BattleHero> _heroArr, ArrayList<Integer> _directionArr){
		
		int[] tmpArr = _neighbourPosMap.get(_hero.pos);
		
		for(int i = 0 ; i < 6 ; i++){
		
			int pos = tmpArr[i];
			
			if(pos != -1){
				
				if(_hero.csv.type == 0 || _hero.csv.type == 3){
					
					BattleHero targetHero = _heroDic.get(pos);
					
					if(targetHero != null){
						
						if(_type == 0){
							
							_heroArr.add(targetHero);
							_directionArr.add(i);
							
						}else if(_type == 1){
							
							if(targetHero.isHost != _hero.isHost){
								
								_heroArr.add(targetHero);
								_directionArr.add(i);
							}
							
						}else{
							
							if(targetHero.isHost == _hero.isHost){
								
								_heroArr.add(targetHero);
								_directionArr.add(i);
							}
						}
					}
					
				}else if(_hero.csv.type == 1){
					
					pos = _neighbourPosMap.get(pos)[i];
					
					if(pos != -1){
						
						BattleHero targetHero = _heroDic.get(pos);
						
						if(targetHero != null){
							
							if(_type == 0){
								
								_heroArr.add(targetHero);
								_directionArr.add(i);
								
							}else if(_type == 1){
								
								if(targetHero.isHost != _hero.isHost){
									
									_heroArr.add(targetHero);
									_directionArr.add(i);
								}
								
							}else{
								
								if(targetHero.isHost == _hero.isHost){
									
									_heroArr.add(targetHero);
									_directionArr.add(i);
								}
							}
						}
					}
					
				}else{
					
					BattleHero targetHero = _heroDic.get(pos);
					
					if(targetHero != null){
						
						if(_type == 0){
							
							_heroArr.add(targetHero);
							_directionArr.add(i);
							
						}else if(_type == 1){
							
							if(targetHero.isHost != _hero.isHost){
								
								_heroArr.add(targetHero);
								_directionArr.add(i);
							}
							
						}else{
							
							if(targetHero.isHost == _hero.isHost){
								
								_heroArr.add(targetHero);
								_directionArr.add(i);
							}
						}
						
					}else{
						
						pos = _neighbourPosMap.get(pos)[i];
						
						if(pos != -1){
							
							targetHero = _heroDic.get(pos);
							
							if(targetHero != null){
								
								if(_type == 0){
									
									_heroArr.add(targetHero);
									_directionArr.add(i);
									
								}else if(_type == 1){
									
									if(targetHero.isHost != _hero.isHost){
										
										_heroArr.add(targetHero);
										_directionArr.add(i);
									}
									
								}else{
									
									if(targetHero.isHost == _hero.isHost){
										
										_heroArr.add(targetHero);
										_directionArr.add(i);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	//type 0所有 1敌方 2友方
	private static void getHerosInRangeArr(HashMap<Integer, int[]> _neighbourPosMap,HashMap<Integer, BattleHero> _heroDic,BattleHero _hero,int _type,ArrayList<BattleHero> _resultArr){
		
		int[] tmpArr = _neighbourPosMap.get(_hero.pos);
		
		for(int i = 0 ; i < 6 ; i++){
		
			int pos = tmpArr[i];
			
			if(pos != -1){
				
				if(_hero.csv.type == 0 || _hero.csv.type == 3){
					
					BattleHero targetHero = _heroDic.get(pos);
					
					if(targetHero != null){
						
						if(_type == 0){
							
							_resultArr.add(targetHero);
							
						}else if(_type == 1){
							
							if(targetHero.isHost != _hero.isHost){
								
								_resultArr.add(targetHero);
							}
							
						}else{
							
							if(targetHero.isHost == _hero.isHost){
								
								_resultArr.add(targetHero);
							}
						}
					}
					
				}else if(_hero.csv.type == 1){
					
					pos = _neighbourPosMap.get(pos)[i];
					
					if(pos != -1){
						
						BattleHero targetHero = _heroDic.get(pos);
						
						if(targetHero != null){
							
							if(_type == 0){
								
								_resultArr.add(targetHero);
								
							}else if(_type == 1){
								
								if(targetHero.isHost != _hero.isHost){
									
									_resultArr.add(targetHero);
								}
								
							}else{
								
								if(targetHero.isHost == _hero.isHost){
									
									_resultArr.add(targetHero);
								}
							}
						}
					}
					
				}else{
					
					BattleHero targetHero = _heroDic.get(pos);
					
					if(targetHero != null){
						
						if(_type == 0){
							
							_resultArr.add(targetHero);
							
						}else if(_type == 1){
							
							if(targetHero.isHost != _hero.isHost){
								
								_resultArr.add(targetHero);
							}
							
						}else{
							
							if(targetHero.isHost == _hero.isHost){
								
								_resultArr.add(targetHero);
							}
						}
						
					}else{
						
						pos = _neighbourPosMap.get(pos)[i];
						
						if(pos != -1){
							
							targetHero = _heroDic.get(pos);
							
							if(targetHero != null){
								
								if(_type == 0){
									
									_resultArr.add(targetHero);
									
								}else if(_type == 1){
									
									if(targetHero.isHost != _hero.isHost){
										
										_resultArr.add(targetHero);
									}
									
								}else{
									
									if(targetHero.isHost == _hero.isHost){
										
										_resultArr.add(targetHero);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	public static int checkAttackType(ArrayList<Integer> _data){
		
		int length = _data.size();
		
		if(length == 1){
			
			return 0;
			
		}else if(length == 2){
			
			if(Math.abs(_data.get(0) - _data.get(1)) == 3){
				
				return 2;
				
			}else{
				
				return 0;
			}
			
		}else if(length == 3){
			
			int r = (int)(Math.pow(2, _data.get(0)) + Math.pow(2, _data.get(1)) + Math.pow(2, _data.get(2)));
			
			switch(r){
			
				case 21:
				case 42:
					
					return 3;
					
				case 7:
				case 14:
				case 28:
				case 56:
				case 49:
				case 35:
					
					return 0;
					
				default:
					
					return 2;	
			}
			
		}else if(length == 4){
			
			int r = (int)(Math.pow(2, _data.get(0)) + Math.pow(2, _data.get(1)) + Math.pow(2, _data.get(2)) + Math.pow(2, _data.get(3)));
			
			switch(r){
			
				case 29:
				case 58:
				case 53:
				case 43:
				case 23:
				case 46:
				
					return 3;
					
				default:
					
					return 2;	
			}
			
		}else{
			
			return 3;
		}
	}
	
	public static int[] getDamageArr(BattleHero _attackHero, ArrayList<BattleHero> _beAttackHeroArr){
		
		int[] result = new int[_beAttackHeroArr.size()];
		
		int[] hpArr = new int[result.length];
		
		int atk = _attackHero.getAtk();
		
		int allHp = 0;
		
		if(_beAttackHeroArr.size() == 0){
			
			result[0] = _beAttackHeroArr.get(0).hp;
			
		}else{
			
			int index = 0;
		
			for(BattleHero hero : _beAttackHeroArr){
				
				allHp = allHp + hero.hp;
				
				hpArr[index] = hero.hp;
				
				index++;
			}
			
			if(atk < allHp){
				
				while(atk > 0){
					
					int tmpInt = (int)(Math.random() * allHp);
					
					for(int i = 0 ; i < hpArr.length ; i++){
						
						if(tmpInt < hpArr[i]){
							
							result[i] = result[i] + 1;
							
							hpArr[i] = hpArr[i] - 1;
							
							allHp = allHp - 1;
							
							atk = atk - 1;
							
							break;
							
						}else{
							
							tmpInt = tmpInt - hpArr[i];
						}
					}
				}
				
			}else{
				
				for(int i = 0 ; i < hpArr.length ; i++){
					
					result[i] = hpArr[i];
				}
			}
		}
		
		return result;
	}
	
	public static boolean checkSkillCondition(BattleHero _hero, int _condition, int _arg){
		
		switch(_condition){
		
			case 0:
				
				return true;
				
			case 1:
				
				return _hero.moved;
				
			case 2:
				
				return !_hero.moved;
				
			case 3:
				
				return _hero.power > _arg;
				
			case 4:
				
				return _hero.power < _arg;
				
			case 5:
				
				return _hero.hp > _arg;
				
			default:
				
				return _hero.hp < _arg;
		}
	}
	
	public static void getSkillTargetArr(int _skillTarget, HashMap<Integer, int[]> _neighbourPosMap, HashMap<Integer, BattleHero> _heroMap, BattleHero _hero, ArrayList<BattleHero> _resultArr){
		
		switch(_skillTarget){
		
			case 0:
				
				_resultArr.add(_hero);
				
				break;
				
			case 1:
				
				getHerosInRangeArr(_neighbourPosMap, _heroMap, _hero, 1, _resultArr);
				
				break;
				
			case 2:
				
				getHerosInRangeArr(_neighbourPosMap, _heroMap, _hero, 2, _resultArr);
				
				break;
				
			default:
					
				getHerosInRangeArr(_neighbourPosMap, _heroMap, _hero, 0, _resultArr);
				
				break;
		}
	}
	
	public static int[][] castSkill(HashMap<Integer, int[]> _neighbourPosMap, HashMap<Integer, BattleHero> _heroMap, BattleHero _hero, int _index){
		
		int[][] resultArr = null;
		
		ArrayList<BattleHero> skillTargetHeroArr = new ArrayList<>();
		
		int skillTarget = _hero.csv.skillTarget[_index];
		
		getSkillTargetArr(skillTarget, _neighbourPosMap, _heroMap, _hero, skillTargetHeroArr);
		
		if(skillTargetHeroArr.size() > 0){
			
			boolean result = checkSkillCondition(_hero, _hero.csv.skillCondition[_index], _hero.csv.skillConditionArg[_index]);
			
			if(result){
				
				if(_hero.csv.skillTargetArg[_index] < skillTargetHeroArr.size()){
					
					skillTargetHeroArr = PublicTools.getSomeOfArr(skillTargetHeroArr, _hero.csv.skillTargetArg[_index]);
				}
				
				resultArr = new int[skillTargetHeroArr.size() + 1][];
				
				resultArr[0] = new int[]{_hero.pos};
				
				Iterator<BattleHero> iter2 = skillTargetHeroArr.iterator();
				
				int index = 1;
				
				while(iter2.hasNext()){
					
					BattleHero targetHero = iter2.next();
					
					resultArr[index] = new int[_hero.csv.skillEffect[_index].length * 2 + 1];
					
					resultArr[index][0] = targetHero.pos;
					
					for(int i = 0 ; i < _hero.csv.skillEffect[_index].length ; i++){
					
						int castSkillResult = castSkillEffect(_hero, targetHero, _hero.csv.skillEffect[_index][i], _hero.csv.skillEffectArg[_index][i]);
						
						resultArr[index][i * 2 + 1] = _hero.csv.skillEffect[_index][i];
						
						resultArr[index][i * 2 + 2] = castSkillResult;
					}
					
					index++;
				}
			}
		}
		
		return resultArr;
	}
		
	public static int castSkillEffect(BattleHero _hero, BattleHero _targetHero, int _effect, int[] _effectArg){
		
		switch(_effect){
		
			case 1:
				
				_targetHero.isSilent = true;
					
				return 1;
					
			case 2:

				_targetHero.hpChange = _targetHero.hpChange + _effectArg[0];
				
				return _effectArg[0];
				
			case 3:

				_targetHero.atkFix = _targetHero.atkFix + _effectArg[0];
				
				return _effectArg[0];
				
			case 4:
				
				_targetHero.maxHpFix = _targetHero.maxHpFix + _effectArg[0];
				
				_targetHero.hpChange = _targetHero.hpChange + _effectArg[0];
				
				return _effectArg[0];
				
			case 5:
				
				int damage = _targetHero.csv.atk + _effectArg[0];
				
				damage = damage > 0 ? 0 : damage;
				
				_targetHero.hpChange = _targetHero.hpChange + damage;
				
				return damage;
				
			case 6:
				
				if(_targetHero.hp == _targetHero.csv.maxHp){
					
					_targetHero.hpChange = _targetHero.hpChange + _effectArg[0];
					
					return _effectArg[0];
					
				}else{
					
					_targetHero.hpChange = _targetHero.hpChange + _effectArg[1];
					
					return _effectArg[1];
				}
				
			default:
				
				return 0;
		}
	}
}

