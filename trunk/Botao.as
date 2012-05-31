// Classe dos botões presentes nos menus do jogo

package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Botao extends MovieClip
	{
		var tipo:String	// Determina qual botão será gerado
		var frame:uint	// Variável responsável por controlar a animação dos botões
		
		public function Botao(_tipo:String,posX:int,posY:int) // Comando usado para gerar o botão
		{
			tipo = _tipo
			this.gotoAndStop(tipo)
			frame = this.currentFrame
			this.x = posX
			this.y = posY
			
			this.addEventListener(MouseEvent.MOUSE_OVER, botao_mudar,false,0,true)
			this.addEventListener(MouseEvent.MOUSE_OUT, botao_voltar,false,0,true)
			this.addEventListener(MouseEvent.MOUSE_DOWN, botao_clicar,false,0,true)
			this.addEventListener(MouseEvent.MOUSE_UP, botao_soltar,false,0,true)
		}
		
		private function botao_mudar (e:MouseEvent):void	// Animação quando o mouse está sobre o botão
		{
			this.gotoAndStop(frame+1)
		}

		private function botao_voltar (e:MouseEvent):void	// Volta ao frame anterior quando o mouse não está mais sobre o botão
		{
			this.gotoAndStop(frame)
		}

		private function botao_clicar (e:MouseEvent):void	// Animação quando clica no botão
		{
			this.gotoAndStop(frame+2)
		}

		private function botao_soltar (e:MouseEvent):void	// Volta ao frame anterior quando solta o botão do mouse
		{
			this.gotoAndStop(frame+1)
		}
	}
}