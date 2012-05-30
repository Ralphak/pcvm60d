package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * ...
	 * @author ...
	 */
	public class BGM extends MovieClip
	{
		var musica:Sound
		var canal:SoundChannel
		
		var nome:String
		var tempoInicio:Number
		
		public function BGM() 
		{
			musica = new bgm_menu
			canal = musica.play(tempoInicio)
			canal.addEventListener(Event.SOUND_COMPLETE, loop, false, 0, true);
		}
		
		public function mudarMusica(_nome:String, _tempoInicio:Number = 0)
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
		
		public function loop(e:Event):void
		{			
			switch(nome)
			{
				case "reviver":
					canal.stop();
					Main.referenciar().papaleguas.gotoAndPlay(1);
					Main.referenciar().papaleguas.y = 310;
					Main.referenciar().BO_reviver = false;
					Main.referenciar().papaleguas.BO_liberarcontrole = true;
					break
				case "finalizar":
					Main.referenciar().Demo()
					break
				default:
					canal.removeEventListener(Event.SOUND_COMPLETE,loop)
					canal = musica.play(tempoInicio)
					canal.addEventListener(Event.SOUND_COMPLETE, loop, false, 0, true);
					break
			}
		}
	}

}