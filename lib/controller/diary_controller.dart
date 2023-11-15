import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/model/diary_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DiaryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addDiary(DiaryModel diary, {File? imageFile}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String imageURL = '';
        if (imageFile != null) {
          imageURL = await _uploadImage(user.uid, diary.id, imageFile);
        }
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('entries')
            .doc(diary.id)
            .set({
          'date': diary.date,
          'description': diary.description,
          'rating': diary.rating,
          'imageURL': imageURL,
        });
        return;
      }
    } catch (e) {
      print('Error adding diary entry: $e');
    }
  }

  Future<String> _uploadImage(
      String userId, String diaryId, File imageFile) async {
    try {
      final ref =
          _storage.ref().child('users/$userId/diaryImages/$diaryId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<List<DiaryModel>> listDiaryEntries() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final entries = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('entries')
          .get();
      return entries.docs.map((doc) {
        final data = doc.data();
        return DiaryModel(
          id: doc.id,
          date: data['date'] ?? '',
          description: data['description'] ?? '',
          rating: data['rating'] ?? 1,
          imageURL: data['imageURL'] ?? '', // Retrieve image URL
        );
      }).toList();
    }
    return [];
  }

  Future<void> deleteDiary(String entryId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('entries')
          .doc(entryId)
          .delete();
    }
  }
}
