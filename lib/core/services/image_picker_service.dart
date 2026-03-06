import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final picker = ImagePicker();

  Future<XFile?> pickImage() async {
    return await picker.pickImage(source: ImageSource.gallery);
  }
}
