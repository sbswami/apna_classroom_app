import 'dart:io';

import 'package:apna_classroom_app/api/storage.dart';
import 'package:apna_classroom_app/api/user.dart';
import 'package:apna_classroom_app/components/buttons/flat_icon_text_button.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/images/person_image.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/home/home.dart';
import 'package:apna_classroom_app/screens/profile/service.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {C.HIDE_MY_NUMBER: false};
  String usernameError;

  save() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      var user = await checkUsername({C.USERNAME: _formData[C.USERNAME]});
      if (user != null) {
        return setState(() {
          usernameError = S.USERNAME_ALREADY_EXISTS.tr;
        });
      }
      setState(() {
        usernameError = null;
      });
      _formData[C.PHOTO_URL] = await uploadProfileImage(_formData[C.IMAGE]);
      _formData.remove(C.IMAGE);
      await updateUser(_formData);
      Get.offAll(Home());
    }
  }

  pickProfilePick() async {
    var result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatIconTextButton(
                  iconData: Icons.camera_alt,
                  text: S.CAMERA.tr,
                  onPressed: () => Get.back(result: _CAMERA),
                ),
                FlatIconTextButton(
                  iconData: Icons.photo_library,
                  text: S.GALLERY.tr,
                  onPressed: () => Get.back(result: _GALLERY),
                ),
                FlatIconTextButton(
                  iconData: Icons.delete,
                  text: S.DELETE.tr,
                  onPressed: () => Get.back(result: _DELETE),
                ),
              ],
            ),
          );
        });
    final picker = ImagePicker();
    PickedFile pickedFile;
    switch (result) {
      case _CAMERA:
        pickedFile = await picker.getImage(
            source: ImageSource.camera, maxWidth: 200, maxHeight: 200);
        break;
      case _GALLERY:
        pickedFile = await picker.getImage(
            source: ImageSource.gallery, maxWidth: 200, maxHeight: 200);
        break;
      case _DELETE:
        setState(() {
          _formData[C.IMAGE] = null;
        });
        break;
      default:
        return;
    }

    if (pickedFile == null) return;
    setState(() {
      _formData[C.IMAGE] = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.PROFILE.tr),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Image.asset(
                    A.APP_ICON,
                    scale: 3,
                  ),
                  PersonImage(
                    editMode: true,
                    image: _formData[C.IMAGE],
                    onTap: pickProfilePick,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: S.ENTER_YOUR_NAME.tr,
                    ),
                    onSaved: (String value) => _formData[C.NAME] = value,
                    validator: validName,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: S.USERNAME.tr,
                      errorText: usernameError,
                    ),
                    onSaved: (String value) => _formData[C.USERNAME] = value,
                    validator: validateUsername,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(S.HIDE_MY_PHONE_NUMBER.tr),
                        Switch(
                          value: _formData[C.HIDE_MY_NUMBER],
                          onChanged: (value) => setState(
                            () {
                              _formData[C.HIDE_MY_NUMBER] = value;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  PrimaryButton(
                    text: S.CONTINUE.tr,
                    onPress: save,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const String _CAMERA = 'CAMERA';
const String _GALLERY = 'GALLERY';
const String _DELETE = 'DELETE';
