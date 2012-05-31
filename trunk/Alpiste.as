// Classe dos alpistes, um item colecionável do jogo.
// Também gera o ícone do contador de alpistes na HUD.

package  
{
	import flash.display.MovieClip;
	import flash.media.Sound;
	
	public class Alpiste extends MovieClip
	{
		var somalpiste:Sound = new som_alpiste  ;	// Som emitido quando o jogador pega o item
		var hud:Boolean		// Diferencia o item colecionável do ícone na HUD
		
		public function Alpiste(posY:int,_hud:Boolean=false)	// Comando para gerar o alpiste
		{
			Main.referenciar().addChild(this)
			hud = _hud
			this.y = posY
			
			if(hud)	// Posiciona o ícone na HUD
			{
				this.x = 35;
			}
			else	// Posiciona o item no cenário
			{
				this.x = 600;
				Main.referenciar().AR_alpiste.push(this)
			}				
		}
		
		public function update():void	// Faz o item "se mover" no cenário
		{
			if(hud==false)
			{
				this.x -= 10
				
			}
		}
	}

}