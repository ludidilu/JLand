package publicTools.connect
{
	import game.Game;
	

	public class Connect_handle
	{
		private static var arr:Array;
		private static var arr2:Array;
		private static var method:Function;
		private static var i:int,m:int;
		
		public function Connect_handle()
		{
		}
		
		public static function sendData(_id:int,...arg):void{
			
			Connect.sendData(_id,arg);
		}
		
		internal static function loginOK(_boolean:Boolean):void{
			
			Game.loginOK(_boolean);
		}
		
		internal static function getUserDataOK(_isInBattle:Boolean,_heros:Vector.<int>):void{
			
			Game.getUserData(_isInBattle,_heros);
		}
		
		internal static function logout():void{
			
			trace("被踢下线了！！");
		}
		
		internal static function enterQueueOK(_result:Boolean):void{
			
			Game.enterQueueOK(_result);
		}
		
		internal static function quitQueueOK(_result:Boolean):void{
			
			Game.quitQueueOK(_result);
		}
		
		internal static function fightAiOK(_result:Boolean):void{
			
			Game.fightAiOK(_result);
		}
		
		internal static function quitAiOK(_result:Boolean):void{
			
			Game.quitAiOK(_result);
		}
		
		internal static function enterBattle():void{
			
			Game.enterBattle();
		}
		
		internal static function getBattleDataOK(_isHost:Boolean,_nowRound:int,_maxRound:int,_mapID:int,_mapData:Vector.<int>,_myCards:Vector.<Vector.<int>>,_oppCardsNum:int,_userAllCardsNum1:int,_userAllCardsNum2:int,_heroData:Vector.<Vector.<int>>,_canMoveData:Vector.<int>,_isActioned:Boolean,_actionHeroData:Vector.<Vector.<int>>,_actionSummonData:Vector.<Vector.<int>>):void{
			
			Game.getBattleData(_isHost,_nowRound,_maxRound,_mapID,_mapData,_myCards,_oppCardsNum,_userAllCardsNum1,_userAllCardsNum2,_heroData,_canMoveData,_isActioned,_actionHeroData,_actionSummonData);
		}
		
		internal static function sendBattleActionOK(_result:Boolean):void{
			
			Game.sendBattleActionOK(_result);
		}
		
		internal static function playBattle(_summonData1:Vector.<Vector.<int>>,_summonData2:Vector.<Vector.<int>>,_moveData:Vector.<Vector.<int>>,_skillData:Vector.<Vector.<Vector.<int>>>,_attackData:Vector.<Vector.<Vector.<int>>>,_cardUid:int,_cardID:int,_oppCardID:int,_canMoveData:Vector.<int>):void{
			
			Game.playBattle(_summonData1,_summonData2,_moveData,_skillData,_attackData,_cardUid,_cardID,_oppCardID,_canMoveData);
		}
		
		internal static function quitBattleOK(_result:Boolean):void{
			
			
		}
		
		internal static function leaveBattle():void{
			
			Game.leaveBattle();
		}
		
		
		
		internal static function pushMsg(_str:String):void{
			
			trace("pushMsg:",_str);
		}
	}
}