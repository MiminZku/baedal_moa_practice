import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Model/Res.dart';

class Restaurant_info extends StatelessWidget {
  late final Res res;

  Restaurant_info({required this.res});

  FloatingActionButton floatingActionButtonWidget() {
    return FloatingActionButton(
        child:
            const Icon(Icons.shopping_cart, color: Colors.deepOrange, size: 30),
        backgroundColor: Colors.white,
        shape:
            StadiumBorder(side: BorderSide(color: Colors.deepOrange, width: 4)),
        onPressed: () {});
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            res.resName.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        floatingActionButton: floatingActionButtonWidget(),
        body: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              height: 1,
              color: Colors.grey,
            );
          },
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Column(
                children: [
                  Container(
                    child: Image.asset(
                      "assets/images/lotteria.jpg",
                      width: deviceWidth,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("최소 주문",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(res.resMinOrderPrice.toString())
                                ],
                              ),
                              Row(
                                children: [
                                  Text("배달 요금",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("" + " ~ " + "" + "원")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("가게 위치",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(res.resLocation.toString())
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite_outline,
                                  size: 40,
                                  color: Colors.deepOrange,
                                )))
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return ListTile(
                  title: Row(children: [
                Image.asset("assets/images/lotteria2.png", width: 100),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [Text("메뉴 이름"), Text("메뉴 가격")],
                  ),
                ),
              ]));
            }
          },
        ));
  }
}
