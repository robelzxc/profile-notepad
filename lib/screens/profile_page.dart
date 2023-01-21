import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData;

  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imgTemporary = File(image.path);
      setState(() {
        this.image = imgTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  void _getInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString("user");
    var user = convert.jsonDecode(userJson.toString());
    setState(() {
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color(0xFF4DD0E1),
            Color(0xFF80DEEA),
            Color(0xFFB2EBF2),
            Color(0xFFE0F7FA),
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(userData != null ? '${userData['name']} Profile' : "",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          centerTitle: true,
          toolbarHeight: 50,
          elevation: 0.5,
          backgroundColor: const Color(0xFF00ACC1),
          shadowColor: const Color(0xFF00838F),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.cyanAccent,
                      child: ClipOval(
                        child: SizedBox(
                          width: 130.0,
                          height: 130.0,
                          child: image != null
                              ? ClipOval(
                                  child: Image.file(
                                  image!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ))
                              : const Image(
                                  image: AssetImage('assets/logo.png'),
                                  height: 200,
                                  width: 200,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 90),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              PermissionStatus cameraStatus =
                                  await Permission.camera.request();
                              if (cameraStatus == PermissionStatus.granted) {
                                pickImage(ImageSource.camera);
                              } else if (cameraStatus ==
                                  PermissionStatus.denied) {
                                return;
                              }
                            },
                            child: const Text('Camera')),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              PermissionStatus galleryStatus =
                                  await Permission.storage.request();
                              if (galleryStatus == PermissionStatus.granted) {
                                pickImage(ImageSource.gallery);
                              } else if (galleryStatus ==
                                  PermissionStatus.denied) {
                                return;
                              }
                            },
                            child: const Text('Gallery'))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    tileColor: Color(0xFFB2EBF2),
                    leading: const Icon(
                      Icons.person,
                      size: 35,
                    ),
                    title: const Text('Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20)),
                    subtitle: Text(userData != null ? userData['name'] : "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14)),
                    shape: const BeveledRectangleBorder(
                        side: BorderSide(color: Color(0xFF0097A7), width: 2.0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(25, 50))),
                    contentPadding: const EdgeInsets.only(left: 30),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ListTile(
                      tileColor: const Color(0xFFB2EBF2),
                      leading: const Icon(
                        Icons.mail,
                        size: 35,
                      ),
                      title: const Text('Email',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20)),
                      subtitle: Text(userData != null ? userData['email'] : "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14)),
                      shape: const BeveledRectangleBorder(
                          side:
                              BorderSide(color: Color(0xFF0097A7), width: 2.0),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(25, 50)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
