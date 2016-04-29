# Okaeri
帰宅したらプロ生ちゃんが「おかえり〜」って出迎えてくれる""最THE高""なアプリ

## Equipment
- iOS端末
- RasPi的サムシング

## Preparation
### iOS
BluetoothとGPSを起動しておく

### RasPi
RasPiに[Bluetoothドングル](http://www.planex.co.jp/products/bt-micro4/)と，スピーカをつなぐ．  

各種ライブラリをインストール．
```
$ sudo apt-get update
$ sudo apt-get install libglib2.0-dev libdbus-1-dev libudev-dev libical-dev libreadline6-dev
```

BlueZインストール．
```
$ wget http://www.kernel.org/pub/linux/bluetooth/bluez-5.39.tar.xz
$ tar xvJf bluez-5.39.tar.xz
$ cd bluez-5.39
$ ./configure --disable-systemd --enable-library
$ make
$ make install
```

Bluetooth起動．
```
sudo hciconfig hci0 up
```
hciconfigしてRUNNINGとなっている事を確認．

---
nodebrewでnodeをインストール．
```
$ curl -L git.io/nodebrew | perl - setup
$ echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> ~/.bashrc
$ source ~/.bashrc
$ nodebrew install-binary 0.10.28
$ nodebrew use 0.10.28
```
---
スクリプト起動．
```
$ git clone https://github.com/prpr-man/Okaeri
$ cd Okaeri/Node.js
$ npm install
$ node sender.js
```
  
ずっと起動させたいときはforeverを使う．
```
npm install forever -g
forever start sender.js
```

## Usage
iOSアプリを起動させてRasPiに近づけば「おかえり〜」と言ってくれる．  
「ここらへんで言って欲しい」ぼたんを押せば，自由に範囲を変えることができる．
## License
This software is released under the MIT License, see LICENSE
