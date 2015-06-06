package data.dataCsv;

import panel.Panel;
import userService.UserService;
import data.dataCsv.ai.Csv_ai;
import data.dataCsv.battle.Csv_battle;
import data.dataCsv.hero.Csv_hero;
import data.dataCsv.hero.Csv_heroType;
import data.dataCsv.map.Csv_map;

public class MainCsv {

	private static String path = "C:/inetpub/wwwroot/JLand/data/csv/";
	
	public static void init() throws Exception{
		
		Csv.init(path,UserService.class);
		
		Csv.setData(Csv_heroType.class, "heroType", null);
		
		Csv.setData(Csv_hero.class, "hero", Csv_hero.class.getDeclaredMethod("fix"));
		
		Csv.setData(Csv_map.class, "map", null);
		
		Csv.setData(Csv_ai.class, "ai", null);
		
		Csv.setData(Csv_battle.class, "battle", null);
		
		Panel.show("CSV±Ìº”‘ÿÕÍ±œ");
	}
}
