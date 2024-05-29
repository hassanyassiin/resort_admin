import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Functions/Errors.dart';

import '../../../Global/Widgets/Toasts.dart';
import '../../../Global/Widgets/Texts.dart';
import '../../../Global/Widgets/AppBar.dart';
import '../../../Global/Widgets/Buttons.dart';
import '../../../Global/Widgets/TextFormField.dart';

import '../../../Global/Alert_Dialogs/Alert_Dialog.dart';

import '../../../Global/Screens/Loading_Screen.dart';

import '../../../Global/Photos/Rect_Stack_Choose_And_Edit_Photo.dart';

import '../../../Global/Alert_Dialogs/Alert_Dialog_For_Discarding_Changes.dart';

import '../../../Categories/Providers/Category_Model.dart';

import '../../../Products/Providers/Product_Model.dart';

class Modify_Product_Screen extends StatefulWidget {
  const Modify_Product_Screen({super.key});
  static const routeName = 'Modify-Product';

  @override
  State<Modify_Product_Screen> createState() => _Modify_Product_ScreenState();
}

class _Modify_Product_ScreenState extends State<Modify_Product_Screen> {
  final _form_key = GlobalKey<FormState>();

  var is_edit = false;
  var _did_change = true;

  XFile? file_photo;

  late Category_Model category;
  Product_Model? main_product;

  var edited_product = Product_Model(
    id: 0,
    title: '',
    photo: '',
  );

  @override
  void didChangeDependencies() {
    if (_did_change) {
      var arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      category = arguments['Category'];

      if (arguments['Product'] != null) {
        is_edit = true;

        main_product = arguments['Product'];

        edited_product = Product_Model(
          id: main_product!.id,
          title: main_product!.title,
          photo: main_product!.photo,
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
          text: 'Product Photo is required !',
        );
      }

      Loading_Screen(context: context);

      try {
        if (!is_edit) {
          await category.Create_Product(
            photo: file_photo!,
            title: edited_product.title,
          );
        } else {
          if (edited_product.title == main_product!.title &&
              file_photo == null) {
            // To Popup the Loading Screen.
            Navigator.pop(context);
            // To Popup the Screen.
            return Navigator.pop(context);
          }

          await main_product!.Edit_Product(
            new_photo: file_photo,
            new_title: edited_product.title,
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

  Future<void> Delete_Product() async {
    // To Pop up the alert dialog.
    Navigator.pop(context);

    FocusManager.instance.primaryFocus!.unfocus();

    Loading_Screen(context: context);
    try {
      await category.Delete_Product(product_id: main_product!.id);

      if (mounted) {
        // To Pop up the loading screen.
        Navigator.pop(context);
        // To Popup the Screen.
        return Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        // To pop up the loading screen.
        Navigator.pop(context);

        return Error_Dialog(error: error.toString(), context: context);
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
            title: is_edit ? 'Edit Product' : 'New Product',
            suffix_widgets: [
              if (is_edit)
                IconButton(
                  icon: Icon(Icons.delete, color: Get_Red),
                  onPressed: () => C_Alert_Dialog(
                    context: context,
                    title: 'Are you sure?',
                    content: 'Deleting this product!',
                    button_one_title: 'Delete',
                    button_two_title: 'Cancel',
                    button_one_color: Get_Red,
                    is_only_one_button: false,
                    button_one_function: Delete_Product,
                  ),
                ),
            ],
          ),
          body: Form(
            key: _form_key,
            child: ListView(
              children: <Widget>[
                Rect_Stack_Choose_And_Edit_Photo(
                  x_aspect_ratio: 3,
                  y_aspect_ratio: 3.5,
                  file_photo: file_photo,
                  onChoose_photo: (image) => file_photo = image,
                  network_image: edited_product.photo.isEmpty
                      ? null
                      : edited_product.photo,
                ),
                C_TextFormField(
                  top_margin: 3,
                  left_margin: 2,
                  right_margin: 2,
                  min_lines: 2,
                  max_lines: 5,
                  label_text: 'Description',
                  initial_value: edited_product.title,
                  text_input_action: TextInputAction.done,
                  onSaved: (title) => edited_product.title = title,
                  validate: (title) {
                    if (title.length < 3) {
                      return 'Description must be at least 3 characters.';
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
                        'Please enter a description for the product with at least 3 characters.',
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
