// Classe geradora das plataformas do jogo

package  
{
	import flash.display.MovieClip;
	
	public class Plataformas extends MovieClip
	{		
		public function Plataformas(posY:int=0) // Comando usado para gerar a plataforma
		{
			this.x = 600;
			this.y = posY
			Main.referenciar().addChild(this)
			Main.referenciar().AR_plataformas.push(this)
		}
		
		public function update():void	// Faz a plataforma "se mover" no cenário
		{
			pisar()
			
			this.x -= 10
		}
		
		public function pisar():void	// Controla as colisões entre a plataforma e o jogador
		{
			if (Main.referenciar().papaleguas.hitTestObject(this))
			{
				if (Main.referenciar().papaleguas.y <= this.y)	// Faz com que o jogador fique em cima da plataforma ao pular sobre ela
				{
					Main.referenciar().papaleguas.gotoAndPlay(1);
					Main.referenciar().papaleguas.y = this.y - Main.referenciar().papaleguas.height / 2;
					Main.referenciar().papaleguas.velocidadeY = -20;
					Main.referenciar().papaleguas.BO_pular = false;
					if (Main.referenciar().papaleguas.x > this.x + this.width / 2) // Faz o jogador cair da plataforma se ele sair dela
					{
						Main.referenciar().papaleguas.velocidadeY = 5;
						Main.referenciar().papaleguas.timer_sprint = 50;
						Main.referenciar().papaleguas.BO_sprint = false;
						Main.referenciar().papaleguas.BO_pular = true;
					}
				}
				else	// Faz o jogador ser rebatido caso colida com a plataforma por baixo dela
				{
					Main.referenciar().papaleguas.y +=  this.height;
					Main.referenciar().papaleguas.velocidadeY *=  -1;
				}
			}
		}
	}

}