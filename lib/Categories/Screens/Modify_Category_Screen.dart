import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Errors.dart';
import '../../../Global/Functions/Colors.dart';

import '../../../Global/Widgets/AppBar.dart';
import '../../../Global/Widgets/Buttons.dart';
import '../../../Global/Widgets/Texts.dart';
import '../../../Global/Widgets/Toasts.dart';
import '../../../Global/Widgets/TextFormField.dart';

import '../../../Global/Screens/Loading_Screen.dart';

import '../../../Global/Photos/Rect_Stack_Choose_And_Edit_Photo.dart';

import '../../../Global/Alert_Dialogs/Alert_Dialog_For_Discarding_Changes.dart';

import '../../../Categories/Providers/Category_Model.dart';
import '../../../Categories/Providers/Categories_Model.dart';

class Modify_Category_Screen extends StatefulWidget {
  const Modify_Category_Screen({super.key});
  static const routeName = 'Modify-Category';

  @override
  State<Modify_Category_Screen> createState() => _Modify_Category_ScreenState();
}

class _Modify_Category_ScreenState extends State<Modify_Category_Screen> {
  final _form_key = GlobalKey<FormState>();

  var is_edit = false;
  var _did_change = true;

  XFile? file_photo;

  Category_Model? main_category;

  var edited_category = Category_Model(
    id: 0,
    title: '',
    photo: '',
  );

  @override
  void didChangeDependencies() {
    if (_did_change) {
      var category =
          ModalRoute.of(context)!.settings.arguments as Category_Model?;

      if (category != null) {
        is_edit = true;

        main_category = category;

        edited_category = Category_Model(
          id: main_category!.id,
          title: main_category!.title,
          photo: main_category!.photo,
        );
      }
      _did_change = false;
    }
    super.didChangeDependencies();
  }

  Future<void> Submit() async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (_form_key.currentState!.validate()) {
      _form_key.currentState!.save();

      if (!is_edit && file_photo == null) {
        return Show_Text_Toast(
          context: context,
          text: 'Category Photo is required !',
        );
      }

      Loading_Screen(context: context);

      try {
        if (!is_edit) {
          await Provider.of<Categories_Model>(context, listen: false)
              .Create_Category(
            photo: file_photo!,
            title: edited_category.title,
          );
        } else {
          if (edited_category.title == main_category!.title &&
              file_photo == null) {
            // To Popup the Loading Screen.
            Navigator.pop(context);
            // To Popup the Screen.
            return Navigator.pop(context);
          }

          await main_category!.Edit_Category(
            new_photo: file_photo,
            new_title: edited_category.title,
          );
        }

        if (mounted) {
          // To Popup the Loading Screen.
          Navigator.pop(context);
          // To Popup the Screen.
          return Navigator.pop(context);
        }
      } catch (error) {
        if (mounted) {
          // To Popup the loading screen.
          Navigator.pop(context);
          return Error_Dialog(context: context, error: error.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: WillPopScope(
        onWillPop: () => C_Alert_Dialog_For_Discarding_Changes(context),
        child: Scaffold(
          backgroundColor: Get_White,
          appBar: C_AppBar(
            title_size: 2.1,
            title: is_edit ? 'Edit Category' : 'New Category',
          ),
          body: Form(
            key: _form_key,
            child: ListView(
              children: <Widget>[
                Rect_Stack_Choose_And_Edit_Photo(
                  x_aspect_ratio: 1,
                  y_aspect_ratio: 1,
                  file_photo: file_photo,
                  onChoose_photo: (image) => file_photo = image,
                  network_image: edited_category.photo.isEmpty
                      ? null
                      : edited_category.photo,
                ),
                C_TextFormField(
                  top_margin: 3,
                  left_margin: 2,
                  right_margin: 2,
                  label_text: 'Title',
                  max_length: 30,
                  initial_value: edited_category.title,
                  text_input_action: TextInputAction.done,
                  onSaved: (title) => edited_category.title = title,
                  validate: (title) {
                    if (title.length < 3) {
                      return 'Title must be at least 3 characters.';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 2.h, bottom: 8.h, right: 2.w, left: 2.w),
                  child: C_Text(
                    color: Get_Grey,
                    font_size: 1.6,
                    text:
                        'Please enter a title for the category that is no more than 30 characters long.',
                  ),
                ),
                Container_Button(
                  right_margin: 2,
                  left_margin: 2,
                  background_color: Get_Primary,
                  title: is_edit ? 'Save' : 'Create',
                  onTap: Submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
