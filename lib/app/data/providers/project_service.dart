import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gdg_campus_connect/app/controllers/auth_controller.dart';
import 'package:gdg_campus_connect/app/data/models/project_model.dart';

class ProjectService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ProjectModel>> getProjectsStream() {
    return _firestore
        .collection('projects')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProjectModel.fromSnapshot(doc))
            .toList());
  }

  Future<void> createProject(Map<String, dynamic> projectData) async {
    final user = Get.find<AuthController>().user!;
    projectData['creatorId'] = user.uid;
    projectData['teamMembers'] = [user.uid];
    projectData['pendingMembers'] = [];
    projectData['createdAt'] = Timestamp.now();

    await _firestore.collection('projects').add(projectData);
  }
  
  Future<ProjectModel?> getProjectById(String id) async {
    final doc = await _firestore.collection('projects').doc(id).get();
    if(doc.exists) {
      return ProjectModel.fromSnapshot(doc);
    }
    return null;
  }

  Future<void> requestToJoinProject(String projectId) async {
    final user = Get.find<AuthController>().user!;
    final projectRef = _firestore.collection('projects').doc(projectId);

    await projectRef.update({
      'pendingMembers': FieldValue.arrayUnion([user.uid])
    });
  }
}