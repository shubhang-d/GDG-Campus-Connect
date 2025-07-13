import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> skills;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: skills
                    .map((skill) => Chip(
                          label: Text(skill),
                          padding: EdgeInsets.zero,
                          labelStyle: const TextStyle(fontSize: 12),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}