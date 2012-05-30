package  
{
	import flash.display.MovieClip;
	import flash.media.Sound;
	/**
	 * ...
	 * @author ...
	 */
	public class Alpiste extends MovieClip
	{
		var somalpiste:Sound = new som_alpiste  ;
		var hud:Boolean
		
		public function Alpiste(posY:int,_hud:Boolean=false) 
		{
			Main.referenciar().addChild(this)
			hud = _hud
			this.y = posY
			
			if(hud)
			{
				this.x = 35;
			}
			else
			{
				this.x = 600;
				Main.referenciar().AR_alpiste.push(this)
			}				
		}
		
		public function update():void
		{
			if(hud==false)
			{
				this.x -= 10
				
			}
		}
	}

}