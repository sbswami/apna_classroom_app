import 'package:apna_classroom_app/api/storage.dart';
import 'package:apna_classroom_app/api/user.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/components/images/person_image.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/home/home.dart';
import 'package:apna_classroom_app/screens/media/media_picker/media_picker.dart';
import 'package:apna_classroom_app/screens/profile/service.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      showProgress();
      if (_formData[C.MEDIA] != null) {
        _formData[C.MEDIA][C.URL] =
            await uploadImage(_formData[C.MEDIA][C.FILE]);
        _formData[C.MEDIA][C.THUMBNAIL_URL] =
            await uploadImageThumbnail(_formData[C.MEDIA][C.THUMBNAIL]);
        _formData[C.MEDIA].remove(C.FILE);
        _formData[C.MEDIA].remove(C.THUMBNAIL);
      }
      await updateUser(_formData);
      Get.back();
      Get.offAll(Home());
    }
  }

  pickProfilePick() async {
    var result = await showApnaMediaPicker(true, deleteOption: true);
    print(result);
    if (result == null) return;
    if (result[C.DELETE] ?? false) {
      return setState(() {
        _formData.remove(C.MEDIA);
      });
    }
    setState(() {
      _formData[C.MEDIA] = result;
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
                    thumbnailImage: (_formData[C.MEDIA] ?? {})[C.THUMBNAIL],
                    image: (_formData[C.MEDIA] ?? {})[C.IMAGE],
                    onPhotoSelect: pickProfilePick,
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
