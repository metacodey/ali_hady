import 'package:get/get.dart';
import 'package:mc_utils/mc_utils.dart';

/// [ListButtonsController] is responsible for managing the state of button selection
/// within a list of buttons. It tracks the currently active button and updates
/// the UI when a different button is selected.
///
class ListButtonsController extends GetxController {
  RxInt active = 0.obs;

  /// Changes the state of the selected button in the menu. The [selected] parameter
  /// indicates the index of the selected button, and the [onSelected] function is
  /// called with the index of the newly selected button.
  void changeStateBtnMenu(
      {required int selected, required Function(int) onSelected}) {
    onSelected(selected);
    active.value = selected;
    update();
  }
}
