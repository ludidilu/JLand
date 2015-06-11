package data.dataDB;

import java.sql.ResultSet;
import java.util.ArrayList;

import userService.UserService;
import data.dataDB.user.DB_user;
import data.dataDB.user.DB_user_unit;

public class MainDB {

	public static void init() throws Exception{
		
		DB.init("JLand","root","616097",UserService.class,DB_user_unit.class);
		
		String sql = "select * from userhero";
        
        ResultSet rs = DB.stmt.executeQuery(sql);  
        
        while (rs.next()){
        	
        	int uid = rs.getInt("uid");
        	
        	String herosStr = rs.getString("heros");
        	
        	DB_user_unit user = DB_user.getUserByID(uid);
        	
        	UserService service = (UserService)user.service;
        	
        	service.userData.heros = new ArrayList<>();
        	
        	if(!herosStr.equals("")){
        	
	        	String[] tmpStrVec = herosStr.split("\\$");
	        	
	        	for(int i = 0 ; i < tmpStrVec.length ; i++){
	        		
	        		service.userData.heros.add(Integer.parseInt(tmpStrVec[i]));
	        	}
        	}
        }
	}
}
