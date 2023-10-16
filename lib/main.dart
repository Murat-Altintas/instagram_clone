import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/extensions.dart';
import 'bloc/crud_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _mailController = TextEditingController();
  final _passController = TextEditingController();
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection("users").snapshots();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CrudBloc(),
        child: BlocBuilder<CrudBloc, CrudState>(
          builder: (context, state) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Mail'),
                    controller: _mailController,
                  ),
                  TextField(
                    controller: _passController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<CrudBloc>().add(CrudLoginEvent(pass: int.parse(_passController.text), mail: _mailController.text));
                        },
                        child: const Text("Login"),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<CrudBloc>().add(CrudAddUserEvent(pass: int.parse(_passController.text), mail: _mailController.text));
                        },
                        child: const Text("Add User"),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<CrudBloc>().add(CrudLogoutEvent());
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: users,
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text("error");
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text("loading");
                              }
                              final data = snapshot.requireData;
                              if (state is CrudSuccessfulState) {
                                return Expanded(
                                  child: ListView.builder(
                                    clipBehavior: Clip.none,
                                      shrinkWrap: true,
                                      itemCount: data.size,
                                      itemBuilder: (context, index) {
                                        return Text("mail: -- ${data.docs[index]["mail"]} -- pass: -- ${data.docs[index]["pass"]}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600));
                                      }),
                                );
                              }
                              return const Center(
                                child: Text("Please Write Mail And Password"),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
