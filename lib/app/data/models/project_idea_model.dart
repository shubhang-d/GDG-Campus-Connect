class ProjectIdeaModel {
  final String projectName;
  final String problemStatement;
  final String proposedSolution;
  final List<String> keyFeatures;

  ProjectIdeaModel({
    required this.projectName,
    required this.problemStatement,
    required this.proposedSolution,
    required this.keyFeatures,
  });

  factory ProjectIdeaModel.fromJson(Map<String, dynamic> json) {
    return ProjectIdeaModel(
      projectName: json['projectName'] ?? 'No Name',
      problemStatement: json['problemStatement'] ?? 'No problem statement.',
      proposedSolution: json['proposedSolution'] ?? 'No solution proposed.',
      keyFeatures: List<String>.from(json['keyFeatures'] ?? []),
    );
  }
}