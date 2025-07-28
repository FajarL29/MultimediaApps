import 'dart:io';
import 'package:path_provider/path_provider.dart';


class FileStorageHelper {
  static const String _fileName = 'health_data.txt';

  /// Mendapatkan path file penyimpanan data
  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  /// Menambahkan data ke file historis
  static Future<void> appendHealthData(String data) async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      await file.writeAsString('$data\n', mode: FileMode.append);
      print('✅ Data disimpan: $data');
    } catch (e) {
      print('❌ Gagal menyimpan data: $e');
    }
  }

  /// Membaca seluruh isi data historis
  static Future<String> readHealthData() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      return await file.readAsString();
    } catch (e) {
      print('❌ Gagal membaca file: $e');
      return '';
    }
  }

  /// Menghapus seluruh data histori
  static Future<void> clearHealthData() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      await file.writeAsString('');
      print('⚠️ File data dikosongkan');
    } catch (e) {
      print('❌ Gagal menghapus data: $e');
    }
  }

  static Future<void> saveDeviceStatus({
  required bool isAirPurifierOn,
  required bool isO2On,
}) async {
  final content = 'airPurifier:$isAirPurifierOn\no2:$isO2On';
  final path = await _getFilePath();
  final file = File(path);
  await file.writeAsString(content);
}

static Future<Map<String, bool>> loadDeviceStatus() async {
  try {
    final path = await _getFilePath();
    final file = File(path);
    if (!await file.exists()) return {'airPurifier': false, 'o2': false};

    final lines = await file.readAsLines();
    final Map<String, bool> status = {'airPurifier': false, 'o2': false};

    for (final line in lines) {
      if (line.startsWith('airPurifier:')) {
        status['airPurifier'] = line.split(':')[1] == 'true';
      } else if (line.startsWith('o2:')) {
        status['o2'] = line.split(':')[1] == 'true';
      }
    }
    return status;
  } catch (e) {
    print('❌ Gagal membaca status perangkat: $e');
    return {'airPurifier': false, 'o2': false};
  }
}

}
