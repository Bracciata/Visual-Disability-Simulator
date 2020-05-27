import 'package:abled/tabs/browser.dart';
import 'package:flutter/material.dart';
import 'colorBlindnessFilters.dart';
import 'tabs/browser.dart';
import 'tabs/camera.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abled',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Abled'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List colorFilters = new List();
  @override
  void initState() {
    super.initState();
    colorFilters = getColorFilters();
    controller = TabController(length: 2, vsync: this);
  }

  TabController controller;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          Column(children: [populateColorBlindness(), populateComingSoon()])
        ],
      )),
      body: ColorFiltered(
        colorFilter: colorFilters[group].colorFilter,
        child: TabBarView(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: [BrowserTab(), CamTab()],
          controller: controller,
        ),
      ),
      bottomNavigationBar: Material(
        // set the color of the bottom navigation bar
        color: Colors.pink,
        // set the tab bar as the child of bottom navigation bar
        child: TabBar(
          tabs: <Tab>[
            Tab(
              // set icon to the tab
              icon: Icon(Icons.web),
            ),
            Tab(
              icon: Icon(Icons.camera),
            ),
          ],
          // setup the controller
          controller: controller,
        ),
      ),
    );
  }

  List disabilityList = [true]; // Default open color blindness
  int group = 0;
  Widget populateColorBlindness() {
    List<Widget> colorFilterWidgets = new List();
    for (int i = 0; i < colorFilters.length; i++) {
      colorFilterWidgets.add(RadioListTile(
          title: new Text(colorFilters[i].name),
          value: i,
          groupValue: group,
          onChanged: (radioSeleced) {
            setState(() {
              group = radioSeleced;
            });
          }));
    }
    return ExpansionPanelList(
        expansionCallback: (int item, bool status) {
          setState(() {
            print(item);
            setState(() {
              for (var i = 0; i < disabilityList.length; i++) {
                if (i != item) {
                  disabilityList[i] = false;
                } else {
                  disabilityList[item] = !disabilityList[item];
                }
              }
            });
          });
        },
        children: [
          ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Color Blindness',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                );
              },
              body: Column(children: colorFilterWidgets),
              isExpanded: disabilityList[0])
        ]);
  }

  Widget populateComingSoon() {
    return Container();
  }

  List getColorFilters() {
    List filters = new List();
    filters.add(new ColorBlindnessFilters('Normal Vision', <double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]));
    filters.add(new ColorBlindnessFilters('protanopia', <double>[
      .56667,
      .43333,
      0,
      0,
      0,
      .55833,
      .44167,
      0,
      0,
      0,
      0,
      .24167,
      .75833,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]));
    filters.add(new ColorBlindnessFilters('protanomaly', <double>[
      .81667,
      .18333,
      0,
      0,
      0,
      .33333,
      .66667,
      0,
      0,
      0,
      0,
      .125,
      .875,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]));
    filters.add(new ColorBlindnessFilters('deuteranopia', <double>[
      .625,
      .375,
      0,
      0,
      0,
      .7,
      .3,
      0,
      0,
      0,
      0,
      .3,
      .7,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]));
    filters.add(new ColorBlindnessFilters('deuteranomaly', <double>[
      .8,
      .2,
      0,
      0,
      0,
      .25833,
      .74167,
      0,
      0,
      0,
      0,
      .14167,
      .85833,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]));
    filters.add(new ColorBlindnessFilters('tritanopia', <double>[
      .95,
      .5,
      0,
      0,
      0,
      0,
      .43333,
      .56667,
      0,
      0,
      0,
      .475,
      .525,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]));
    filters.add(new ColorBlindnessFilters('tritanomaly', <double>[
      .96667,
      .03333,
      0,
      0,
      0,
      0,
      .73333,
      .26667,
      0,
      0,
      0,
      .18333,
      .81667,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]));
    filters.add(new ColorBlindnessFilters('achromatopsia', <double>[
      .299,
      .587,
      .114,
      0,
      0,
      .299,
      .587,
      .114,
      0,
      0,
      .299,
      .587,
      .114,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]));
    filters.add(new ColorBlindnessFilters('achromatomaly', <double>[
      .618,
      .32,
      .062,
      0,
      0,
      .163,
      .775,
      .062,
      0,
      0,
      .163,
      .32,
      .516,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]));
    return filters;
  }
}
