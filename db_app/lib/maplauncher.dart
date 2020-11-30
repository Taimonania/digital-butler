import 'dart:ffi';

import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:async';

class MapHelper {
  static double getLat(String coordinates) {
    String lat = coordinates.split('<')[1].split('>')[0];
    lat = lat.split(',')[0];
    lat = lat.split(' ')[1];
    return double.parse(lat);
  }

  static double getLong(String coordinates) {
    String long = coordinates.split('<')[1].split('>')[0];
    long = long.split(' ')[3];
    return double.parse(long);
  }

  static Future coordLink(double lat, double long) async {
    String link = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'ERROR';
    }
  }
}
