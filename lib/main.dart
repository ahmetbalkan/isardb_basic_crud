import 'package:flutter/material.dart';
import 'package:isarproject/local_db/isar_service.dart';
import 'package:isarproject/models/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

IsarService isarService = IsarService();

late TextEditingController _controller;
late TextEditingController _controller2;

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _controller = TextEditingController();
    _controller2 = TextEditingController();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Todo App"), centerTitle: true, actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
            onTap: () {
              showModel("add", User("", 0));
            },
            child: const Icon(
              Icons.add,
              size: 35,
            ),
          ),
        )
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<List<User>>(
                stream: isarService.listenUser(),
                builder: (context, snapshot) => snapshot.hasData
                    ? InkWell(
                        onTap: () async {
                          final a = await isarService.filterName();
                          print(a!.name);
                        },
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.abc,
                                    size: 50,
                                  ),
                                  Text(snapshot.data![index].name!),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            _controller.text =
                                                snapshot.data![index].name!;
                                            _controller2.text = snapshot
                                                .data![index].id
                                                .toString();
                                            showModel("update",
                                                snapshot.data![index]);
                                          },
                                          child: Icon(
                                            Icons.autorenew_outlined,
                                            size: 30,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            await isarService.deleteUser(
                                                snapshot.data![index].id);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            size: 30,
                                          )),
                                    ],
                                  ),
                                ],
                              )),
                            );
                          },
                        ),
                      )
                    : const Text("Data Bulunmuyor.")),
          ),
        ],
      ),
    );
  }

  showModel(deger, User user) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 300,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 40,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'isim',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Boş Bırakılamaz';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _controller2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Yaş',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Boş Bırakılamaz';
                            }
                            return null;
                          },
                        ),
                        deger == "add"
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await isarService.saveUser(User(
                                        _controller.text,
                                        int.parse(_controller2.text)));
                                    Navigator.of(context).pop();
                                    _controller.text = "";
                                    _controller2.text = "";
                                  },
                                  child: const Text('Submit'),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    user.name = _controller.text;
                                    user.age = int.parse(_controller2.text);
                                    await isarService.UpdateUser(user);
                                    Navigator.of(context).pop();
                                    _controller.text = "";
                                    _controller2.text = "";
                                  },
                                  child: const Text('Submit'),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
