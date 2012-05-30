package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ...
	 */
	public class Plataformas extends MovieClip
	{		
		public function Plataformas(posY:int=0) 
		{
			this.x = 600;
			this.y = posY
			Main.referenciar().addChild(this)
			Main.referenciar().AR_plataformas.push(this)
		}
		
		public function update():void
		{
			pisar()
			
			this.x -= 10
		}
		
		public function pisar():void
		{
			if (Main.referenciar().papaleguas.hitTestObject(this))
			{
				if (Main.referenciar().papaleguas.y <= this.y)
				{
					Main.referenciar().papaleguas.gotoAndPlay(1);
					Main.referenciar().papaleguas.y = this.y - Main.referenciar().papaleguas.height / 2;
					Main.referenciar().papaleguas.velocidadeY = -20;
					Main.referenciar().papaleguas.BO_pular = false;
					if (Main.referenciar().papaleguas.x > this.x + this.width / 2)
					{
						Main.referenciar().papaleguas.velocidadeY = 5;
						Main.referenciar().papaleguas.timer_sprint = 50;
						Main.referenciar().papaleguas.BO_sprint = false;
						Main.referenciar().papaleguas.BO_pular = true;
					}
				}
				else
				{
					Main.referenciar().papaleguas.y +=  this.height;
					Main.referenciar().papaleguas.velocidadeY *=  -1;
				}
			}
		}
	}

}