import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Nota: agrega tu firebase_options.dart (generado por FlutterFire CLI) al proyecto.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(EmpoweredMindsApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // manejar notificación de fondo
}

class EmpoweredMindsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empowered Minds',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getInitialMessage();
  }

  Stream<DocumentSnapshot> temaDiarioStream() {
    return _db.collection('app').doc('today').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF2E86FF), Color(0xFF7B61FF), Color(0xFF6A329F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: gradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header con logo (usa tu SVG convertido a Widget o imagen)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white24,
                      child: Text('EM', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    SizedBox(width: 12),
                    Text('Empowered Minds', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.settings, color: Colors.white)),
                  ],
                ),
                SizedBox(height: 18),

                // Tema diario (traído desde Firestore)
                StreamBuilder<DocumentSnapshot>(
                  stream: temaDiarioStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Card(
                        color: Colors.white24,
                        child: Padding(padding: EdgeInsets.all(16), child: Text('Cargando tema del día...', style: TextStyle(color: Colors.white))),
                      );
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                    final title = data['title'] ?? 'Bienvenido a Empowered Minds';
                    final body = data['body'] ?? 'Aquí verás todos los días un tema de PNL recomendado.';
                    return Card(
                      color: Colors.white24,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tema del día', style: TextStyle(color: Colors.white70)),
                            SizedBox(height: 8),
                            Text(title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text(body, style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 18),

                // Secciones: Tareas, Videos, Libros, Ejercicios
                SectionCard(title: 'Tareas Asignadas', child: TasksList()),
                SectionCard(title: 'Videos Recomendados', child: VideosList()),
                SectionCard(title: 'Libros Recomendados', child: BooksList()),
                SectionCard(title: 'Ejercicios Diarios', child: ExercisesList()),

                SizedBox(height: 24),
                // Footer social
                Center(
                  child: Text('Síguenos en redes para notificaciones en vivo', style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable section card
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  SectionCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          child
        ]),
      ),
    );
  }
}

/// Placeholder widgets (debes implementarlos para leer colecciones Firestore)
class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Aquí aparecerán las tareas asignadas.', style: TextStyle(color: Colors.white70));
  }
}

class VideosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.play_circle_fill, color: Colors.white),
        title: Text('Canal recomendado: Empowered Minds (YouTube)', style: TextStyle(color: Colors.white70)),
        onTap: () { /* abrir enlace de YouTube */ },
      )
    ]);
  }
}

class BooksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Listado de libros recomendados por el equipo.', style: TextStyle(color: Colors.white70));
  }
}

class ExercisesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Ejercicios cortos de PNL para hacer cada día.', style: TextStyle(color: Colors.white70));
  }
}