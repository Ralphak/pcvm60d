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
	/**
	 * ...
	 * @author Rafael Alves
	 */
	public class Main extends MovieClip
	{
		
//-------------- Variáveis ---------------//

		public static var _instance:Main
		
		var fundo:Background
		var papaleguas:Roadrunner ;
		var coyote:Coyote;
		var bgm:BGM
		var plataforma:Plataformas;
		var obstaculo:Obstaculos
		var alpiste:Alpiste
		var alpisteIcone:Alpiste
		var botao:Botao

		var nivel_atual:uint
		var fxchannel:SoundChannel = new SoundChannel  ;
		
		//Tela Inicial//
		var avatarPreload:MovieClip = new rr_avatar  ;
		var botao_prosseguir:MovieClip = new MovieClip;
		
		var som_abertura:Sound = new abertura
		var som_meep:Sound = new rr_meep

		//Menus//
		var botao_iniciar:MovieClip = new MovieClip
		var botao_instrucoes:MovieClip = new MovieClip
		var botao_voltar:MovieClip = new MovieClip;
		var terra:MovieClip = new terragirando;
		var titulo_main:MovieClip = new titulo;
		var Menu_Principal:MovieClip = new MovieClip;
		var Menu_Instrucoes:MovieClip
		
		//Prologo 1//
		var prologo:MovieClip = new MovieClip  ;
		var fade:MovieClip
		var story:MovieClip = new Story
		var anykey:MovieClip = new Pressanykey  ;
		
		//Nivel 1//
		var alarmepreparar:Sound = new som_preparar  ;
		var alarmeboss:Sound = new som_alarme
		var apitar:Sound = new som_apito  ;
				
		var meep:Sound = new fastmeep  ;
		var frear:Sound = new som_frear

		var placa_preparar:MovieClip = new prepararvai  ;
		
		var AR_obstaculos:Array = new Array  ;
		var AR_plataformas:Array = new Array;
		var AR_props:Array = new Array;
		var AR_alpiste:Array = new Array

		var contadorFrame:int;
		var contadorAlpiste:uint
		
		var TF_contador:TextField = new TextField
		var TF_teaser:TextField = new TextField
		var textoFormato:TextFormat = new TextFormat
				
		var BO_reviver:Boolean;
		var BO_derrotar:Boolean
		var BO_final:Boolean
		
		//Demo//
		var pinguim:MovieClip = new Pinguim
		var botao_seguirDemo:MovieClip = new MovieClip
		var folks:Sound = new som_folks
		var explosaoPinguim:Sound = new som_explosao  ;
	
//-------------- Fim das Variáveis ---------------//		


//--------------- Tela Inicial ---------------//	

		public function Main()
		{
			_instance = this
			
			textoFormato.color = 0xFFFF00;
			textoFormato.font = "Arial";
			textoFormato.size = 16;
			TF_contador.defaultTextFormat = textoFormato;
			TF_contador.selectable = false;
			TF_teaser.defaultTextFormat = textoFormato
			TF_teaser.selectable = false
			
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
		
		public static function referenciar():Main
		{
			return _instance
		}

		private function buzina(e:Event):void
		{
			if (avatarPreload.currentFrame == 22)
			{
				avatarPreload.gotoAndPlay(23);
				fxchannel = som_meep.play()
			}
		}
		
		private function prosseguir(e:Event):void
		{
			fxchannel.stop()
			removeChild(avatarPreload);
			removeChild(botao_prosseguir);
			removeEventListener(MouseEvent.CLICK, prosseguir);
			removeEventListener(MouseEvent.CLICK, buzina);
			Menus();
		}
		
//--------------- Menu Principal ---------------//		

		private function Menus():void
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
		
		private function update(e:Event):void
		{			
			if (fundo.animado)
			{
				fundo.animar()
			}
			
			switch(nivel_atual)
			{
				case 1 :
					update_L1()
					break
			}
		}

		private function iniciar(e:MouseEvent):void
		{
			removeChild(Menu_Principal);
			removeEventListener(MouseEvent.CLICK, iniciar);
			removeEventListener(MouseEvent.CLICK, instrucoes);
			removeEventListener(MouseEvent.CLICK,voltar)
			prologo_L1()
		}
		
		private function instrucoes(e:MouseEvent):void
		{
			removeChild(Menu_Principal);
			addChild(Menu_Instrucoes)
		}
	
		private function voltar(e:MouseEvent):void
		{
			removeChild(Menu_Instrucoes);
			addChild(Menu_Principal);
		}
		
//--------------- Prólogo 1 ---------------//		
		
		public function prologo_L1()
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
		
		private function iniciar_L1(e:KeyboardEvent):void
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

		private function update_L1():void
		{
			TF_contador.text = String(contadorAlpiste)				
			papaleguas.updateControles()
			
			if (!BO_reviver)
			{
				linhatempo();
				colisoes();
			}
			
			if (BO_derrotar)
			{
				coyote.update()
			}
			
			if (BO_final)
			{
				papaleguas.x += 20
			}
			
			for each (plataforma in AR_plataformas)
			{
				plataforma.update()
			}
			
			for each (obstaculo in AR_obstaculos)
			{
				obstaculo.update()
			}
			
			for each (var prop:MovieClip in AR_props)
			{
				prop.x -= 10
			}
			
			for each (alpiste in AR_alpiste)
			{
				alpiste.update()
			}
		}

		private function linhatempo():void
		{
			if (BO_reviver == false && papaleguas.x >= stage.stageWidth/2)
			{
				contadorFrame++;
			}
			else
			{
				papaleguas.x +=  8;
			}
			switch (contadorFrame)
			{
				case 1 :
					placa_preparar.gotoAndStop(2);
					apitar.play(1120);
					break;
				case 28 :
					removeChild(placa_preparar);
					break;
				case 30 :
					bgm.mudarMusica("nivel 1", 50)
					papaleguas.BO_liberarcontrole = true;
					break;
				case 35:
					alpiste = new Alpiste(300);
					break;
				case 40 :
					obstaculo = new Obstaculos("cacto")
					break;
				case 65 :
					obstaculo = new Obstaculos("cacto")
					break;
				case 90 :
					obstaculo = new Obstaculos("cacto")
					break;
				case 120 :
					obstaculo = new Obstaculos("cacto");
					plataforma = new Plataformas(240)
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
					obstaculo = new Obstaculos("rocha detonavel");
					break;
				case 250 :
					obstaculo = new Obstaculos("pedra",580);
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
				case 360:
					fxchannel = alarmeboss.play()
					break
				case 400 :
					coyote = new Coyote(1,-70,322);
					break;
				case 450 :
					obstaculo = new Obstaculos("garfo")
					break;
				case 475:
					obstaculo = new Obstaculos("garfo",0,true)
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
					obstaculo = new Obstaculos("fireTrap")
					break;
				case 790:
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
					bgm.mudarMusica("finalizar")
					break
				case 868:
					BO_final = true
					break
			}
		}

		private function colisoes():void
		{
			for (var o:int = 0; o < AR_obstaculos.length; o++)
			{
				if (AR_obstaculos[o].x < 0)
				{
					removeChild(AR_obstaculos[o]);
					AR_obstaculos.splice(o,1);
				}
				if (AR_obstaculos[o] != null && AR_obstaculos[o].BO_projetil && AR_obstaculos[o].x > stage.stageWidth)
				{
					removeChild(AR_obstaculos[o]);
					AR_obstaculos.splice(o,1);
				}
				if (AR_obstaculos[o] != null && papaleguas.hitTestObject(AR_obstaculos[o]) && AR_obstaculos[o].BO_detonado == false)
				{
					morte();
				}
			}
			for (var r:int = 0; r < AR_props.length; r++)
			{
				if (AR_props[r].x < 0)
				{
					removeChild(AR_props[r])
					AR_props.splice(r,1)
				}
			}
			for (var p:int = 0; p < AR_plataformas.length; p++)
			{
				if (AR_plataformas[p].x < 0)
				{
					removeChild(AR_plataformas[p]);
					AR_plataformas.splice(p,1);
				}
			}
			for (var a:int = 0; a < AR_alpiste.length; a++)
			{
				if (AR_alpiste[a].x < 0)
				{
					removeChild(AR_alpiste[a])
					AR_alpiste.splice(a,1)
				}
				if (AR_alpiste[a] != null && papaleguas.hitTestObject(AR_alpiste[a]))
				{
					fxchannel = AR_alpiste[a].somalpiste.play();
					contadorAlpiste++
					removeChild(AR_alpiste[a])
					AR_alpiste.splice(a,1)
				}
			}
		}

		private function morte():void
		{
			papaleguas.desativar_controles()
			BO_reviver = true;
			limparArrays()
			if (contadorFrame >= 350)
			{
				removeChild(coyote)
			}
			contadorFrame = 29;
			contadorAlpiste = 0
			papaleguas.velocidadeY = 0;
			fxchannel.stop(); 
			bgm.mudarMusica("reviver")
			papaleguas.gotoAndStop("reviver");
			meep.play();
		}
		
		private function limparArrays():void
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

		public function Demo():void
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
		
		private function seguirDemo(e:MouseEvent):void
		{
			contadorFrame++
			switch(contadorFrame)
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
		
		private function explodir(e:MouseEvent):void
		{
			pinguim.removeEventListener(MouseEvent.CLICK, explodir)
			pinguim.gotoAndPlay("explodir")
			fxchannel = explosaoPinguim.play()
			TF_teaser.text = "Seu monstro!"
		}
	}
}