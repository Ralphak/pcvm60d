// Classe do Papa-Léguas, o personagem do jogador, e dos controles do jogo
// Também gera o papaléguas presente no menu principal

package  
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	
	public class Roadrunner extends MovieClip
	{
		public var BO_liberarcontrole:Boolean;	// Libera os controles quando o jogo começar
		public var BO_pular:Boolean;	// Determina se o jogador está realizando um pulo
		public var BO_sprint:Boolean;	// Determina se o modo sprint está ativado
		
		public var timer_sprint:int;	// O tempo restante do modo sprint
		public var velocidadeY:Number;	// A velocidade do pulo ou da queda do jogador
		var gravidade:Number = 1.9;		// A gravidade exercida sobre o jogador
		var acelerar:Number;			// A aceleração da gravidade
		
		var sompulo:Sound = new som_pulo  ;		// Som emitido ao pular
		var somsprint:Sound = new rr_tonguemeeprun  ;	// Som emitido ao ativar o modo sprint
		
		
		public function Roadrunner(posX:int=0,posY:int=0,player:Boolean=false) 	// Construtora da classe
		{
			this.x = posX
			this.y = posY
			
			if (player)	// Diferencia o jogador do papa-léguas no menu principal
			{
				Main.referenciar().stage.addEventListener(KeyboardEvent.KEY_DOWN, controles,false,0,true)
			}
		}
		
		private function controles(e:KeyboardEvent):void	// Os controles do jogador
		{
			if (BO_liberarcontrole && !BO_pular && !BO_sprint)	// Se os controles forem liberados e nenhum comando estiver ativo
			{
				switch (e.keyCode)
				{
					case Keyboard.UP :	// Comando de pulo
							velocidadeY = -20;
							BO_pular = true;
							this.gotoAndStop("pular");
							Main.referenciar().fxchannel = sompulo.play();
						break;
					case Keyboard.DOWN :	// Comando do modo sprint
							timer_sprint = 50
							BO_sprint = true;
							this.gotoAndPlay("sprint");
							Main.referenciar().fxchannel = somsprint.play(1120);
						break;
				}
			}
		}
		
		public function updateControles():void	// O update do jogador
		{			
			if (Main.referenciar().BO_reviver)	// Posiciona o jogador durante a cena de reviver
			{
				if (this.y >= 300)	// Evita que o jogador saia do cenário ao cair
				{
					this.y = 300;
				}
				else	// Se o jogador estiver no ar, fazer com que ele caia
				{
					acelerar +=  0.3;
					this.y +=  acelerar;	
				}
			
				if (this.alpha == 1)	// Fazer a imagem do jogador "piscar" durante a cena de reviver
				{
					this.alpha = 0
				}
				else
				{
					this.alpha = 1
				}
			}
			else	//	Aciona os comandos caso eles tenham sido requisitados pelo jogador
			{
				pular();
				sprint();
				
				// Restaura os valores padrões ao sair da cena de reviver
				this.alpha = 1
				acelerar = 0.3
			}
		}

		private function pular():void	// Comando de pulo
		{
			if (BO_pular)
			{
				velocidadeY +=  gravidade;
				this.y +=  velocidadeY;
				if (this.y >= (310 + this.height / 2))	// Desativa o pulo ao encostar no chão
				{
					this.gotoAndPlay("correr");
					this.y = 310;
					BO_pular = false;
				}
			}
		}
		
		private function sprint():void	// Comando do modo sprint
		{
			if (BO_sprint)
			{
				timer_sprint--;
				if (timer_sprint <= 0)	// Desativa o modo sprint após um certo tempo
				{
					this.gotoAndPlay("correr");
					BO_sprint = false;
					timer_sprint = 50;
				}
			}
		}
		
		public function desativar_controles():void	// Bloqueia os controles e interrompe os comandos ativos para evitar problemas desnecessários
		{
			BO_liberarcontrole = false
			BO_pular = false
			BO_sprint = false
		}
	}
}