import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import '../process/thumbnail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    //Calling Storage Permission Method
    getStoragePermission();
    super.initState();
  }

  // Request Storage Permission
  Future getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      // Fetches all Assets
      _fetchAssets();
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      return const Scaffold(
        body: Text('Storage Access Denied'),
      );
    }
  }

  List<AssetEntity> assets = [];

  _fetchAssets() async {
    //contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    //fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );

    // Update the state and notify UI
    setState(() => assets = recentAssets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.account_circle,
          size: 30,
        ),
        actions: const [
          Icon(
            Icons.favorite,
            size: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.search,
              size: 30,
            ),
          ),
          Icon(
            Icons.more_vert,
            size: 30,
          ),
        ],
        elevation: 30,
        toolbarHeight: 60,
        title: const Text('Photos'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.purple, Colors.black87],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          // A grid view with 3 items per row
          crossAxisCount: 3,
        ),
        itemCount: assets.length,
        itemBuilder: (context, index) {
          return AssetThumbnail(asset: assets[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value) {},
        items: const [
          BottomNavigationBarItem(
            label: ' ',
            icon: Icon(
              Icons.album,
              color: Colors.purple,
            ),
          ),
          BottomNavigationBarItem(
            label: ' ',
            icon: Icon(
              Icons.delete,
              color: Colors.purple,
            ),
          ),
          BottomNavigationBarItem(
            label: ' ',
            icon: Icon(
              Icons.add_rounded,
              color: Colors.purple,
            ),
          ),
          BottomNavigationBarItem(
            label: ' ',
            icon: Icon(
              Icons.library_books,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}
