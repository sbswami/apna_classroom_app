import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/storage/storage_api.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/api/user.dart';
import 'package:apna_classroom_app/auth/auth.dart';
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
      // Track Create Profile Event
      track(EventName.CREATE_PROFILE, {
        EventProp.HIDE_PHONE_NUMBER: _formData[C.HIDE_MY_NUMBER],
        EventProp.IMAGE: _formData[C.MEDIA] != null,
      });

      updateFirebaseUser();
      Get.back();
      Get.offAll(Home());
    }
  }

  pickProfilePick() async {
    var result = await showApnaMediaPicker(true, deleteOption: true);

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
  void initState() {
    super.initState();
    // Set Screen
    trackScreen(ScreenNames.CreateProfile);
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
                    A.LOADING,
                    scale: 3,
                  ),
                  PersonImage(
                    editMode: true,
                    thumbnailImage: (_formData[C.MEDIA] ?? {})[C.THUMBNAIL],
                    image: (_formData[C.MEDIA] ?? {})[C.FILE],
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
