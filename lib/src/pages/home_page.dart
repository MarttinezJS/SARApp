import 'package:flutter/material.dart';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:radio/src/helpers/alert_informativa.dart';

import 'package:radio/src/widgets/background_widget.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final audioPlayer = AssetsAudioPlayer();

  bool playing = false;
  bool conectando = false;

  @override
  void initState() {
    super.initState();
    conectando = true;
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.custom
      ..backgroundColor = Colors.transparent
      ..indicatorColor = Color.fromRGBO(255, 190, 36, 1)
      ..textColor = Color.fromRGBO(255, 190, 36, 1)
      ..maskColor = Color.fromRGBO(0, 0, 0, 0.6)
      ..progressColor = Colors.white
      ..indicatorType = EasyLoadingIndicatorType.wave
      ..indicatorSize = 100;
    EasyLoading.show(
      status: 'Conectando...'
    );
    final audio = Audio.liveStream('https://radio30.virtualtronics.com/proxy/sigueadelante?mp=/stream');
    audio.updateMetas(
      image: MetasImage.asset('assets/img/Logo-Sigue-Adelante-Header-1-1-scaled.jpg'),
      title: 'Live',
      artist: 'Sigue Adelante Radio'
    );
    audioPlayer.open(
      audio,
      showNotification: true,
      notificationSettings: NotificationSettings(
        nextEnabled: false,
        prevEnabled: false,
        stopEnabled: false,
        customPlayPauseAction: (player) {
          if ( !conectando ) {
            conectando = true;
            player.playOrPause().then((value) {
              conectando = false;
              playing = !playing;
            });
          }
            
        },
      ),
    ).then(( _ ) {
      EasyLoading.dismiss(animation: true);
      playing = !playing;
      conectando = false;
      setState(() {});
    }).onError((error, stackTrace) {
      EasyLoading.dismiss(animation: false);
      conectando = false;
      mostrarAlerta(context, 'Ups...', 'Ocurrió un error al reproducir, revisa tu coneccion a internet y si el error persiste infórmanos.');
    });
  }
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final amarillo = Theme.of(context).primaryColor;

    return Scaffold(
      body: Stack(
        children: [
          Background( color: amarillo,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only( top: size.height * 0.06),
                child: _titulo()
              ),
              Container(
                margin: EdgeInsets.only( top: size.height * 0.06),
                alignment: Alignment.centerRight,
                child: botonPlay()
              ),
              Container(
                margin: EdgeInsets.only( left: size.width * 0.03, bottom: size.height * 0.02),
                alignment: Alignment.centerLeft,
                child: footer( amarillo )
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _titulo(){
    return Column(
      children: [
        Image(
          width: 150,
          height: 150,
          image: AssetImage('assets/img/Logo-Sigue-Adelante-Header-1-1-scaled.jpg'),
        ),
        Text('Sigue Adelante Radio',
          style: TextStyle( 
            fontFamily: 'CormorantUnicase',
            fontWeight: FontWeight.bold,
            fontSize: 35,
            color: Colors.black
          ),
        ),
      ],
    );
  }

  Widget botonPlay(){
    return IconButton(
      iconSize: 200,
      color: Colors.black,
      icon: Icon( playing ? Icons.pause : Icons.play_arrow ),
      onPressed: conectando ? null : () {
        EasyLoading.show(
          status: 'Conectando...'
        );
        conectando = true;
        audioPlayer.playOrPause().then(( _ ) {
          playing = !playing;
          setState(() {});
          EasyLoading.dismiss(animation: true);
          
          conectando = false;
        }).onError((error, stackTrace) {
          EasyLoading.dismiss(animation: false);
          conectando = false;
          mostrarAlerta(context, 'Ups...', 'Ocurrió un error al reproducir, revisa tu coneccion a internet y si el error persiste infórmanos.');
        });
      },
    );
  }

  Widget footer(Color amarillo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dirección:', style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: amarillo ),),
            Text('Teléfonos:', style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: amarillo),),
            Text('Email:', style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: amarillo),),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cr 23 # 6D-22 Valledupar, Colombia', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white),),
            Text('(+57)310 842 8083', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white),),
            Text('fidel.barros@sigueadelanteradio.com:', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white),),
          ],
        ),
      ],
    );
  }
}