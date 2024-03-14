import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/const/colors.dart';
import 'package:music_player/const/text_style.dart';
import 'package:music_player/controllers/player_controller.dart';
import 'package:music_player/views/favorites.dart';
import 'package:music_player/views/player.dart';
import 'package:music_player/views/search_delegate.dart';
import 'package:music_player/views/videos.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context, delegate: MySearchDelegate());
            },
            icon: const Icon(
              Icons.search,
              color: whiteColor,
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.sort_rounded,
              color: whiteColor,
            ),
          ),
        ),
        title: Text(
          "Beats",
          style: ourStyle(
              size: 18, color: whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
          () {
            if (controller.sort.value == '') {}
            return SingleChildScrollView(
          child: FutureBuilder<List<SongModel>>(
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
              List<SongModel> sort = snapshot.data as List<SongModel>;
              sort.sort((SongModel a, SongModel b) =>
                  b.dateAdded!.compareTo(a.dateAdded!));
              if (controller.sort.value == 'First Added') {
                sort.sort((SongModel a, SongModel b) =>
                    a.dateAdded!.compareTo(b.dateAdded!));
              } else if (controller.sort.value == 'Last added')  {
                sort.sort((SongModel a, SongModel b) =>
                    b.dateAdded!.compareTo(a.dateAdded!));
              } else if (controller.sort.value == 'A to Z') {
                sort.sort((SongModel a, SongModel b) =>
                    a.displayNameWOExt.compareTo(b.displayNameWOExt));
              } else if (controller.sort.value == 'Z to A'){
                sort.sort((SongModel a, SongModel b) =>
                    b.displayNameWOExt.compareTo(a.displayNameWOExt));
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Obx(
                      () {
                        if (controller.isShuffle.value == 0) {}
                        return InkWell(
                          onTap: () {
                            controller.isShuffle.value = 1;
                            final random = Random();
                            var index = (random.nextInt(snapshot.data!.length));
                            Get.to(() => Player(
                                  song: snapshot.data!,
                                  index: index,
                                ));
                            controller.playSong(snapshot.data![index].uri, index);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.shuffle,
                                    color: Colors.deepPurple,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Shuffle Songs",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                            color: bgDarkColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25))),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  controller.sort.value =  'First Added';
                                                },
                                                child: const Text(
                                                  'First Added',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            const Divider(
                                              color: bgColor,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  controller.sort.value =  'Last added';
                                                },
                                                child: const Text(
                                                  'Last added',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            const Divider(
                                              color: bgColor,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  controller.sort.value =  'A to Z';
                                                },
                                                child: const Text(
                                                  'A to Z',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            const Divider(
                                              color: bgColor,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  controller.sort.value =  'Z to A';
                                                },
                                                child: const Text(
                                                  'Z to A',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.sort,
                                  color: Colors.deepPurple,
                                  size: 25,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
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
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                  color: whiteColor,
                                  size: 32,
                                ),
                              ),
                              title: Text(
                                snapshot.data![index].displayNameWOExt,
                                style: ourStyle(
                                    size: 15, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                snapshot.data![index].artist ?? "No Artist Name",
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
                                      song: snapshot.data!,
                                      index: index,
                                    ));
                                controller.playSong(
                                    snapshot.data![index].uri, index);
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
          ),
        );
          },
      ),
      drawer: Drawer(
        backgroundColor: bgDarkColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: DrawerHeader(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                    ),
                    child: Center(
                      child: Text(
                        "Music is Life",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: bgDarkColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Favorites(),
                    ));
                  },
                  child: const Text(
                    "Favorites",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Divider(
                  color: Colors.deepPurple,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Videos(),
                    ));
                  },
                  child: const Text(
                    "Videos",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
