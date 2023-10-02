import 'package:age_recog_pkl/view/Camera/face_detector_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/screen_params.dart';

List<Map<String, String>> tess = [
  {
    'tanggal': "2023-09-22 13:41:54.671", //2023-09-22 13:41:54.671
    'lokasi': 'Plasa Pahlawan',
    'umur': '20'
  },
  {
    'tanggal': "2023-09-22 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '20'
  },
  {
    'tanggal': "2023-09-22 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '20'
  },
  {
    'tanggal': "2023-09-18 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '30'
  },
  {
    'tanggal': "2023-09-18 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '30'
  },
  {
    'tanggal': "2023-09-18 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '30'
  },
  {
    'tanggal': "2023-09-19 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '30'
  },
  {
    'tanggal': "2023-09-19 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '30'
  },
  {
    'tanggal': "2023-09-19 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '50'
  },
  {
    'tanggal': "2023-09-19 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '50'
  },
  {
    'tanggal': "2023-09-20 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '50'
  },
  {
    'tanggal': "2023-09-20 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '50'
  },
  {
    'tanggal': "2023-09-20 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '50'
  },
  {
    'tanggal': "2023-09-20 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '18'
  },
  {
    'tanggal': "2023-09-20 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '18'
  },
  {
    'tanggal': "2023-09-21 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '18'
  },
  {
    'tanggal': "2023-09-21 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '28'
  },
  {
    'tanggal': "2023-09-21 13:41:54.671",
    'lokasi': 'Plasa Pahlawan',
    'umur': '28'
  },
];

bool loading = true;

int senin = 0;
int selasa = 0;
int rabu = 0;
int kamis = 0;
int jumat = 0;
int sabtu = 0;

int muda = 0;
int setengahTua = 0;
int tua = 0;

final List<DummyType> chartData = [
  DummyType("Isnin", senin),
  DummyType("Selasa", selasa),
  DummyType("Rawu", rabu),
  DummyType("K'mis", kamis),
  DummyType("Juma'at", jumat),
  DummyType("Sabtu", sabtu)
];

final List<DummyType2> PieData = [
  DummyType2("Young", muda),
  DummyType2("Half-Old", setengahTua),
  DummyType2("Old", tua)
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    loadWhenFirstLoaded(BuildContext context) async {
      if (loading == true) {
        setState(() {
          for (Map<String, String> tes in tess) {
            if (DateFormat.EEEE().format(DateTime.parse(tes['tanggal']!)) ==
                'Friday') {
              setState(() {
                jumat++;
              });
            } else if (DateFormat.EEEE()
                    .format(DateTime.parse(tes['tanggal']!)) ==
                'Thursday') {
              kamis++;
            } else if (DateFormat.EEEE()
                    .format(DateTime.parse(tes['tanggal']!)) ==
                'Wednesday') {
              rabu++;
            } else if (DateFormat.EEEE()
                    .format(DateTime.parse(tes['tanggal']!)) ==
                'Tuesday') {
              selasa++;
            } else if (DateFormat.EEEE()
                    .format(DateTime.parse(tes['tanggal']!)) ==
                'Monday') {
              senin++;
            } else if (DateFormat.EEEE()
                    .format(DateTime.parse(tes['tanggal']!)) ==
                'Saturday') {
              sabtu++;
            }
            for (Map<String, String> tes in tess) {
              if (int.parse(tes['umur']!) < 25) {
                muda++;
              } else if (int.parse(tes['umur']!) < 45) {
                setengahTua++;
              } else {
                tua++;
              }
            }
          }
          loading = false;
        });
      } else {}
    }

    Future.delayed(Duration.zero, () => loadWhenFirstLoaded(context));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Age Recognition",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 237, 2, 38),
        shadowColor: const Color.fromARGB(100, 0, 0, 0),
        elevation: 50,
      ),
      key: GlobalKey(),
      body: Center(
        child: Column(
          children: <Widget>[
            _graph1(context),
            _graph2(context),
          ],
        ),
      ),
    );
  }

  Widget _graph1(BuildContext context) {
    if (loading) {
      return const CircularProgressIndicator();
    } else {
      return SfCartesianChart(
          title: ChartTitle(text: 'TesChart'),
          primaryXAxis: CategoryAxis(),
          palette: const [
            Color.fromARGB(255, 237, 2, 38)
          ],
          series: <ChartSeries<DummyType, String>>[
            // Renders column chart
            ColumnSeries<DummyType, String>(
                dataSource: chartData,
                xValueMapper: (DummyType data, _) => data.datee,
                yValueMapper: (DummyType data, _) => data.amount),
          ]);
    }
  }

  Widget _graph2(BuildContext context) {
    if (loading) {
      return const CircularProgressIndicator();
    } else {
      return SfCircularChart(
          title: ChartTitle(text: 'TesChart'),
          palette: const [
            Color.fromARGB(255, 237, 2, 38),
            Color.fromARGB(255, 253, 53, 83),
            Color.fromARGB(255, 182, 2, 29)
          ],
          series: <CircularSeries>[
            // Render pie chart
            PieSeries<DummyType2, String>(
              dataSource: PieData,
              xValueMapper: (DummyType2 data, _) => data.AgeType,
              yValueMapper: (DummyType2 data, _) => data.amount,
              dataLabelMapper: (DummyType2 data, _) => data.AgeType,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ]);
    }
  }
}

class DummyType {
  DummyType(this.datee, this.amount);
  final String datee;
  final int amount;
}

class DummyType2 {
  DummyType2(this.AgeType, this.amount);
  final String AgeType;
  final int amount;
}
