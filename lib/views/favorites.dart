import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../const/colors.dart';
import '../const/text_style.dart';
import '../controllers/player_controller.dart';
import '../mdels/model_class.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
        title: Text(
          "Favorite Song",
          style: ourStyle(
              size: 18, color: whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Hive.openBox("fav"),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No Favorite Music in the Phone",
                  style: ourStyle(),
                ),
              );
            }
            final hiveBox = Hive.box("fav");
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final helper = hiveBox.getAt(index) as ModelClass;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Obx(
                      () => ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: bgColor,
                        leading:  QueryArtworkWidget(
                          id: helper.id!,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: whiteColor,
                            size: 32,
                          ),
                        ),
                        title: Text(
                          helper.name!,
                          style:
                              ourStyle(size: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          helper.artist ?? "No Artist Name",
                          style:
                              ourStyle(size: 12, fontWeight: FontWeight.normal),
                        ),
                        trailing: controller.playIndex.value == helper.index &&
                                controller.isPlaying.value
                            ? const Icon(
                                Icons.play_arrow,
                                color: whiteColor,
                                size: 26,
                              )
                            : null,
                        onLongPress: () {
                          hiveBox.deleteAt(index);
                          print("Delete Data");
                        },
                        onTap: () {
                          // Get.to(() => Player(
                          //       song: helper,
                          //       index: index,
                          //     ));
                          controller.playSong(helper.uri, helper.index!);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
