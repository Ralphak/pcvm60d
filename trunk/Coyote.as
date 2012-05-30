package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class Coyote extends MovieClip
	{
		
		public function Coyote(nivel:uint=0,posX:int=0,posY:int=0) 
		{
			this.x = posX
			this.y = posY
			Main.referenciar().addChild(this)
			
			switch(nivel)
			{
				case 1 :
					Nivel1()
					break
			}
		}
		
		public function update():void
		{
			if (this.alpha==1)
			{
				this.alpha=0
			}
			else
			{
				this.alpha=1
			}
			
			this.x -= 2
			if (this.x <= -50)
			{
				Main.referenciar().BO_derrotar = false
				Main.referenciar().removeChild(this)
			}
		}
		
//---------- Nível 1 ----------//
		
		private function Nivel1():void
		{
			this.addEventListener(Event.ENTER_FRAME,posicionar,false,0,true)
		}
		
		private function posicionar(e:Event):void
		{
			if(this.x >= 70)
			{
				removeEventListener(Event.ENTER_FRAME,posicionar)
			}
			else
			{
				this.x += 5
			}
		}
	}
}