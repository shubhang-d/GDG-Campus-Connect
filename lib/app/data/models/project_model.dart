import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String projectName;
  final String description;
  final String problemStatement;
  final List<String> teamMembers;
  final List<String> pendingMembers;
  final List<String> requiredSkills;
  final String status;
  final String? repoLink;
  final String creatorId;
  final Timestamp createdAt;

  ProjectModel({
    required this.id,
    required this.projectName,
    required this.description,
    required this.problemStatement,
    required this.teamMembers,
    required this.pendingMembers,
    required this.requiredSkills,
    required this.status,
    this.repoLink,
    required this.creatorId,
    required this.createdAt,
  });

  factory ProjectModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return ProjectModel(
      id: snap.id,
      projectName: data['projectName'] ?? '',
      description: data['description'] ?? '',
      problemStatement: data['problemStatement'] ?? '',
      teamMembers: List<String>.from(data['teamMembers'] ?? []),
      pendingMembers: List<String>.from(data['pendingMembers'] ?? []),
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      status: data['status'] ?? 'Recruiting',
      repoLink: data['repoLink'],
      creatorId: data['creatorId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}