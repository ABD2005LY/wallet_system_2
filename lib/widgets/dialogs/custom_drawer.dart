import 'package:flutter/material.dart';
import 'package:wallet_system_2/widgets/cickables/main_button.dart';
import 'package:wallet_system_2/widgets/dialogs/logout_dialog.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MainButton(
              busy: false,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => LogoutDialog(),
                );
              },
              title: "Logout",
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
