import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = pickedFile.path;
    }
  }
}

final profileImageProvider = NotifierProvider<ProfileImageNotifier, String?>(
  ProfileImageNotifier.new,
);
