/**
* A Volta ao Mundo em 60 Dias
* @author Rafael Alves
*/

package 
{
	import fl.motion.MotionEvent;
	import fl.motion.Source;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

	public class Main extends MovieClip
	{
		
//-------------- Variáveis ---------------//

		public static var _instance:Main
		
		var fundo:Background	// Classe do background
		var papaleguas:Roadrunner ;	// Classe do papa-léguas (jogador)
		var coyote:Coyote;	//Classe do Coyote
		var bgm:BGM	// Classe de música de fundo
		var plataforma:Plataformas;	// Classe do gerador de plataformas
		var obstaculo:Obstaculos	// Classe do gerador de obstáculos
		var alpiste:Alpiste	// Classe do gerador de alpistes
		var alpisteIcone:Alpiste	// Ícone do contador de alpistes
		var botao:Botao	// Classe dos botões

		var nivel_atual:uint	//Indica em que fase o jogo está
		var fxchannel:SoundChannel = new SoundChannel  ;	// Canal controlador dos efeitos sonoros
		
		//Tela Inicial//
		var avatarPreload:MovieClip = new rr_avatar  ;	// Imagem do papa-léguas durante a tela de abertura
		var botao_prosseguir:MovieClip = new MovieClip;	// Botão para prosseguir para o menu principal 
		
		var som_abertura:Sound = new abertura	// Som emitido quando o jogo está carregado
		var som_meep:Sound = new rr_meep	// Som emitido pelo papa-léguas

		//Menus//
		var botao_iniciar:MovieClip = new MovieClip	//Botão para iniciar o jogo
		var botao_instrucoes:MovieClip = new MovieClip	//Botão para exibir as instruções
		var botao_voltar:MovieClip = new MovieClip;	// Botão para retornar ao menu principal
		var terra:MovieClip = new terragirando;	// Imagem do planeta Terra girando
		var titulo_main:MovieClip = new titulo;	// Título giratório
		var Menu_Principal:MovieClip = new MovieClip;	// MovieClip mestre da tela principal
		var Menu_Instrucoes:MovieClip	//MovieClip mestre da tela de instruções
		
		//Prologo 1//
		var prologo:MovieClip = new MovieClip  ;	//MovieClip mestre da tela de prólogo
		var fade:MovieClip	// Camada usada para provocar efeito de escuridão na tela
		var story:MovieClip = new Story	// Texto presente no prólogo
		var anykey:MovieClip = new Pressanykey  ;	// Imagem com a mensagem "Pressione qualquer tecla para continuar"
		
		//Nivel 1//
		var alarmepreparar:Sound = new som_preparar  ;	// Alarme indicando início do jogo
		var alarmeboss:Sound = new som_alarme	// Alarme indicando a presença do chefe da fase
		var apitar:Sound = new som_apito  ;	// Apito que avisa o início do jogo
				
		var meep:Sound = new fastmeep  ;	// Som emitido quando o papa-léguas é atingido
		var frear:Sound = new som_frear		// Som de freio

		var placa_preparar:MovieClip = new prepararvai  ;	// Elemento temporário da HUD que avisa o início do jogo
		
		var AR_obstaculos:Array = new Array  ;	// Array de obstáculos
		var AR_plataformas:Array = new Array;	// Array de plataformas
		var AR_props:Array = new Array;			// Array de elementos do cenário, como alavancas
		var AR_alpiste:Array = new Array		// Array de alpistes

		var contadorFrame:int;		// Contador de frames
		var contadorAlpiste:uint	// Contador de alpistes coletados pelo jogador
		
		var TF_contador:TextField = new TextField		// Texto do contador de alpistes
		var TF_teaser:TextField = new TextField			// Texto da tela de teasers
		var textoFormato:TextFormat = new TextFormat	// Formatação de texto
				
		var BO_reviver:Boolean;		// Indica se o jogador está revivendo ou não
		var BO_derrotar:Boolean		// Indica se o chefe foi derrotado
		var BO_final:Boolean		// Indica se a fase chegou ao fim
		
		//Demo//
		var pinguim:MovieClip = new Pinguim					// Pinguim-bomba
		var botao_seguirDemo:MovieClip = new MovieClip		// Botão para seguir demonstrações
		var folks:Sound = new som_folks						// Música de fim de jogo
		var explosaoPinguim:Sound = new som_explosao  ;		// Som de explosão
	
//-------------- Fim das Variáveis ---------------//		


//--------------- Tela Inicial ---------------//	

		public function Main()
		{
			
			// Instanciamento da Main
			_instance = this
			
			// Formatação de texto
			textoFormato.color = 0xFFFF00;
			textoFormato.font = "Arial";
			textoFormato.size = 16;
			TF_contador.defaultTextFormat = textoFormato;
			TF_contador.selectable = false;
			TF_teaser.defaultTextFormat = textoFormato
			TF_teaser.selectable = false
			
			// Carregamento da tela de abertura
			fundo = new Background
			fundo.mudar("Tela Inicial")
			
			fxchannel = som_abertura.play()
			
			avatarPreload.x = 256;
			avatarPreload.y = 304;
			addChild(avatarPreload);

			botao = new Botao("prosseguir",280,370)
			botao_prosseguir.addChild(botao)
			addChild(botao_prosseguir);

			botao_prosseguir.addEventListener(MouseEvent.CLICK, prosseguir, false, 0, true);
			avatarPreload.addEventListener(MouseEvent.CLICK, buzina, false, 0, true);
		}
		
		public static function referenciar():Main	// Função responsável por referenciar à Main nas classes filhas
		{			
			return _instance
		}

		private function buzina(e:Event):void	// Faz com que o papa-léguas emita um som ao clicar nele
		{			
			if (avatarPreload.currentFrame == 22)
			{
				avatarPreload.gotoAndPlay(23);
				fxchannel = som_meep.play()
			}
		}
		
		private function prosseguir(e:Event):void	// Muda da tela de abertura para o menu principal
		{			
			fxchannel.stop()
			removeChild(avatarPreload);
			removeChild(botao_prosseguir);
			removeEventListener(MouseEvent.CLICK, prosseguir);
			removeEventListener(MouseEvent.CLICK, buzina);
			Menus();
		}
		
//--------------- Menu Principal ---------------//		

		private function Menus():void	// Carregamento da interface de menus
		{
			bgm = new BGM
			fundo.mudar("Menu Principal")
			
			titulo_main.x = stage.stageWidth / 2;
			titulo_main.y = stage.stageHeight / 2;
			Menu_Principal.addChild(titulo_main);

			terra.x = stage.stageWidth / 2;
			terra.y = stage.stageHeight / 2;
			Menu_Principal.addChild(terra);

			botao = new Botao("iniciar",stage.stageWidth/2,stage.stageHeight/2)
			botao_iniciar.addChild(botao)
			Menu_Principal.addChild(botao_iniciar);

			botao = new Botao("instrucoes",500,350)
			botao_instrucoes.addChild(botao)
			Menu_Principal.addChild(botao_instrucoes);
			
			papaleguas = new Roadrunner(280,103)
			Menu_Principal.addChild(papaleguas);

			coyote = new Coyote(0, 250, 282)
			coyote.rotation = 180
			Menu_Principal.addChild(coyote);
			
			addChild(Menu_Principal);
			
			Menu_Instrucoes = new Instrucoes
			
			botao = new Botao("voltar",stage.stageWidth/2,370)
			botao_voltar.addChild(botao);
			Menu_Instrucoes.addChild(botao_voltar)
			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			botao_iniciar.addEventListener(MouseEvent.CLICK, iniciar, false, 0, true);
			botao_instrucoes.addEventListener(MouseEvent.CLICK, instrucoes, false, 0, true);
			botao_voltar.addEventListener(MouseEvent.CLICK, voltar, false, 0, true);
		}
		
		private function update(e:Event):void	// O update do jogo. Todos os updates de cada fase são controlados por essa função.
		{	
			if (fundo.animado) // Ativa a animação do fundo de tela caso ele seja animado
			{
				fundo.animar()
			}
			
			switch(nivel_atual) // Controla qual update será ativado de acordo com o nível atual.
								// Nivel 0 significa que o jogo está em um menu.
			{
				case 1 :
					update_L1()
					break
			}
		}

		private function iniciar(e:MouseEvent):void		// Sai do menu principal e inicia o jogo
		{
			removeChild(Menu_Principal);
			removeEventListener(MouseEvent.CLICK, iniciar);
			removeEventListener(MouseEvent.CLICK, instrucoes);
			removeEventListener(MouseEvent.CLICK,voltar)
			prologo_L1()
		}
		
		private function instrucoes(e:MouseEvent):void	// Muda do menu principal para a tela de instruções
		{
			removeChild(Menu_Principal);
			addChild(Menu_Instrucoes)
		}
	
		private function voltar(e:MouseEvent):void	// Retorna da tela de instruções para o menu principal
		{
			removeChild(Menu_Instrucoes);
			addChild(Menu_Principal);
		}
		
//--------------- Prólogo 1 ---------------//		
		
		public function prologo_L1()	// Carregamento da tela de prólogo
		{
			bgm.canal.stop()
			fundo.mudar("Prologo 1")
			fade = new Fade
			fade.alpha = 0.7
			addChild(fade);
			fade.addChild(story);
			anykey.x = stage.stageWidth / 2;
			anykey.y = 350;
			fade.addChild(anykey);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, iniciar_L1, false, 0, true);
		}
		
//--------------- Nível 1 ---------------//		
		
		private function iniciar_L1(e:KeyboardEvent):void	// Carrega o nível 1
		{
			nivel_atual = 1
			removeChild(fade);
			fundo.mudar("Nivel 1", true)

			alpisteIcone = new Alpiste(30, true)
			TF_contador.x = 25;
			TF_contador.y = -11;
			alpisteIcone.addChild(TF_contador)

			papaleguas = new Roadrunner(-45,310,true)
			addChild(papaleguas);

			placa_preparar.x = stage.stageWidth / 2;
			placa_preparar.y = 200;
			addChild(placa_preparar);
			placa_preparar.gotoAndStop(1)

			alarmepreparar.play(0, 4);
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, iniciar_L1);
		}

		private function update_L1():void	// Update do nível 1
		{
			TF_contador.text = String(contadorAlpiste)				
			papaleguas.updateControles()
			
			if (!BO_reviver)	// Se o jogador não estiver revivendo, prosseguir com o jogo
			{
				linhatempo();
				colisoes();
			}
			
			if (BO_derrotar)	// Se o chefe for derrotado, ativar animação que retira-o da fase
			{
				coyote.update()
			}
			
			if (BO_final)	// Se a fase terminar, fazer com que o papa-léguas saia da cena
			{
				papaleguas.x += 20
			}
			
			for each (plataforma in AR_plataformas)	// Ativa o update de cada plataforma
			{
				plataforma.update()
			}
			
			for each (obstaculo in AR_obstaculos)	// Ativa o update de cada obstáculo
			{
				obstaculo.update()
			}
			
			for each (var prop:MovieClip in AR_props)	// Ativa o update de cada elemento do cenário
			{
				prop.x -= 10
			}
			
			for each (alpiste in AR_alpiste)	// Ativa o update de cada alpiste
			{
				alpiste.update()
			}
		}

		private function linhatempo():void	// Linha de tempo da fase
		{
			if (BO_reviver == false && papaleguas.x >= stage.stageWidth / 2)	// As cenas de preparação e de reviver interrompem o contador de frames
			{
				contadorFrame++;
			}
			else	// Posiciona o papa-léguas durante a tela de preparação
			{
				papaleguas.x +=  8;
			}
			switch (contadorFrame)	// Controla o roteiro da fase
			{
				case 1 :	// Avisa que o jogo começou
					placa_preparar.gotoAndStop(2);
					apitar.play(1120);
					break;
				case 28 :	// Remove a placa de preparação da HUD
					removeChild(placa_preparar);
					break;
				case 30 :	// Liberar controles para o jogo e tocar música de fundo.
					bgm.mudarMusica("nivel 1", 50)
					papaleguas.BO_liberarcontrole = true;
					break;
				case 35:	
					alpiste = new Alpiste(300);	// Gerar novo alpiste no cenário
					break;
				case 40 :	
					obstaculo = new Obstaculos("cacto")	// Gerar obstáculo de cacto no cenário
					break;
				case 65 :
					obstaculo = new Obstaculos("cacto")
					break;
				case 90 :
					obstaculo = new Obstaculos("cacto")
					break;
				case 120 :
					obstaculo = new Obstaculos("cacto");
					plataforma = new Plataformas(240)	// Gerar nova plataforma no cenário
					plataforma.width = plataforma.width * 2;
					break;
				case 145 :
					plataforma = new Plataformas(180)
					break;
				case 160 :
					obstaculo = new Obstaculos("cacto");
					break;
				case 170 :
					plataforma = new Plataformas(120)
					alpiste = new Alpiste(90);
					break;
				case 200 :
					obstaculo = new Obstaculos("rocha detonavel");	// Gerar rocha detonável, assim como a alavanca de detonação
					break;
				case 250 :
					obstaculo = new Obstaculos("pedra",580);	// Gerar pedras saltitantes
					break;
				case 280 :
					obstaculo = new Obstaculos("pedra",700);
					alpiste = new Alpiste(240);
					break;
				case 300 :
					obstaculo = new Obstaculos("pedra",580);
					break;
				case 310 :
					obstaculo = new Obstaculos("pedra",580);
					break;
				case 320 :
					obstaculo = new Obstaculos("pedra",700);
					alpiste = new Alpiste(240);
					break;
				case 360:	// Tocar alerta de presença de chefe
					fxchannel = alarmeboss.play()	
					break
				case 400 :	// Gerar o chefe da fase
					coyote = new Coyote(1,-70,322);
					break;
				case 450 :
					obstaculo = new Obstaculos("garfo")	// Ordenar que o chefe atire um projétil
					break;
				case 475:
					obstaculo = new Obstaculos("garfo",0,true)	// Ordenar que o chefe atire um projétil em outra direção
					break
				case 500:
					obstaculo = new Obstaculos("garfo")
					break;
				case 525:
					obstaculo = new Obstaculos("garfo")
					break;
				case 550:
					obstaculo = new Obstaculos("garfo")
					break;
				case 575:
					obstaculo = new Obstaculos("garfo",0,true)
					break;
				case 600:
					obstaculo = new Obstaculos("garfo")
					break;
				case 625:
					obstaculo = new Obstaculos("garfo")
					break;
				case 650:
					obstaculo = new Obstaculos("garfo", 0, true)
					break;
				case 675:
					obstaculo = new Obstaculos("garfo", 0, true)
					obstaculo = new Obstaculos("fireTrap")	// Gerar armadilha de fogo, assim como a alavanca que a controla
					break;
				case 790:	// Começar cena de término da fase
					papaleguas.gotoAndStop("frear")
					bgm.canal.stop()
					fxchannel = frear.play()
					break
				case 810:
					fundo.mudar("Prologo 1")
					papaleguas.gotoAndStop("parado")
					break
				case 840:
					papaleguas.gotoAndPlay("final")
					bgm.mudarMusica("finalizar") // Música de fundo que abre a interface de teasers quando terminada
					break
				case 868:	// Terminar a fase
					BO_final = true
					break
			}
		}

		private function colisoes():void	// Gerenciador de eventos de colisão
		{
			for (var o:int = 0; o < AR_obstaculos.length; o++)
			{
				if (AR_obstaculos[o].x < 0)	// Remove o obstáculo se ele sair do cenário
				{
					removeChild(AR_obstaculos[o]);
					AR_obstaculos.splice(o,1);
				}
				if (AR_obstaculos[o] != null && AR_obstaculos[o].BO_projetil && AR_obstaculos[o].x > stage.stageWidth)	// Remove o projétil se ele sair do cenário
				{
					removeChild(AR_obstaculos[o]);
					AR_obstaculos.splice(o,1);
				}
				if (AR_obstaculos[o] != null && papaleguas.hitTestObject(AR_obstaculos[o]) && AR_obstaculos[o].BO_detonado == false)	// Se o jogador atingir um obstáculo, iniciar cena de reviver
				{
					morte();
				}
			}
			for (var r:int = 0; r < AR_props.length; r++)
			{
				if (AR_props[r].x < 0)	// Remove o elemento se ele sair do cenário
				{
					removeChild(AR_props[r])
					AR_props.splice(r,1)
				}
			}
			for (var p:int = 0; p < AR_plataformas.length; p++)
			{
				if (AR_plataformas[p].x < 0)	// Remove a plataforma se ela sair do cenário
				{
					removeChild(AR_plataformas[p]);
					AR_plataformas.splice(p,1);
				}
			}
			for (var a:int = 0; a < AR_alpiste.length; a++)
			{
				if (AR_alpiste[a].x < 0)	// Remove o alpiste se ele sair do cenário
				{
					removeChild(AR_alpiste[a])
					AR_alpiste.splice(a,1)
				}
				if (AR_alpiste[a] != null && papaleguas.hitTestObject(AR_alpiste[a]))	// Se o jogador pegar alpiste, adicioná-lo ao contador
				{
					fxchannel = AR_alpiste[a].somalpiste.play();
					contadorAlpiste++
					removeChild(AR_alpiste[a])
					AR_alpiste.splice(a,1)
				}
			}
		}

		private function morte():void	// Carrega a cena de reviver, além de reiniciar a fase
		{
			papaleguas.desativar_controles()
			BO_reviver = true;
			limparArrays()
			if (contadorFrame >= 350)	// Remove o chefe da fase caso esteja presente
			{
				removeChild(coyote)
			}
			contadorFrame = 29;
			contadorAlpiste = 0
			papaleguas.velocidadeY = 0;
			fxchannel.stop(); 
			bgm.mudarMusica("reviver")	// Música de fundo que faz o jogo reiniciar quando terminada
			papaleguas.gotoAndStop("reviver");
			meep.play();
		}
		
		private function limparArrays():void	// Limpa todas as arrays da fase
		{
			while (AR_plataformas.length > 0)
			{
				removeChild(AR_plataformas[0]);
				AR_plataformas.splice(0,1);
			}
			while (AR_obstaculos.length > 0)
			{
				removeChild(AR_obstaculos[0]);
				AR_obstaculos.splice(0,1);
			}
			while (AR_props.length > 0)
			{
				removeChild(AR_props[0])
				AR_props.splice(0,1)
			}
			while (AR_alpiste.length > 0)
			{
				removeChild(AR_alpiste[0])
				AR_alpiste.splice(0,1)
			}
		}

//---------- Demo ----------//

		public function Demo():void	// Descarrega a fase e em seguida carrega a interface de teasers.
									// A função é acionada pela classe BGM.
		{
			nivel_atual = 0
			limparArrays()
			contadorFrame = 0;
			contadorAlpiste = 0
			removeChild(papaleguas)
			removeChild(alpisteIcone)
			bgm.mudarMusica("demo")
			fundo.mudar("vazio")
			TF_teaser.x = 20
			TF_teaser.y = 20
			TF_teaser.width = 220
			TF_teaser.wordWrap = true
			TF_teaser.text = "Alguns concepts de fases:"
			addChild(TF_teaser)
			
			botao = new Botao("prosseguir", stage.stageWidth / 2, 370)
			botao_seguirDemo.addChild(botao)
			addChild(botao_seguirDemo)
			botao_seguirDemo.addEventListener(MouseEvent.CLICK, seguirDemo, false, 0, true)
			
			pinguim.x = stage.stageWidth / 2
			pinguim.y = stage.stageHeight / 2 + pinguim.height / 2
			addChild(pinguim)
			pinguim.addEventListener(MouseEvent.CLICK,explodir,false,0,true)
		}
		
		private function seguirDemo(e:MouseEvent):void	// Controlador de telas da interface de teasers
														// É associado ao clique no botão de prosseguir
		{
			contadorFrame++
			switch(contadorFrame)	// Muda de tela ao clicar no botão de prosseguir
			{
				case 1:
					removeChild(pinguim)
					fundo.mudar("teaser1")
					TF_teaser.text = "Guarda-chuva: Trinta reais"
					break
				case 2:
					fundo.mudar("teaser2")
					TF_teaser.text = "Tanque de guerra moderno: Alguns milhões de dólares"
					break
				case 3:
					fundo.mudar("teaser3")
					TF_teaser.text = "Ver seu predador virar presa: Não tem preço"
					break
				case 4:
					contadorFrame = 0
					fundo.mudar("folks")
					fundo.play()
					botao_seguirDemo.removeEventListener(MouseEvent.CLICK,seguirDemo)
					removeChild(botao_seguirDemo)
					removeChild(TF_teaser)
					bgm.canal.stop()
					fxchannel = folks.play()
			}
		}
		
		private function explodir(e:MouseEvent):void	// Explode o pinguim ao clicar nele
		{
			pinguim.removeEventListener(MouseEvent.CLICK, explodir)
			pinguim.gotoAndPlay("explodir")
			fxchannel = explosaoPinguim.play()
			TF_teaser.text = "Seu monstro!"
		}
	}
}