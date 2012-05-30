package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class Background extends MovieClip
	{		
		public var animado:Boolean
		
		public function Background() 
		{
			stop()
			Main.referenciar().addChild(this)
		}	
		
		public function mudar(imagem:String,_animado:Boolean = false)
		{
			animado = _animado
			this.x = 0
			this.gotoAndStop(imagem)
		}
		
		public function animar():void
		{
			if(Main.referenciar().BO_reviver)
			{
				this.x += 96
				if (this.x >= stage.stageWidth)
				{
					this.x = 0
				}
			}
			else
			{
				this.x -= 24
				if (this.x <= 0)
				{
					this.x = stage.stageWidth
				}
			}
		}
	}
}