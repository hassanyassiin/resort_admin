import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Global/Functions/Colors.dart';
import '../../../Global/Widgets/AppBar.dart';
import '../../../Global/Widgets/Failed.dart';
import '../../../Global/Widgets/Texts.dart';

import '../../../Global/Alert_Dialogs/Alert_Dialog_For_Confirmation.dart';
import '../../../Global/Modal_Sheets/Show_Options_List_Tiles_Modal_Sheet.dart';

import '../../../Categories/Providers/Categories_Model.dart';
import '../../../Categories/Providers/Category_Model.dart';
import '../../../Categories/Widgets/Category_Item.dart';
import '../../../Categories/Screens/Modify_Category_Screen.dart';
import '../../../Categories/Screens/Products_Screen.dart';

class Guideline_Screen extends StatelessWidget {
  const Guideline_Screen({super.key});
  static const routeName = '/Guideline';

  Future<dynamic> On_Manage_Category_Tap({
    required BuildContext context,
    required Category_Model category,
  }) async {
    return Show_Options_List_Tiles_Modal_Sheet(
      context: context,
      title: 'Modify Category',
      is_title_centered: true,
      list_tile_data: [
        {
          'Icon': Icons.edit,
          'Text': 'Edit',
          'onTap': () async {
            // To Pop up the Modal sheet.
            Navigator.pop(context);
            await Future.delayed(const Duration(milliseconds: 250));

            if (!context.mounted) {
              return;
            }

            Navigator.pushNamed(
              context,
              Modify_Category_Screen.routeName,
              arguments: category,
            );

            return;
          },
        },
        {
          'Icon': Icons.delete,
          'IconColor': Get_Red,
          'Text': 'Delete',
          'TextColor': Get_Red,
          'onTap': () async {
            // To Pop up the Modal sheet.
            Navigator.pop(context);
            await Future.delayed(const Duration(milliseconds: 250));

            if (!context.mounted) {
              return;
            }

            final is_deleted = await C_Alert_Dialog_For_Confirmation(
              context: context,
              button_one_title: 'Delete',
              content: 'Are you sure you want to delete this category ?',
            );

            if (!context.mounted) {
              return;
            }

            if (!is_deleted) {
              return;
            }

            await Provider.of<Categories_Model>(context, listen: false)
                .Delete_Category(
              category_id: category.id,
            );
          },
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<Categories_Model>(context, listen: false);

    return FutureBuilder(
      future: !categories.Get_Is_Get_Categories_Success
          ? categories.Get_Categories()
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading_Scaffold(
              appBar_title: 'Guideline', is_show_appBar_divider: true);
        } else if (snapshot.hasError) {
          return Failed_Scaffold(
            appBar_title: 'Guideline',
            is_show_appBar_divider: true,
            error_message: snapshot.error.toString(),
          );
        } else {
          return Scaffold(
            backgroundColor: Get_White,
            appBar: C_AppBar(
              title: 'Guideline',
              is_show_divider: true,
            ),
            body: Consumer<Categories_Model>(
              builder: (context, value, child) {
                if (categories.Get_Local_Categories.isEmpty) {
                  return Center(
                    child: C_Text(
                      color: Get_Grey,
                      font_size: 1.5,
                      text: 'There is no categories here, start adding +',
                    ),
                  );
                }

                return Scrollbar(
                  child: GridView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.w),
                    itemCount: categories.Get_Local_Categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 3.w,
                      crossAxisSpacing: 6.w,
                      childAspectRatio: 27.33.w / ((25.w / (1 / 1)) + 4.8.h),
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        key:
                            ValueKey(categories.Get_Local_Categories[index].id),
                        value: categories.Get_Local_Categories[index],
                        child: Consumer<Category_Model>(
                          builder: (context, category, __) {
                            return Category_Item(
                              width: 25,
                              id: category.id,
                              title: category.title,
                              font_size: 1.65,
                              border_radius: 1,
                              image: category.photo,
                              onLongPress: () => On_Manage_Category_Tap(
                                context: context,
                                category: category,
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                Product_Screen.routeName,
                                arguments: category,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              backgroundColor: Get_Primary,
              onPressed: () => Navigator.pushNamed(
                  context, Modify_Category_Screen.routeName),
              child: const Icon(Icons.add),
            ),
          );
        }
      },
    );
  }
}
