import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../const/colors.dart';
import '../const/text_style.dart';
import '../controllers/player_controller.dart';

class Result extends StatefulWidget {
  const Result({Key? key, required this.query}) : super(key: key);

  final String query;

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  List li = [];
  var m = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return FutureBuilder<List<SongModel>>(
      future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No Music in the Phone",
              style: ourStyle(),
            ),
          );
        }
        List<SongModel> sort = (snapshot.data as List<SongModel>)
            .where((element) => element.displayNameWOExt.contains(widget.query) || element.artist!.contains(widget.query))
            .toList();
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sort.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Obx(
                          () => ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: bgColor,
                        leading: QueryArtworkWidget(
                          id: sort[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: whiteColor,
                            size: 32,
                          ),
                        ),
                        title: Text(
                          sort[index].displayNameWOExt,
                          style: ourStyle(
                              size: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          sort[index].artist ??
                              "No Artist Name",
                          style: ourStyle(
                              size: 12, fontWeight: FontWeight.normal),
                        ),
                        trailing: controller.playIndex.value == index &&
                            controller.isPlaying.value
                            ? const Icon(
                          Icons.play_arrow,
                          color: whiteColor,
                          size: 26,
                        )
                            : null,
                        onTap: () {
                          Get.to(() => Player(
                            song: sort,
                            index: index,
                          ));
                          controller.playSong(
                              sort[index].uri, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/*
Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Obx(
        () => ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: bgColor,
          leading: QueryArtworkWidget(
            id: widget.query.id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(
              Icons.music_note,
              color: whiteColor,
              size: 32,
            ),
          ),
          title: Text(
            widget.query.displayNameWOExt,
            style: ourStyle(size: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.query.artist ?? "No Artist Name",
            style: ourStyle(size: 12, fontWeight: FontWeight.normal),
          ),
          trailing:
              controller.playIndex.value == widget.index && controller.isPlaying.value
                  ? const Icon(
                      Icons.play_arrow,
                      color: whiteColor,
                      size: 26,
                    )
                  : null,
          onTap: () {
            // Get.to(() => Player(
            //       song: widget.query!,
            //       index: index,
            //     ));
            controller.playSong(widget.query.uri, widget.index);
          },
        ),
      ),
    )
 */
