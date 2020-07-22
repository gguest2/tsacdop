import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../state/setting_state.dart';
import '../util/extension_helper.dart';
import '../util/general_dialog.dart';

class ThemeSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.s;
    var settings = Provider.of<SettingState>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Theme.of(context).accentColorBrightness,
        systemNavigationBarColor: Theme.of(context).primaryColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).accentColorBrightness,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.settingsAppearance),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Container(
              height: 30.0,
              padding: EdgeInsets.symmetric(horizontal: 70),
              alignment: Alignment.centerLeft,
              child: Text(s.settingsInterface,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Theme.of(context).accentColor)),
            ),
            ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                ListTile(
                  onTap: () => showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black54,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext context, Animation animaiton,
                              Animation secondaryAnimation) =>
                          AnnotatedRegion<SystemUiOverlayStyle>(
                            value: SystemUiOverlayStyle(
                              statusBarIconBrightness: Brightness.light,
                              systemNavigationBarColor:
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Color.fromRGBO(113, 113, 113, 1)
                                      : Color.fromRGBO(15, 15, 15, 1),
                            ),
                            child: AlertDialog(
                              titlePadding: EdgeInsets.only(
                                top: 20,
                                left: 40,
                                right: context.width / 3,
                              ),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              title: Text(s.settingsTheme),
                              content: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: RadioListTile(
                                            title: Text(s.systemDefault),
                                            value: ThemeMode.system,
                                            groupValue: settings.theme,
                                            onChanged: (value) {
                                              settings.setTheme = value;
                                              Navigator.of(context).pop();
                                            }),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: RadioListTile(
                                            title: Text(s.darkMode),
                                            value: ThemeMode.dark,
                                            groupValue: settings.theme,
                                            onChanged: (value) {
                                              settings.setTheme = value;
                                              Navigator.of(context).pop();
                                            }),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: RadioListTile(
                                            title: Text(s.lightMode),
                                            value: ThemeMode.light,
                                            groupValue: settings.theme,
                                            onChanged: (value) {
                                              settings.setTheme = value;
                                              Navigator.of(context).pop();
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                  contentPadding: EdgeInsets.symmetric(horizontal: 80.0),
                  //  leading: Icon(Icons.colorize),
                  title: Text(s.settingsTheme),
                  subtitle: Text(s.systemDefault),
                ),
                Selector<SettingState, bool>(
                  selector: (_, setting) => setting.realDark,
                  builder: (_, data, __) => ListTile(
                    onTap: () => settings.setRealDark = !data,
                    contentPadding: const EdgeInsets.only(
                        left: 80.0, right: 20, bottom: 10, top: 10),
                    //  leading: Icon(Icons.colorize),
                    title: Text(
                      s.settingsRealDark,
                    ),
                    subtitle: Text(s.settingsRealDarkDes),
                    trailing: Transform.scale(
                      scale: 0.9,
                      child: Switch(
                          value: data,
                          onChanged: (boo) async {
                            settings.setRealDark = boo;
                          }),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => generalDialog(
                    context,
                    title: Text.rich(TextSpan(text: s.chooseA, children: [
                      TextSpan(
                          text: s.color,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.accentColor))
                    ])),
                    content: ColorPicker(
                      onColorChanged: (value) =>
                          settings.setAccentColor = value,
                    ),
                  ),
                  contentPadding: EdgeInsets.only(left: 80.0, right: 25),
                  title: Text(s.settingsAccentColor),
                  subtitle: Text(s.settingsAccentColorDes),
                  trailing: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: context.accentColor),
                  ),
                ),
                Divider(height: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ColorPicker extends StatefulWidget {
  final ValueChanged<Color> onColorChanged;
  ColorPicker({Key key, this.onColorChanged}) : super(key: key);
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _index;
  @override
  void initState() {
    super.initState();
    _index = 0;
    _controller = TabController(length: Colors.primaries.length, vsync: this)
      ..addListener(() {
        setState(() => _index = _controller.index);
      });
  }

  Widget _colorCircle(Color color) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          onTap: () => widget.onColorChanged(color),
          child: Container(
            decoration: BoxDecoration(
                border: color == context.accentColor
                    ? Border.all(color: Colors.grey[400], width: 4)
                    : null,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: color),
          ),
        ),
      );

  List<Widget> _accentList(MaterialAccentColor color) => [
        _colorCircle(color.shade100),
        _colorCircle(color.shade200),
        _colorCircle(color.shade400),
        _colorCircle(color.shade700)
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 40,
            color: Theme.of(context).dialogBackgroundColor,
            child: TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              controller: _controller,
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              tabs: Colors.primaries
                  .map<Widget>((color) => Tab(
                        child: Container(
                          height: 20,
                          width: 40,
                          decoration: BoxDecoration(
                              border: Colors.primaries.indexOf(color) == _index
                                  ? Border.all(
                                      color: Colors.grey[400], width: 2)
                                  : null,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: color),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: const ClampingScrollPhysics(),
              key: UniqueKey(),
              controller: _controller,
              children: Colors.primaries
                  .map<Widget>((color) => GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(10),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        children: <Widget>[
                          _colorCircle(color.shade100),
                          _colorCircle(color.shade200),
                          _colorCircle(color.shade300),
                          _colorCircle(color.shade400),
                          _colorCircle(color.shade500),
                          _colorCircle(color.shade600),
                          _colorCircle(color.shade700),
                          _colorCircle(color.shade800),
                          _colorCircle(color.shade900),
                          ...color == Colors.red
                              ? _accentList(Colors.redAccent)
                              : color == Colors.pink
                                  ? _accentList(Colors.pinkAccent)
                                  : color == Colors.deepOrange
                                      ? _accentList(Colors.deepOrangeAccent)
                                      : color == Colors.orange
                                          ? _accentList(Colors.orangeAccent)
                                          : color == Colors.amber
                                              ? _accentList(Colors.amberAccent)
                                              : color == Colors.yellow
                                                  ? _accentList(
                                                      Colors.yellowAccent)
                                                  : color == Colors.lime
                                                      ? _accentList(
                                                          Colors.limeAccent)
                                                      : color ==
                                                              Colors.lightGreen
                                                          ? _accentList(Colors
                                                              .lightGreenAccent)
                                                          : color == Colors.green
                                                              ? _accentList(Colors
                                                                  .greenAccent)
                                                              : color ==
                                                                      Colors
                                                                          .teal
                                                                  ? _accentList(
                                                                      Colors
                                                                          .tealAccent)
                                                                  : color ==
                                                                          Colors
                                                                              .cyan
                                                                      ? _accentList(
                                                                          Colors
                                                                              .cyanAccent)
                                                                      : color ==
                                                                              Colors
                                                                                  .lightBlue
                                                                          ? _accentList(Colors
                                                                              .lightBlueAccent)
                                                                          : color == Colors.blue
                                                                              ? _accentList(Colors.blueAccent)
                                                                              : color == Colors.indigo ? _accentList(Colors.indigoAccent) : color == Colors.purple ? _accentList(Colors.purpleAccent) : color == Colors.deepPurple ? _accentList(Colors.deepPurpleAccent) : []
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
