import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/ui/profile/view_model/profile_viewmodel.dart';
import 'profile_header.dart';
import 'profile_body.dart';

import 'package:gameverse/ui/shared/widgets/page_footer.dart';
import 'package:gameverse/config/spacing_config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, ProfileViewModel>(
      builder: (context, authViewModel, profileViewModel, child) {
        final user = authViewModel.user;
        // Maybe not necessary because router already does this check
        if (user == null) {
          context.push('/login');
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(
                user: user!,
                profileViewModel: profileViewModel,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: getNegativeSpacePadding(context),
                child: ProfileBody(
                  user: user,
                  profileViewModel: profileViewModel,
                ),
              ),
              PageFooter(),
            ],
          ),
        );
      },
    );
  }
}