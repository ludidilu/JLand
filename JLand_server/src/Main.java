import game.Game;
import panel.Panel;
import server.Server;
import userService.UserService;
import data.dataCsv.MainCsv;
import data.dataDB.MainDB;
import data.dataMap.Map;


public class Main {

	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub

		Panel.init();
		
		Server.init();
		
		MainCsv.init();
		
		Map.init("C:/inetpub/wwwroot/JLand/data/map/");
		
		MainDB.init();
		
		UserService.init();
		
		Game.init();
		
		
		
	}

}
