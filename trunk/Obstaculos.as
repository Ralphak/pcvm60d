package  
{
	import flash.display.MovieClip;
	import flash.media.Sound;
	/**
	 * ...
	 * @author ...
	 */
	public class Obstaculos extends MovieClip
	{		
		var tipo:String
		
		var explosao:Sound = new som_explosao  ;
		var clique:Sound = new som_clique
		var queimar:Sound = new som_queimar
		
		var alavanca:MovieClip = new Alavanca  ;
		var bomba:MovieClip = new Bomba  ;
		var trap:MovieClip
		
		var pedraY:Number = 12
		var pedraG:Number = 1;
		var velocidade:int;
		var angulo:Number
		
		public var BO_detonado:Boolean
		public var BO_projetil:Boolean
		var BO_curvar:Boolean
		
		public function Obstaculos(_tipo:String,posX:uint=0,curvar:Boolean=false) 
		{
			Main.referenciar().addChild(this);
			Main.referenciar().AR_obstaculos.push(this)
			
			tipo = _tipo
			this.gotoAndStop(tipo)
			
			switch (_tipo)
			{
				case "cacto":
					this.x = 600;
					this.y = 325;
					velocidade = 10
					break
				case "pedra" :
					play()
					this.x = posX
					this.y = 250;
					velocidade = 15
					break
				case "rocha detonavel":
					this.x = 700
					this.y = 320
					velocidade = 10
					
					alavanca.x = 600;
					alavanca.y = 320;
					Main.referenciar().addChild(alavanca);
					Main.referenciar().AR_props.push(alavanca)
					alavanca.gotoAndStop(1);

					bomba.x = 700;
					bomba.y = this.y - bomba.height / 2;
					Main.referenciar().addChild(bomba);
					Main.referenciar().AR_props.push(bomba)
					bomba.gotoAndStop(1);
					break
				case "garfo" :
					this.alpha = 0
					angulo = 0.4
					BO_curvar = curvar
					Main.referenciar().coyote.gotoAndPlay("atirar1");
					break
				case "fireTrap":
					play()
					this.x = 660
					this.y = 330
					velocidade = 10
					
					alavanca.x = 600;
					alavanca.y = 320;
					Main.referenciar().addChild(alavanca);
					Main.referenciar().AR_props.push(alavanca)
					alavanca.gotoAndStop(1);
			}
		}
		
		public function update():void
		{			
			this.x -= velocidade
			
			switch(tipo)
			{
				case "pedra":
					pedraY +=  pedraG;
					this.y +=  pedraY;
					if (this.y >= 320)
					{
						pedraY = -12;
					}
					break
				case "rocha detonavel":				
					if (BO_detonado==false && Main.referenciar().papaleguas.hitTestObject(alavanca) && Main.referenciar().papaleguas.BO_sprint)
					{
						this.play();
						bomba.gotoAndPlay(2);
						alavanca.gotoAndStop(2);
						Main.referenciar().fxchannel = explosao.play();
						BO_detonado = true
					}
					break
				case "garfo":
					if (BO_projetil == false && Main.referenciar().coyote.currentFrame == 14)
					{
						play()
						this.alpha = 1
						this.x = Main.referenciar().coyote.x + Main.referenciar().coyote.width / 2;
						this.y = Main.referenciar().coyote.y - Main.referenciar().coyote.height;
						velocidade = -13
						BO_projetil = true
					}
					
					if (BO_curvar)
					{
						this.y += Math.sin(angulo) * velocidade
						angulo -= 0.01
					}
					else
					{
						this.y -= Math.sin(angulo) * velocidade
						if (this.y >= 320)
						{
							angulo = 0.3
							BO_curvar = true
						}
					}
					break
				case "fireTrap":
				{
					if (BO_detonado==false && Main.referenciar().papaleguas.hitTestObject(alavanca) && Main.referenciar().papaleguas.BO_sprint)
					{
						this.gotoAndPlay("desligar");
						alavanca.gotoAndStop(2);
						Main.referenciar().fxchannel = clique.play();
						BO_detonado = true
					}
					if (BO_detonado && Main.referenciar().coyote.hitTestObject(alavanca))
					{
						this.play()
						alavanca.gotoAndStop(1)
						Main.referenciar().fxchannel = clique.play()
						BO_detonado = false
					}
					if (Main.referenciar().BO_derrotar == false && Main.referenciar().coyote.hitTestObject(this))
					{
						Main.referenciar().BO_derrotar = true
						Main.referenciar().papaleguas.BO_liberarcontrole = false
						Main.referenciar().coyote.gotoAndStop("perdeu1")
						Main.referenciar().fxchannel = queimar.play()
					}
				}
			}
		}
	}
}