package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class Botao extends MovieClip
	{
		var tipo:String
		var frame:uint
		
		public function Botao(_tipo:String,posX:int,posY:int) 
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
		
		private function botao_mudar (e:MouseEvent):void
		{
			this.gotoAndStop(frame+1)
		}

		private function botao_voltar (e:MouseEvent):void
		{
			this.gotoAndStop(frame)
		}

		private function botao_clicar (e:MouseEvent):void
		{
			this.gotoAndStop(frame+2)
		}

		private function botao_soltar (e:MouseEvent):void
		{
			this.gotoAndStop(frame+1)
		}
	}
}