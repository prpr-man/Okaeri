bleno = require('bleno')

var Sound = require('node-mpg123');
var voice = new Sound('voice/kei_voice_017_1.mp3');

bleno.on('stateChange', function(state) {
  if (state === 'poweredOn') {
    bleno.startAdvertising('RaspberryPi',['0000280000001000800000805f9b34fb']);
  } else {
    bleno.stopAdvertising();
  }
});


bleno.on('accept', function (clientAddress){
  voice.play();
});

