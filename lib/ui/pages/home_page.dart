import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:note_app_flutter/core/controllers/note_controller.dart';
import 'package:note_app_flutter/ui/pages/add_note_page.dart';
import 'package:note_app_flutter/ui/styles/colors.dart';
import 'package:note_app_flutter/ui/styles/text_styles.dart';
import 'package:note_app_flutter/ui/widgets/icon_button.dart';
import 'package:note_app_flutter/ui/widgets/note_tile.dart';

class HomePage extends StatelessWidget {
  final _notesController = Get.put(NoteController());

  // final _tileCounts = [
  //   StaggeredTile.count(2, 2),
  //   StaggeredTile.count(2, 2),
  //   StaggeredTile.count(4, 2),
  //   StaggeredTile.count(2, 3),
  //   StaggeredTile.count(2, 2),
  //   StaggeredTile.count(2, 3),
  //   StaggeredTile.count(2, 2),
  // ];

  final _tileCounts = [
    GridTile(2, 2),
    GridTile(2, 2),
    GridTile(4, 2),
    GridTile(2, 3),
    GridTile(2, 2),
    GridTile(2, 3),
    GridTile(2, 2),
  ];
  final _tileTypes = [
    TileType.Square,
    TileType.Square,
    TileType.HorRect,
    TileType.VerRect,
    TileType.Square,
    TileType.VerRect,
    TileType.Square,
  ];

  static const platform = MethodChannel('samples.flutter.dev/battery');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FloatingActionButton(
          backgroundColor: Color(0xFF3B3B3B),
          onPressed: () {
            Get.to(
              AddNotePage(),
              transition: Transition.downToUp,
            );
          },
          child: Icon(Icons.add),
        ),
      ),
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            const SizedBox(
              height: 16,
            ),
            _body(),
          ],
        ),
      ),
    );
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel = "Unknown battery level.";
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    // _notesController.setBatteryValue(batteryLevel );
    Get.snackbar(
      "Info current battery state ",
      "${batteryLevel}",
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
    );
  }

  _appBar() {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Notes",
            style: titleTextStyle.copyWith(fontSize: 32),
          ),
          Row(
            children: [
              MyIconButton(
                onTap: () {},
                icon: Icons.search,
              ),
              SizedBox(width: 10,),
              MyIconButton(
                onTap: () async {
                  await _getBatteryLevel();
                },
                icon: Icons.battery_alert,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _body() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        print("######## " + _notesController.noteList.length.toString());

        if (_notesController.noteList.isNotEmpty) {
          return SingleChildScrollView(
            child: StaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: [
                ..._notesController.noteList.mapIndexed((index, tile) {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: _tileCounts[index % 7].crossAxisCount,
                    mainAxisCellCount: _tileCounts[index % 7].mainAxisCount,
                    child: NoteTile(
                      tileType: _tileTypes[index % 7],
                      note: _notesController.noteList[index],
                    ),
                  );
                }),
              ],
            ),
          );

          //   return StaggeredGrid.count(
          //       crossAxisCount: 4,
          //       mainAxisSpacing: 8,
          //       crossAxisSpacing: 8,
          //       // itemCount: _notesController.noteList.length,
          //       // itemBuilder: (context, index) {
          //       //   return NoteTile(
          //       //     tileType: _tileTypes[index % 7],
          //       //     note: _notesController.noteList[index],
          //       //   );
          //       // },
          //       children: [
          //         for(int index =0; index> _notesController.noteList.length;index++)
          //           NoteTile(
          //             tileType: _tileTypes[index % 7],
          //             note: _notesController.noteList[index],
          //           )
          //       ],
          //       // staggeredTileBuilder: (int index) => _tileCounts[index % 7]
          // );

          // return StaggeredGridView.count(
          //   crossAxisCount: 4,
          //   staggeredTiles: _staggeredTiles,
          //   mainAxisSpacing: 12,
          //   crossAxisSpacing: 12,
          //   children: _notesController.noteList
          //       .map((n) => NoteTile(
          //             note: n,
          //           ))
          //       .toList(),
          // );

          // ListView.builder(
          //     itemCount: _notesController.noteList.length,
          //     itemBuilder: (context, index) {
          //       return NoteTile(
          //         note: _notesController.noteList[index],
          //       );
          //     });

        } else {
          return Center(
            child: Text("Empty", style: titleTextStyle),
          );
        }
      }),
    ));
  }
}

class GridTile {
  const GridTile(this.crossAxisCount, this.mainAxisCount);

  final int crossAxisCount;
  final int mainAxisCount;
}
