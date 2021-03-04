import 'package:apna_classroom_app/api/storage.dart';
import 'package:apna_classroom_app/api/user.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/components/images/apna_image_picker.dart';
import 'package:apna_classroom_app/components/images/person_image.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  //

  // Save
  save() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      showProgress();
      if (_formData[C.IMAGE] != null && _formData[C.THUMBNAIL] != null) {
        _formData[C.PHOTO_URL] = await uploadImage(_formData[C.IMAGE]);
        _formData[C.THUMBNAIL_URL] =
            await uploadImageThumbnail(_formData[C.THUMBNAIL]);
        _formData.remove(C.IMAGE);
        _formData.remove(C.THUMBNAIL);
      }
      await updateUser(_formData);
      Get.back();
      Get.back();
    }
  }

  // Pick profile pick
  pickProfilePick() async {
    var result = await showApnaImagePicker(context, showDelete: true);
    if (result == null) return;

    if (result[3]) {
      return setState(() {
        _formData[C.IMAGE] = null;
        _formData[C.THUMBNAIL] = null;
      });
    }

    setState(() {
      _formData[C.THUMBNAIL] = result[1];
      _formData[C.IMAGE] = result[2];
    });
  }

  // Init State
  @override
  void initState() {
    _formData[C.HIDE_MY_NUMBER] =
        UserController.to.currentUser[C.HIDE_MY_NUMBER];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _user = UserController.to.currentUser;
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
                  SizedBox(height: 16),
                  PersonImage(
                    editMode: true,
                    thumbnailImage: _formData[C.THUMBNAIL],
                    image: _formData[C.IMAGE],
                    thumbnailUrl: _user[C.THUMBNAIL_URL],
                    url: _user[C.PHOTO_URL],
                    onPhotoSelect: pickProfilePick,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: S.ENTER_YOUR_NAME.tr,
                    ),
                    onSaved: (String value) => _formData[C.NAME] = value,
                    initialValue: _user[C.NAME],
                    validator: validName,
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
                    text: S.SAVE.tr,
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
