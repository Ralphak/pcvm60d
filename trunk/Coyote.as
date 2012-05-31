// Classe dos chefes das fases do jogo, que na verdade são as aparições do Coyote

package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Coyote extends MovieClip
	{
		
		public function Coyote(nivel:uint=0,posX:int=0,posY:int=0) // Comando usado para chamar o chefe
		{
			this.x = posX
			this.y = posY
			Main.referenciar().addChild(this)
			
			switch(nivel)	// Determina qual chefe será chamado, de acordo com o nível da fase
			{
				case 1 :
					Nivel1()
					break
			}
		}
		
		public function update():void	// Faz o chefe sair da fase, caso seja derrotado
		{
			if (this.alpha==1)	// Faz a imagem do chefe "piscar"
			{
				this.alpha=0
			}
			else
			{
				this.alpha=1
			}
			
			this.x -= 2
			if (this.x <= -50)	// Remove o chefe quando sai do cenário
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