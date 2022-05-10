import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Model/Room.dart';
import '../Model/Res.dart';
import '../Services/Services_Room.dart';
import '../Services/Services_Res.dart';
import 'Restaurant_info.dart';
import 'Room_info.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late List<Room> _room = [];
  late List<Res> _res = [];

  late Icon appBarIcon;
  int currentPageIndex = 0;
  bool isCreateRoom = false;

  @override
  void initState() {
    super.initState();

    Services_Room.getRooms().then((Room1) {
      setState(() {
        _room = Room1;
      });
    });
    Services_Res.getRests().then((Res1) {
      setState(() {
        _res = Res1;
      });
    });
  }

  PreferredSizeWidget appbarWidget() {
    String currentTitle = "";
    switch (currentPageIndex) {
      case 0:
        return AppBar(
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (isCreateRoom) {
                      print("방 목록으로 돌아가기");
                      setState(() {
                        isCreateRoom = false;
                      });
                    } else {
                      print("위치 설정");
                    }
                  },
                  icon: isCreateRoom
                      ? Icon(Icons.arrow_back)
                      : Icon(Icons.room, color: Colors.deepOrange)),
              Text("현재 위치", style: TextStyle(color: Colors.black))
            ],
          ),
          elevation: 1,
        );
      case 1:
        currentTitle = "찜 목록";
        break;
      case 3:
        currentTitle = "주문 내역";
        break;
      case 4:
        currentTitle = "마이 프로필";
        break;
    }
    return AppBar(
      title: Center(
        child: Text(currentTitle),
      ),
      elevation: 1,
    );
  }

  Widget drawerWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(),
    );
  }

  Widget roomList(BuildContext context) {
    if (_room.isEmpty) {
      return Center(child: Text("현재 주변에 방이 없습니다.."));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "내 근처 모집 중인 먹친방",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 1,
            color: Colors.deepOrange,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _room.length,
              itemBuilder: (context, index) {
                Room room = _room[index];
                return ListTile(
                  title: Row(children: [
                    SizedBox(
                      width: 300,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.roomName.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 5),
                            Text(
                              room.roomInfo.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                room.hostUserId.toString(),
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 22,
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              constraints: BoxConstraints(),
                              onPressed: () {
                                print("찜하기");
                              },
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.deepOrange,
                              ),
                              iconSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 63,
                            child: IconButton(
                                padding: const EdgeInsets.all(0),
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  print("위치보기");
                                },
                                icon: Icon(
                                  Icons.map_outlined,
                                  color: Colors.deepOrange,
                                ),
                                iconSize: 60),
                          ),
                        ],
                      ),
                    )
                  ]),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(room.roomExpireTime.toString(),
                          style: TextStyle(fontSize: 16)),
                      SizedBox(width: 30),
                      Text(room.roomOrderPrice.toString(),
                          style: TextStyle(fontSize: 16)),
                      SizedBox(width: 30),
                      Text(room.roomOrderPrice.toString(),
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  onTap: () {
                    print("참여하기");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: Text("<" +
                              room.roomInfo.toString() +
                              "> 방에 참여하시겠습니까?"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                "취소",
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                                child: const Text(
                                  "확인",
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Services_Room.postRoom(
                                      room.roomId.toString());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Room_info(room: room),
                                      ));
                                })
                          ],
                        );
                      },
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext _context, int index) {
                return Container(height: 1, color: Colors.deepOrange);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget resList(BuildContext context) {
    return ListView.separated(
      itemCount: _res.length,
      itemBuilder: (context, index) {
        Res res = _res[index];
        return ListTile(
          title: Row(children: [
            Image.asset(
              "assets/images/lotteria.jpg",
              width: 110,
              height: 110,
            ),
            Container(
              width: 190,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    res.resName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    "최소 주문 금액 : " + res.resMinOrderPrice.toString() + "원",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "배달 요금 : " + "" + "원",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 22,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () {
                        print("찜하기");
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.deepOrange,
                      ),
                      iconSize: 25,
                    ),
                  ),
                  Container(
                    height: 63,
                    child: IconButton(
                        padding: const EdgeInsets.all(0),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          print("위치보기");
                        },
                        icon: Icon(
                          Icons.map_outlined,
                          color: Colors.deepOrange,
                        ),
                        iconSize: 60),
                  ),
                ],
              ),
            )
          ]),
          onTap: () {
            Services_Res.postRest(res.resName.toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Restaurant_info(res: res),
                ));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 1, color: Colors.grey);
      },
    );
  }

  Widget bodyWidget(BuildContext context) {
    String contents = "";
    switch (currentPageIndex) {
      case 0:
        return isCreateRoom ? resList(context) : roomList(context);
      case 1:
        contents = "찜 목록";
        break;
      case 2:
        contents = "검색 화면";
        break;
      case 3:
        contents = "주문 내역";
        break;
      case 4:
        contents = "프로필 화면";
        break;
    }
    return Center(
        child: Text(
      contents,
    ));
  }

  FloatingActionButton floatingActionButtonWidget() {
    return FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          print("방 만들기");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: const Text("직접 방을 만드시겠습니까?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "취소",
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                      child: const Text(
                        "확인",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          isCreateRoom = true;
                        });
                      })
                ],
              );
            },
          );
        });
  }

  Widget bottomNavigationBarWidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        print(index);
        setState(() {
          currentPageIndex = index;
        });
      },
      currentIndex: currentPageIndex,
      iconSize: 30,
      elevation: 10,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "찜 목록"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "검색"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "주문 내역"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "프로필")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    if (currentPageIndex == 0) {
      if (!isCreateRoom) {
        return Scaffold(
            appBar: appbarWidget(),
            endDrawer: drawerWidget(context),
            body: bodyWidget(context),
            floatingActionButton: floatingActionButtonWidget(),
            bottomNavigationBar: bottomNavigationBarWidget());
      } else {
        return Scaffold(
          appBar: appbarWidget(),
          endDrawer: drawerWidget(context),
          body: bodyWidget(context),
          bottomNavigationBar: bottomNavigationBarWidget(),
        );
      }
    } else if (currentPageIndex == 2) {
      return Scaffold(
        body: bodyWidget(context),
        bottomNavigationBar: bottomNavigationBarWidget(),
      );
    } else {
      return Scaffold(
          appBar: appbarWidget(),
          body: bodyWidget(context),
          bottomNavigationBar: bottomNavigationBarWidget());
    }
  }
}
