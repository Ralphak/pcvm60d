// Classe da imagem de fundo do jogo (background).
// Controla a mudança de telas, assim como a animação de fundos animados.

package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Background extends MovieClip
	{		
		public var animado:Boolean	// Determina se o fundo é animado
		
		public function Background() // Construtora da classe
		{
			stop()
			Main.referenciar().addChild(this)
		}	
		
		public function mudar(imagem:String,_animado:Boolean = false)	// Comando responsável por trocar a imagem do fundo
		{
			animado = _animado
			this.x = 0
			this.gotoAndStop(imagem)
		}
		
		public function animar():void	// Faz a animação do fundo, caso ele seja animado
		{
			if(Main.referenciar().BO_reviver)	// Muda o tipo de animação caso esteja na cena de reviver
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