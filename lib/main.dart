import 'package:abled/tabs/browser.dart';
import 'package:flutter/material.dart';
import 'colorBlindnessFilters.dart';
import 'tabs/browser.dart';
import 'tabs/camera.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abled',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Abled'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
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
          children: [BrowserTab(), CamTab()],
          controller: controller,
        ),
      ),
      bottomNavigationBar: Material(
        // Set the color of the bottom navigation bar
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
          secondary: IconButton(
              icon: Icon(MdiIcons.helpCircleOutline),
              onPressed: () => {_showMore(colorFilters[i].name, colorFilters[i].about)}),
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
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        'More coming soon!',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 18,
        ),
      ),
    );
  }

  Future _showMore(var header, var body) async {
      await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text(header),
          children: <Widget>[
            new SimpleDialogOption(child:Text(body)),
            new SimpleDialogOption(
              child: new RaisedButton(child:Text("Okay"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            ),
          ],
        )
      );
  }

  List getColorFilters() {
    List filters = new List();
    filters.add(new ColorBlindnessFilters(
        'Normal Vision',
        'Normal Vision refers to not having any form of color blindness.',
        <double>[
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
    filters.add(new ColorBlindnessFilters(
        'Protonopia(RG)',
        'Protonopia is a form of Red-Green Color Blindness. Protonopia affects 1.01% of males and .02% of females. Protonopia means the Long wavelength cones(L-Cones) are missing.',
        <double>[
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
    filters.add(new ColorBlindnessFilters(
        'Protanomaly(RG)',
        'Protanomaly is a form of Red-Green Color Blindness. Protanomaly affects 1.08% of males and .03% of females. Protanomaly means the Long wavelength cones(L-Cones) are defective but not missing.',
        <double>[
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
    filters.add(new ColorBlindnessFilters(
        'Deuteranopia(RG)',
        'Deuteranopia is a form of Red-Green Color Blindness often called simply green-blind. Deuteranopia affects 1.0% of males and .1% of females. Deuteranopia means the medium wavelength cones(green) are missing.',
        <double>[
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
    filters.add(new ColorBlindnessFilters(
        'Deuteranomaly',
        'Deuteranomaly is a form of Red-Green Color Blindness often called simply green-weak. Deuteranomaly affects 5.0% of males and .35% of females. Deuteranomaly means the medium wavelength cones(green) are defiecent.',
        <double>[
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
    filters.add(new ColorBlindnessFilters(
        'Tritanopia(BY)',
        'Tritanopia is a form of Blue-Yellow Color Blindness. Tritanopia varys greatly on numbers affected and it is much less than red-green forms of color blindness. Tritanopia means the short wavelength cones are missing.',
        <double>[
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
    filters.add(new ColorBlindnessFilters(
        'Tritanomaly(BY)',
        'Tritanomaly is a form of Blue-Yellow Color Blindness. Tritanomaly varys greatly on numbers affected and it is much less than red-green forms of color blindness. Tritanomaly means the short wavelength cones are deficient.',
        <double>[
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
    filters.add(new ColorBlindnessFilters(
        'Achromatopsia(All)',
        'Achromatopsia is a form of Total Color Blindness. Achromatopsia affects .003% people born worldwide.',
        <double>[
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
    filters.add(new ColorBlindnessFilters('Achromatomaly(All)',
        'Achromatomaly is a form of Total Color Blindness.', <double>[
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
