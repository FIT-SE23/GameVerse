import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class GameDownloadService {
  final Dio _dio;
  CancelToken? _currentCancelToken;
  
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
      _currentCancelToken = cancelToken;
      final gameDir = Directory(path.join(downloadPath, gameId));
      if (!await gameDir.exists()) {
        await gameDir.create(recursive: true);
      }
      final filePath = path.join(gameDir.path, nameFile);
      
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
      // Check if the error is due to user cancellation
      if (e is DioException && e.type == DioExceptionType.cancel) {
        debugPrint('Download was canceled by user');
        return false;
      }
      debugPrint('Download error: $e');
      return false;
    }
  }
  
  // Method to cancel current download
  void cancelDownload() {
    _currentCancelToken?.cancel('User canceled download');
    _currentCancelToken = null;
  }

  
  Future<void> deleteGame(String gameId, String downloadPath) async {
    final gameDir = Directory(path.join(downloadPath, gameId));
    debugPrint('Deleting game directory: ${gameDir.path}');
    if (await gameDir.exists()) {
      await gameDir.delete(recursive: true);
    }
  }
}