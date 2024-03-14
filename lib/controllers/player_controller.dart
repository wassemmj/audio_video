import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer() ;

  var playIndex = 0.obs ;
  var isPlaying = false.obs ;

  var duration = ''.obs ;
  var position = ''.obs ;

  var max = 0.0.obs ;
  var value = 0.0.obs ;

  var isShuffle = 0.obs ;
  var sort = 'A to Z'.obs ;

  @override
  void onInit() {
    super.onInit();
    checkPermission() ;
  }

  updatePosition() {
    audioPlayer.durationStream.listen((event) {
      duration.value = event.toString().split(".")[0] ;
      max.value = event!.inSeconds.toDouble() ;
    });
    audioPlayer.positionStream.listen((event) {
      position.value = event.toString().split(".")[0] ;
      value.value = event.inSeconds.toDouble() ;
    });
  }

  changeDurationToSecond(seconds) {
    var duration = Duration(seconds: seconds) ;
    audioPlayer.seek(duration) ;
  }

  checkPermission() async {
    PermissionStatus per;
    do {
      per = await Permission.storage.request();
    } while (!per.isGranted);
  }

  // checkPermission() async {
  //   var per = await Permission.storage.request() ;
  //   if (!per.isGranted) {
  //     checkPermission();
  //   }
  // }

  playSong(String? url , int index) {
    playIndex.value = index ;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url!)));
      audioPlayer.play();
      isPlaying(true);
      updatePosition() ;

    } on Exception catch (e) {
      print(e.toString()) ;
    }
  }
}