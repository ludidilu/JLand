package data.dataCsv.hero;

import java.util.ArrayList;
import java.util.HashMap;

import data.dataCsv.Csv;

public class Csv_hero extends Csv{

	public static HashMap<Integer, Csv_hero> dic = new HashMap<>();
	
	public int type;
	public int star;
	public int maxHp;
	public int atk;
	public int maxPower;
	public int[] skillTarget;
	public int[] skillTargetArg;
	public int[] skillCondition;
	public int[] skillConditionArg;
	public int[][] skillEffect;
	public int[][][] skillEffectArg;
	
	public ArrayList<Integer> silentSkillIndexArr = null;
	
	public void setSilentSkillIndex(){
		
		for(int i = 0 ; i < skillTarget.length ; i++){
			
			for(int m = 0 ; m < skillEffect[i].length ; m++){
				
				if(skillEffect[i][m] == 1){
					
					if(silentSkillIndexArr == null){
						
						silentSkillIndexArr = new ArrayList<>();
					}
					
					silentSkillIndexArr.add(i);
				}
			}
		}
	}
}
