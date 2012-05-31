// Classe geradora dos vários tipos de obstáculos e projéteis do jogo

package  
{
	import flash.display.MovieClip;
	import flash.media.Sound;
	
	public class Obstaculos extends MovieClip
	{		
		var tipo:String	// Determina qual obstáculo será gerado
		
		var explosao:Sound = new som_explosao  ;	// Som de explosão
		var clique:Sound = new som_clique			// Som de clique da alavanca
		var queimar:Sound = new som_queimar			// Som emitido quando a armadilha de fogo está ligada
		
		var alavanca:MovieClip = new Alavanca  ;	// Imagem da alavanca
		var bomba:MovieClip = new Bomba  ;			// Imagem da bomba sob a rocha detonável
		var trap:MovieClip							// Imagem da armadilha de fogo
		
		var pedraY:Number = 12						// Posição Y da pedra
		var pedraG:Number = 1;						// Gravidade exercida sobre a pedra
		var velocidade:int;							// Velocidade na qual o obstáculo "se move"
		var angulo:Number							// Ângulo entre o vetor do projétil e o chão
		
		public var BO_detonado:Boolean	// Indica se o obstáculo foi detonado
		public var BO_projetil:Boolean	// Indica se o obstáculo é um projétil
		var BO_curvar:Boolean			// Determina a direção em que o projétil será lançado
		
		public function Obstaculos(_tipo:String,posX:uint=0,curvar:Boolean=false) 	// Comando usado para gerar o obstáculo
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
		
		public function update():void	// Determina como cada obstáculo irá se mover no cenário
		{			
			this.x -= velocidade
			
			switch(tipo)
			{
				case "pedra":	// Controla a gravidade da pedra saltitante
					pedraY +=  pedraG;
					this.y +=  pedraY;
					if (this.y >= 320)
					{
						pedraY = -12;
					}
					break
				case "rocha detonavel":	// Detona a rocha se o jogador acionar a alavanca				
					if (BO_detonado==false && Main.referenciar().papaleguas.hitTestObject(alavanca) && Main.referenciar().papaleguas.BO_sprint)
					{
						this.play();
						bomba.gotoAndPlay(2);
						alavanca.gotoAndStop(2);
						Main.referenciar().fxchannel = explosao.play();
						BO_detonado = true
					}
					break
				case "garfo":	// Libera o projétil na tela
					if (BO_projetil == false && Main.referenciar().coyote.currentFrame == 14)
					{
						play()
						this.alpha = 1
						this.x = Main.referenciar().coyote.x + Main.referenciar().coyote.width / 2;
						this.y = Main.referenciar().coyote.y - Main.referenciar().coyote.height;
						velocidade = -13
						BO_projetil = true
					}
					
					if (BO_curvar)	// Controla o vetor de movimento do projétil
					{
						this.y += Math.sin(angulo) * velocidade
						angulo -= 0.01
					}
					else
					{
						this.y -= Math.sin(angulo) * velocidade
						if (this.y >= 320)	// Ao encostar no chão, o projétil "ricocheteia"
						{
							angulo = 0.3
							BO_curvar = true
						}
					}
					break
				case "fireTrap":
				{
					if (BO_detonado==false && Main.referenciar().papaleguas.hitTestObject(alavanca) && Main.referenciar().papaleguas.BO_sprint)	// Desliga a armadilha de fogo quando o jogador aciona a alavanca
					{
						this.gotoAndPlay("desligar");
						alavanca.gotoAndStop(2);
						Main.referenciar().fxchannel = clique.play();
						BO_detonado = true
					}
					if (BO_detonado && Main.referenciar().coyote.hitTestObject(alavanca))	// Faz o chefe religar a armadilha quando ele passar pela alavanca
					{
						this.play()
						alavanca.gotoAndStop(1)
						Main.referenciar().fxchannel = clique.play()
						BO_detonado = false
					}
					if (Main.referenciar().BO_derrotar == false && Main.referenciar().coyote.hitTestObject(this))	// Faz o chefe "se dar mal" ao encostar na armadilha
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