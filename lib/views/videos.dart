import 'package:flutter/material.dart';
import 'package:list_all_videos/list_all_videos.dart';
import 'package:list_all_videos/model/video_model.dart';
import 'package:list_all_videos/thumbnail/ThumbnailTile.dart';
import 'package:music_player/views/video_player.dart';

import '../const/colors.dart';
import '../const/text_style.dart';

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  ListAllVideos object = ListAllVideos();

  // List<VideoDetails> videos = await object.getAllVideosPath();

  @override
  Widget build(BuildContext context) {
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
          "Videos",
          style: ourStyle(
              size: 18, color: whiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: object.getAllVideosPath(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
                strokeWidth: 1,
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              VideoDetails currentVideo = snapshot.data![index];
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: bgColor,
                  title: Text(
                    currentVideo.videoName,
                    style: ourStyle(size: 15, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    currentVideo.videoSize,
                    style: ourStyle(size: 12, fontWeight: FontWeight.normal),
                  ),
                  leading: ThumbnailTile(
                    thumbnailController: currentVideo.thumbnailController,
                    height: 80,
                    width: 100,
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayerr(path: currentVideo.videoPath),)),
                ),
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
