import 'dart:async';

import 'package:clock_app/src/common/data/data.dart';
import 'package:clock_app/src/common/model/enums.dart';
import 'package:clock_app/src/common/model/menu_info.dart';
import 'package:clock_app/src/common/widgets/clock_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(now);
    var formattedDate = DateFormat('EEE, d MMM').format(now);
    var timezoneString = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if(!timezoneString.startsWith('-')) offsetSign = '+'; 

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF2D2F41),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: menuItems.map((currentMenuInfo) => CustomMenuBotton(currentMenuInfo)).toList(),
            ),
            VerticalDivider(
              color: Colors.white54,
              width: 1,
            ), 
            Expanded(
              child: Consumer<MenuInfo>(
                builder: (BuildContext context, MenuInfo value, Widget child){
                  if(value.menuType != MenuType.clock)  return Container();
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            'Clock',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 64,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: Align(
                            alignment: Alignment.center,
                            child: ClockView(size: MediaQuery.of(context).size.height / 4),
                          )
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Timezone',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.language,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    'UTC ' + offsetSign + timezoneString,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ) 
    );
  }

  Widget CustomMenuBotton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child){
        return FlatButton(
          onPressed: (){
            // var menuInfo = Provider.of<MenuInfo>(context, listen: false);
            var menuInfo = context.read<MenuInfo>();
            menuInfo.updateMenu(currentMenuInfo);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(32), bottomRight: Radius.circular(32)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          color: currentMenuInfo.menuType == value.menuType ? Color(0xFF242634) : Colors.transparent,
          child: Column(
            children: [
              Image.asset(currentMenuInfo.imageSource.toString(), scale: 1.5),
              SizedBox(height: 16),
              Text(
                currentMenuInfo.title.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Avenir',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}