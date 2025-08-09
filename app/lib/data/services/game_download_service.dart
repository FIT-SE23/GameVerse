import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class GameDownloadService {
  final Dio _dio;
  
  GameDownloadService() : _dio = Dio();

  Future<bool> downloadGame({
    required String nameFile,
    required String gameId,
    required String downloadUrl,
    required String downloadPath,
    required Function(double) onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final gameDir = Directory(path.join(downloadPath, gameId));
      if (!await gameDir.exists()) {
        await gameDir.create(recursive: true);
      }
      final filePath = path.join(gameDir.path, nameFile);
    
      debugPrint('Downloading to: $filePath');
      debugPrint('Download URL: $downloadUrl');
      
      await _dio.download(
        downloadUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            onProgress(progress);
          }
        },
        cancelToken: cancelToken,
      );

      return true;
    } catch (e) {
      debugPrint('Download error: $e');
      return false;
    }
  }

  Future<List<String>> getGameExecutables(String gameId, String downloadPath) async {
    final gameDir = Directory(path.join(downloadPath, gameId));
    if (!await gameDir.exists()) return [];

    final executables = <String>[];
    await for (final entity in gameDir.list(recursive: true)) {
      if (entity is File) {
        final extension = path.extension(entity.path).toLowerCase();
        if (extension == '.exe' || extension == '.app' || extension == '.deb') {
          executables.add(entity.path);
        }
      }
    }

    return executables;
  }

  Future<void> deleteGame(String gameId, String downloadPath) async {
    final gameDir = Directory(path.join(downloadPath, gameId));
    if (await gameDir.exists()) {
      await gameDir.delete(recursive: true);
    }
  }
}