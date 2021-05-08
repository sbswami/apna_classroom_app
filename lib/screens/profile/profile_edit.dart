import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/storage/storage_api.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/api/user.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/components/images/person_image.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/media/media_picker/media_picker.dart';
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
  Map<String, dynamic> _formData = {};

  // Save
  save() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      showProgress();
      if (_formData[C.MEDIA] != null && _formData[C.MEDIA][C.ID] == null) {
        var storageResponse = await uploadToStorage(
          file: _formData[C.MEDIA][C.FILE],
          type: FileType.IMAGE,
          thumbnail: _formData[C.MEDIA][C.THUMBNAIL],
        );

        _formData[C.MEDIA][C.URL] = storageResponse[StorageConstant.PATH];
        _formData[C.MEDIA].remove(C.FILE);
        _formData[C.MEDIA].remove(C.THUMBNAIL);
      }
      await updateUser(_formData);

      // Track
      track(EventName.EDIT_PROFILE, {
        EventProp.HIDE_PHONE_NUMBER: _formData[C.HIDE_MY_NUMBER],
      });
      Get.back();
      Get.back();
    }
  }

  // Pick profile pick
  pickProfilePick() async {
    var result = await showApnaMediaPicker(true, deleteOption: true);

    if (result == null) return;
    if (result[C.DELETE] ?? false) {
      return setState(() {
        _formData[C.MEDIA] = null;
      });
    }
    setState(() {
      _formData[C.MEDIA] = result;
    });
  }

  // Init State
  @override
  void initState() {
    _formData = {
      C.HIDE_MY_NUMBER: UserController.to.currentUser[C.HIDE_MY_NUMBER],
      C.MEDIA: UserController.to.currentUser[C.MEDIA],
    };

    super.initState();

    // Track Screen
    trackScreen(ScreenNames.EditProfile);
  }

  @override
  Widget build(BuildContext context) {
    var _user = UserController.to.currentUser;
    var media = _formData[C.MEDIA] ?? {};
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
                    thumbnailImage: media[C.THUMBNAIL],
                    image: media[C.FILE],
                    url: media[C.URL],
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
