// Classe que controla a música de fundo do jogo

package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class BGM extends MovieClip
	{
		var musica:Sound	// Variável com informações do arquivo de música
		var canal:SoundChannel	// Canal que controla a música do jogo
		
		var nome:String	// Nome da música
		var tempoInicio:Number	// O tempo em que a musíca vai ser reproduzida, em milissegundos
		
		public function BGM()	// Construtora da classe. Por padrão, ela tocará a música do menu principal primeiro
		{
			musica = new bgm_menu
			canal = musica.play(tempoInicio)
			canal.addEventListener(Event.SOUND_COMPLETE, loop, false, 0, true);
		}
		
		public function mudarMusica(_nome:String, _tempoInicio:Number = 0)	// Comando para mudar a música de fundo do jogo
		{
			canal.removeEventListener(Event.SOUND_COMPLETE,loop)
			canal.stop()
			nome = _nome
			tempoInicio = _tempoInicio
			
			switch(nome)
			{
				case "nivel 1" :
					musica = new bgm1
					break
				case "reviver" :
					musica = new som_reverter
					break
				case "finalizar" :
					musica = new rr_tonguemeeprun
					break
				case "demo":
					musica = new tema_rr
					break
			}
			
			canal = musica.play(tempoInicio)
			canal.addEventListener(Event.SOUND_COMPLETE, loop, false, 0, true);
		}
		
		public function loop(e:Event):void;	// Determina o que deve acontecer quando a música terminar de tocar
		{			
			switch(nome)
			{
				case "reviver":	// Sai da cena de reviver e reinicia o jogo
					canal.stop();
					Main.referenciar().papaleguas.gotoAndPlay(1);
					Main.referenciar().papaleguas.y = 310;
					Main.referenciar().BO_reviver = false;
					Main.referenciar().papaleguas.BO_liberarcontrole = true;
					break
				case "finalizar":	// Termina a fase e abre a interface de teasers
					Main.referenciar().Demo()
					break
				default:	// Faz com que a música seja repetida indefinidamente
					canal.removeEventListener(Event.SOUND_COMPLETE,loop)
					canal = musica.play(tempoInicio)
					canal.addEventListener(Event.SOUND_COMPLETE, loop, false, 0, true);
					break
			}
		}
	}

}