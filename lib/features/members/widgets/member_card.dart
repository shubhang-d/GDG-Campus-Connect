import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/data/models/user_model.dart';
import 'package:gdg_campus_connect/app/routes/app_pages.dart';

class MemberCard extends StatelessWidget {
  final UserModel user;
  const MemberCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to the user's public profile screen
          Get.toNamed(Routes.PROFILE_DETAIL, arguments: user.uid);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // Use MainAxisAlignment.start to align content to the top
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // --- AVATAR ---
              CircleAvatar(
                radius: 30, // Slightly smaller to give more space
                backgroundImage: NetworkImage(user.photoURL),
                onBackgroundImageError: (_, __) {},
                child: user.photoURL.isEmpty ? const Icon(Icons.person, size: 30) : null,
              ),
              const SizedBox(height: 8),

              // --- USER NAME (Allows wrapping) ---
              Text(
                user.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 2, // Allow name to wrap to two lines
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // --- SKILLS SECTION (Flexible and Scrollable) ---
              if (user.skills.isNotEmpty)
                // Flexible tells this section to take up the available remaining space
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 4.0,
                      runSpacing: 0.0,
                      alignment: WrapAlignment.center,
                      children: user.skills.map((skill) => Chip(
                        label: Text(skill),
                        labelStyle: const TextStyle(fontSize: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}