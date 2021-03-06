library chronosal;

import "dart:html" as HTML;
import "dart:typed_data";
import "dart:web_audio";

// http://news.dartlang.org/2012/02/web-audio-api-and-dart.html

class ChronosAL
{
  AudioContext context;
  GainNode gainNode;
  Map<String, AudioBuffer> sounds = new Map<String, AudioBuffer>(); 

  ChronosAL( [double volume=0.25]) {
    context = new AudioContext();
    gainNode = context.createGain();
    gainNode.gain.value = volume;
    gainNode.connectNode(context.destination);
  }
  
  // "sounds/laser.wav"
  void loadSound( String url, String alias)
  {
    HTML.HttpRequest hr = new HTML.HttpRequest();
    hr.responseType = "arraybuffer";
    hr.open("GET", url);
    hr.onLoadEnd.listen( (e) {
      
      ByteBuffer audioData = hr.response as ByteBuffer;
      context.decodeAudioData(audioData).then( (AudioBuffer audioBuffer) {
        sounds[alias] = audioBuffer;        
      });
            
      //ByteBuffer bb =ist u = new Uint8List.view(bb);
    });
    hr.send('');
    
  }
  
  void playSound( String alias)
  {
    if( sounds[alias] == null)
      return;
    AudioBufferSourceNode source = context.createBufferSource();
    source.buffer = sounds[alias];
    source.connectNode(gainNode);
    source.start(0);
  }
  
}
