import 'package:get/get.dart';
import 'package:note_app_students/model/teacher.dart';

class CDController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Teacher> teacher = Teacher("", "", "","").obs;
  setIsLoading(bool val) {
    isLoading.value = val;
  }

  setTeacher(Teacher val) {
    teacher.value = val;
  }
}
