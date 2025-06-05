import 'package:flutter/material.dart';
import 'package:multimedia_apps/core/constant/app_styles.dart';

class SpeedDashboard extends StatefulWidget {
  const SpeedDashboard({super.key});

  @override
  State<SpeedDashboard> createState() => _SpeedDashboardState();
}

class _SpeedDashboardState extends State<SpeedDashboard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Padding ditambahkan
                decoration: BoxDecoration(
                  color: Color(0xFF334EAC).withOpacity(0.75),
                  image: DecorationImage(
                    image: AssetImage('assets/images/yaris1.webp'),
    
                    scale: 0.2,
                    alignment: Alignment.center, // Gambar tetap di tengah
                  ),
                ),
                child: Align(
                  alignment: Alignment.topLeft, // Teks rata kiri
                  child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    crossAxisAlignment: CrossAxisAlignment.start, // Pastikan teks mulai dari kiri
                    children: [
                      Text(
                        "TOYOTA",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //SizedBox(height: 8), // Jarak antara dua teks
                      Text(
                        "Yaris Cross",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
