package game
{
	import flash.display.Stage;
	
	import connect.Connect;
	
	import game.battle.Battle;
	import game.gameQueue.GameQueuePanel;
	import game.login.LoginPanel;
	
	import playerData.PlayerData;
	
	import starling.core.Starling;
	
	public class Game
	{
		private static var stage:Stage;
		private static var loginPanel:LoginPanel;
		private static var gameQueuePanel:GameQueuePanel;
		private static var battle:Battle;
		
		public function Game()
		{
		}
		
		public static function init(_stage:Stage):void{
			
			new PlayerData;
			
			stage = _stage;
		}
		
		public static function start():void{
			
			loginPanel = new LoginPanel;
			gameQueuePanel = new GameQueuePanel;
			battle = new Battle;
			
			stage.addChild(loginPanel);
		}
		
		public static function loginOK(_boolean:Boolean):void{
			
			if(_boolean){
				
				Connect.sendData(2,getUserData);
				
			}else{
				
				loginPanel.loginFail();
			}
		}
		
		public static function syncData(_str:String):void{
			
			var data:Object = JSON.parse(_str);
			
			PlayerData.instance.sync(data);
			
			var ss:PlayerData = PlayerData.instance;
		}
		
		public static function getUserData(_isInBattle:Boolean,_playerData:String):void{
			
			stage.removeChild(loginPanel);
			
			var data:Object = JSON.parse(_playerData);
			
			PlayerData.instance.sync(data);
			
			var ss:PlayerData = PlayerData.instance;
			
			if(!_isInBattle){
				
				stage.addChild(gameQueuePanel);
				
			}else{
				
				enterBattle();
			}
		}
		
		public static function enterBattle():void{
			
			if(gameQueuePanel.parent != null){
				
				gameQueuePanel.reset();
				
				stage.removeChild(gameQueuePanel);
			}
			
			Connect.sendData(9,getBattleData);
		}
		
		public static function getBattleData(_isHost:Boolean,_nowRound:int,_maxRound:int,_mapID:int,_mapData:Vector.<int>,_myCards:Vector.<Vector.<int>>,_oppCardsNum:int,_userAllCardsNum1:int,_userAllCardsNum2:int,_heroData:Vector.<Vector.<int>>,_canMoveData:Vector.<int>,_isActioned:Boolean,_actionHeroData:Vector.<Vector.<int>>,_actionSummonData:Vector.<Vector.<int>>):void{
			
			battle.start(_isHost,_nowRound,_maxRound,_mapID,_mapData,_myCards,_oppCardsNum,_userAllCardsNum1,_userAllCardsNum2,_heroData,_canMoveData,_isActioned,_actionHeroData,_actionSummonData);
			
			Starling.current.stage.addChild(battle);
		}
		
		public static function playBattle(_summonData1:Vector.<Vector.<int>>,_summonData2:Vector.<Vector.<int>>,_moveData:Vector.<Vector.<int>>,_skillData:Vector.<Vector.<Vector.<int>>>,_attackData:Vector.<Vector.<Vector.<int>>>,_cardUid:int,_cardID:int,_oppCardID:int,_canMoveData:Vector.<int>):void{
			
			battle.playBattle(_summonData1,_summonData2,_moveData,_skillData,_attackData,_cardUid,_cardID,_oppCardID,_canMoveData);
		}
		
		public static function leaveBattle(_result:int):void{
			
			battle.leaveBattle(_result);
		}
		
		public static function leaveBattleOK():void{
			
			Starling.current.stage.removeChild(battle);
			
			stage.addChild(gameQueuePanel);
		}
	}
}