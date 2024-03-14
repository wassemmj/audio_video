import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:music_player/const/colors.dart';
import 'package:music_player/const/text_style.dart';
import 'package:music_player/controllers/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../mdels/model_class.dart';

class Player extends StatefulWidget {
  const Player({super.key, required this.song, required this.index});

  final List<SongModel> song;

  final int index;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  bool fav = false ;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Obx(
              () {
                return Expanded(
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 300,
                    width: 300,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: QueryArtworkWidget(
                      id: widget.song[controller.playIndex.value].id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        size: 48,
                        color: whiteColor,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: whiteColor,
                ),
                child: Column(
                  children: [
                    Text(
                      widget.song[controller.playIndex.value].displayNameWOExt,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: ourStyle(
                        size: 24,
                        color: bgDarkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.song[controller.playIndex.value].artist!,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: ourStyle(
                        size: 20,
                        color: bgDarkColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          if (controller.position.value ==
                              controller.duration.value) {
                            // controller.audioPlayer.stop();
                            // controller.isPlaying(false);
                            controller.playSong(
                                widget.song[controller.playIndex.value + 1].uri,
                                controller.playIndex.value + 1);
                          }
                        });
                        return Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                            Expanded(
                              child: Slider(
                                value: controller.value.value,
                                thumbColor: sliderColor,
                                activeColor: sliderColor,
                                inactiveColor: bgColor,
                                min: const Duration(seconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                max: controller.max.value,
                                onChanged: (value) {
                                  if (value == controller.max.value) {
                                    controller.playSong(
                                        widget.song[controller.playIndex.value + 1]
                                            .uri,
                                        controller.playIndex.value + 1);
                                  }
                                  controller
                                      .changeDurationToSecond(value.toInt());
                                  controller.value.value = value;
                                },
                              ),
                            ),
                            Text(
                              controller.duration.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(
                          () => IconButton(
                            onPressed: () {
                              controller.isShuffle.value =
                                  controller.isShuffle.value == 1 ? 0 : 1;
                            },
                            icon: Icon(
                              controller.isShuffle.value == 1
                                  ? Icons.shuffle
                                  : Icons.loop,
                              size: 40,
                              color: bgDarkColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (controller.isShuffle.value == 1) {
                              final random = Random();
                              var index =
                                  (random.nextInt(controller.playIndex.value));
                              controller.playSong(widget.song[index].uri, index);
                            } else {
                              controller.playSong(
                                  widget.song[controller.playIndex.value - 1].uri,
                                  controller.playIndex.value - 1);
                            }
                          },
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            size: 40,
                            color: bgDarkColor,
                          ),
                        ),
                        Obx(
                          () => CircleAvatar(
                            radius: 35,
                            backgroundColor: bgDarkColor,
                            child: Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                onPressed: () {
                                  if (controller.isPlaying.value) {
                                    controller.audioPlayer.pause();
                                    controller.isPlaying(false);
                                  } else {
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                  }
                                  if (controller.value.value ==
                                      controller.max.value) {
                                    controller.playSong(
                                        widget.song[controller.playIndex.value].uri,
                                        controller.playIndex.value);
                                  }
                                },
                                icon: Icon(
                                  controller.isPlaying.value
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (controller.isShuffle.value == 1) {
                              final random = Random();

                              var index = (controller.playIndex.value +
                                  random.nextInt(widget.song.length -
                                      controller.playIndex.value +
                                      1));
                              controller.playSong(widget.song[index].uri, index);
                            }
                            controller.playSong(
                                widget.song[controller.playIndex.value + 1].uri,
                                controller.playIndex.value + 1);
                          },
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            size: 40,
                            color: bgDarkColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (!fav) {
                              var model = ModelClass(
                                uri: widget.song[controller.playIndex.value].uri,
                                artist: widget.song[controller.playIndex.value].artist,
                                name: widget.song[controller.playIndex.value]
                                    .displayNameWOExt,
                                duration: widget.song[controller.playIndex.value].duration!,
                                index: controller.playIndex.value,
                                id: widget.song[controller.playIndex.value].id,
                              );
                              var tt = Hive.box("fav");
                              await tt.add(model);
                              print("create data");
                            } else {
                              final hiveBox = Hive.box("fav");
                              for (int i = 0 ; i < hiveBox.length ; i++) {
                                var helper = hiveBox.getAt(i) as ModelClass;
                                if (helper.index == controller.playIndex.value) {
                                  hiveBox.deleteAt(i);
                                }
                              }
                              print("Delete Data");
                            }
                            setState(() {
                              fav = !fav ;
                            });
                          },
                          icon: Icon(
                            fav ? Icons.favorite : Icons.favorite_border,
                            size: 40,
                            color: bgDarkColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
