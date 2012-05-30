package  
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	
	public class Roadrunner extends MovieClip
	{
		public var BO_liberarcontrole:Boolean;
		public var BO_pular:Boolean;
		public var BO_sprint:Boolean;
		var BO_cair:Boolean = true;
		
		public var timer_sprint:int;
		public var velocidadeY:Number;
		var gravidade:Number = 1.9;
		var acelerar:Number;
		
		var sompulo:Sound = new som_pulo  ;
		var somsprint:Sound = new rr_tonguemeeprun  ;
		
		
		public function Roadrunner(posX:int=0,posY:int=0,player:Boolean=false) 
		{
			this.x = posX
			this.y = posY
			
			if (player)
			{
				Main.referenciar().stage.addEventListener(KeyboardEvent.KEY_DOWN, controles,false,0,true)
			}
		}
		
		private function controles(e:KeyboardEvent):void
		{
			if (BO_liberarcontrole && !BO_pular && !BO_sprint)
			{
				switch (e.keyCode)
				{
					case Keyboard.UP :
							velocidadeY = -20;
							BO_pular = true;
							this.gotoAndStop("pular");
							Main.referenciar().fxchannel = sompulo.play();
						break;
					case Keyboard.DOWN :
							timer_sprint = 50
							BO_sprint = true;
							this.gotoAndPlay("sprint");
							Main.referenciar().fxchannel = somsprint.play(1120);
						break;
				}
			}
		}
		
		public function updateControles():void
		{			
			if (Main.referenciar().BO_reviver)
			{
				if (this.y >= 300)
				{
					this.y = 300;
				}
				else
				{
					acelerar +=  0.3;
					this.y +=  acelerar;	
				}
			
				if (this.alpha == 1)
				{
					this.alpha = 0
				}
				else
				{
					this.alpha = 1
				}
			}
			else
			{
				pular();
				sprint();
				
				this.alpha = 1
				acelerar = 0.3
			}
		}

		private function pular():void
		{
			if (BO_pular)
			{
				velocidadeY +=  gravidade;
				this.y +=  velocidadeY;
				if (this.y >= (310 + this.height / 2))
				{
					this.gotoAndPlay("correr");
					this.y = 310;
					BO_pular = false;
				}
			}
		}
		
		private function sprint():void
		{
			if (BO_sprint)
			{
				timer_sprint--;
				if (timer_sprint <= 0)
				{
					this.gotoAndPlay("correr");
					BO_sprint = false;
					timer_sprint = 50;
				}
			}
		}
		
		public function desativar_controles():void
		{
			BO_liberarcontrole = false
			BO_pular = false
			BO_sprint = false
		}
	}
}