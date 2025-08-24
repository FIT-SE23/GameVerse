import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gameverse/ui/game_detail/view_model/game_details_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';

import 'package:gameverse/ui/settings/view_model/settings_viewmodel.dart';
import 'package:gameverse/data/services/game_download_service.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/data/repositories/game_repository.dart';
import 'package:dio/dio.dart';

// Define download states
enum DownloadState {
  notStarted,
  inProgress,
  canceled,
  completed,
}

class GameDownloadButton extends StatefulWidget {
  final GameModel game;

  const GameDownloadButton({
    super.key,
    required this.game,
  });

  @override
  State<GameDownloadButton> createState() => _GameDownloadButtonState();
}

class _GameDownloadButtonState extends State<GameDownloadButton> {
  DownloadState _downloadState = DownloadState.notStarted;
  bool _isInstalled = false;
  bool _isUninstalling = false;
  double _downloadProgress = 0.0;
  String _currentDownloadFile = '';
  GameModel get game => widget.game;
  final GameDownloadService _downloadService = GameDownloadService();
  CancelToken? _cancelToken;
  
  // Track downloaded files
  final Map<String, bool> _downloadedFiles = {};
  int _totalFiles = 0;
  int _completedFiles = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the game is already installed or if there was a previous download state
      _checkDownloadState(context);
    });
  }
  
  // Check if download was previously canceled
  Future<void> _checkDownloadState(BuildContext context) async {   
    final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
    final gameRepository = Provider.of<GameRepository>(context, listen: false);
    
    // Check if the game is installed
    String state = await gameRepository.checkDownloadState(
      settingsViewModel.downloadPath,
      widget.game,
    );
    if (state == 'completed') {
      setState(() {
        _downloadState = DownloadState.completed;
        _isInstalled = true;
      });
    } else if (state == 'partial') {
      final allUrls = [
        ...widget.game.binaries?.map((e) => e.url) ?? [],
        ...widget.game.exes?.map((e) => e.url) ?? []
      ];
      
      int completedFiles = 0;
      
      for (final url in allUrls) {
        final baseName = path.basename(url);
        final tokenIndex = baseName.indexOf('?token');
        final nameFile = tokenIndex != -1 ? baseName.substring(0, tokenIndex) : baseName;
        
        // If resuming, check if file exists
        final filePath = path.join(settingsViewModel.downloadPath, widget.game.gameId, nameFile);
        final exists = await File(filePath).exists();
        
        if (exists) {
          completedFiles++;
        }
      }
      setState(() {
        _downloadState = DownloadState.canceled;
        _completedFiles = completedFiles;
        _totalFiles = allUrls.length;
      });
    } else {
      setState(() {
        _downloadState = DownloadState.notStarted;
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_downloadState == DownloadState.inProgress) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _downloadProgress),
          const SizedBox(height: 8),
          Text(
            'Downloading $_currentDownloadFile... ${(_downloadProgress * 100).toStringAsFixed(1)}%',
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Cancel button to stop the download
          ElevatedButton(
            key: ValueKey('cancel_button'),
            onPressed: () {
              _cancelToken?.cancel('User canceled download');
              setState(() {
                _downloadState = DownloadState.canceled;
              });
            },
            child: const Text('Cancel Download'),
          ),
        ],
      );
    }

    if (_isUninstalling) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          Text(
            'Uninstalling...',
            style: theme.textTheme.bodySmall,
          ),
        ],
      );
    }

    if (_isInstalled) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                await _launchGame(context);
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play'),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _uninstallGame(context),
            icon: const Icon(Icons.delete),
            tooltip: 'Uninstall',
          ),
        ],
      );
    }

    // Show "Resume Download" button if download was canceled
    if (_downloadState == DownloadState.canceled) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _downloadProgress),
          const SizedBox(height: 8),
          Text(
            'Download paused ($_completedFiles/$_totalFiles files)',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: ValueKey('resume_button'),
                  onPressed: () => _resumeDownload(context),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Resume Download'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _uninstallGame(context),
                icon: const Icon(Icons.delete),
                tooltip: 'Delete partial download',
              ),
            ],
          ),
        ],
      );
    }

    // Default download button
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        key: ValueKey('downdload_button'),
        onPressed: widget.game.binaries?.isNotEmpty == true
            ? () => _downloadGame(context)
            : null,
        icon: const Icon(Icons.download),
        label: const Text('Download'),
      ),
    );
  }

  // Resume downloading the remaining files
  Future<void> _resumeDownload(BuildContext context) async {
    setState(() {
      _downloadState = DownloadState.inProgress;
    });
    
    // Get the list of remaining files to download
    await _downloadGame(context, resume: true);
  }

  Future<void> _downloadGame(BuildContext context, {bool resume = false}) async {
    final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
    final GameRepository gameRepository = Provider.of<GameRepository>(context, listen: false);
    
    if (widget.game.binaries?.isNotEmpty != true || widget.game.exes?.isNotEmpty != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download URL not available for this game'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // If application is on web, show a error message
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Downloading games is not supported on web'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _downloadState = DownloadState.inProgress;
      if (!resume) {
        _downloadProgress = 0.0;
        _currentDownloadFile = '';
        _downloadedFiles.clear();
        _completedFiles = 0;
      }
    });

    try {
      // Create game directory if it doesn't exist
      final gameDirPath = path.join(settingsViewModel.downloadPath, widget.game.gameId);
      final gameDir = Directory(gameDirPath);
      if (!await gameDir.exists()) {
        await gameDir.create(recursive: true);
      }
      
      // Combine all files to download
      final allUrls = [
        ...widget.game.binaries?.map((e) => e.url) ?? [],
        ...widget.game.exes?.map((e) => e.url) ?? []
      ];
      _totalFiles = allUrls.length;
      
      // Prepare list of files to download (all or only missing ones)
      final List<String> filesToDownload = [];
      final List<String> downloadUrls = [];
      
      for (final url in allUrls) {
        final baseName = path.basename(url);
        final tokenIndex = baseName.indexOf('?token');
        final nameFile = tokenIndex != -1 ? baseName.substring(0, tokenIndex) : baseName;
        
        // If resuming, check if file exists
        final filePath = path.join(gameDirPath, nameFile);
        final exists = await File(filePath).exists();
        
        if (!resume || !exists) {
          filesToDownload.add(nameFile);
          downloadUrls.add(url);
        } else {
          // File already exists
          _downloadedFiles[nameFile] = true;
          _completedFiles++;
        }
      }
      
      // Update progress before starting download
      setState(() {
        _downloadProgress = _completedFiles / _totalFiles;
      });
      
      // Cancel token for managing download cancellation
      _cancelToken = CancelToken();
      
      // Download each file
      for (int i = 0; i < downloadUrls.length; i++) {
        if (_cancelToken?.isCancelled ?? false) {
          // User canceled download
          break;
        }
        
        final url = downloadUrls[i];
        final nameFile = filesToDownload[i];
        
        setState(() {
          _currentDownloadFile = nameFile;
        });
        
        final success = await _downloadService.downloadGame(
          nameFile: nameFile,
          gameId: widget.game.gameId,
          downloadUrl: url,
          downloadPath: settingsViewModel.downloadPath,
          onProgress: (fileProgress) {
            setState(() {
              // Calculate total progress: (completed files + current file progress) / total files
              _downloadProgress = (_completedFiles + fileProgress) / _totalFiles;
            });
          },
          cancelToken: _cancelToken,
        );
        
        if (!success) {
          if (_cancelToken?.isCancelled ?? false) {
            // User canceled - just break the loop
            break;
          } else {
            throw Exception('Failed to download $nameFile');
          }
        }
        
        // Update progress for completed file
        _completedFiles++;
        _downloadedFiles[nameFile] = true;
        setState(() {
          _downloadProgress = _completedFiles / _totalFiles;
        });
      }
      
      // If all files downloaded successfully
      if (_completedFiles == _totalFiles) {
        if (context.mounted) {
          gameRepository.setGameInstallationPath(
            widget.game.gameId,
            path.join(settingsViewModel.downloadPath, widget.game.gameId),
          );
          
          // Update game state in repository
          bool isInstalled = await gameRepository.setGameInstallation(
            settingsViewModel.downloadPath,
            widget.game.gameId,
          );
          
          if (isInstalled && context.mounted) {
            setState(() {
              _downloadState = DownloadState.completed;
              _isInstalled = true;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Game downloaded successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Download completed but installation verification failed'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else if (_cancelToken?.isCancelled ?? false) {
        // Download was canceled by user
        setState(() {
          _downloadState = DownloadState.canceled;
        });
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Download paused. You can resume later.'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      setState(() {
        _downloadState = DownloadState.canceled;
      });
    } finally {
      _cancelToken = null;
      if (context.mounted) {
        // Reload game details to get updated state
        Provider.of<GameDetailsViewModel>(context, listen: false).loadGameDetails(
          widget.game.gameId,
          gamePath: path.join(settingsViewModel.downloadPath, widget.game.gameId),
        );
      }
    }
  }

  Future<void> _launchGame(BuildContext context) async {
    // Your existing _launchGame method remains the same
    final gameDetailsViewModel = Provider.of<GameDetailsViewModel>(context, listen: false);
    final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
    // Launch the game using the installed path
    final gamePath = await Provider.of<GameRepository>(context, listen: false)
        .checkGameInstallation(
          path.join(settingsViewModel.downloadPath, widget.game.gameId),
        );

    if (gamePath.isEmpty && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Game is not installed or installation path is missing'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Using process to launch the game
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Launching game...'),
          ),
        );
      }
      // Delay to ensure the snackbar is shown
      await Future.delayed(const Duration(milliseconds: 500));
      gameDetailsViewModel.setLastSessionStartTime(DateTime.now());
      gameDetailsViewModel.setGameProcess(
        await Process.start(gamePath, [], mode: ProcessStartMode.normal, runInShell: true)
      );
      gameDetailsViewModel.trackGameProcess().then((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Game session ended'),
            ),
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to launch game: $e'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
  }

  Future<void> _uninstallGame(BuildContext context) async {
    final gameRepository = Provider.of<GameRepository>(context, listen: false);
    final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
    final String title = _downloadState == DownloadState.canceled 
        ? 'Delete Partial Download' 
        : 'Uninstall Game';
        
    final String message = _downloadState == DownloadState.canceled
        ? 'Are you sure you want to delete the partially downloaded files for "${widget.game.name}"?'
        : 'Are you sure you want to uninstall "${widget.game.name}"?\n\nThis will permanently delete all game files.';
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(_downloadState == DownloadState.canceled ? 'Delete' : 'Uninstall'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isUninstalling = true;
    });

    try {
      if (context.mounted) {
        await _safeDeleteGame(context);
        // Reset download state
        setState(() {
          _downloadState = DownloadState.notStarted;
          _downloadedFiles.clear();
          _completedFiles = 0;
          _totalFiles = 0;
        });
        
        // Try to update the game installation status
        bool isInstalled = await gameRepository.setGameInstallation(
          settingsViewModel.downloadPath,
          widget.game.gameId,
        );
        
        if (context.mounted && !isInstalled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_downloadState == DownloadState.canceled 
                  ? 'Partial download deleted successfully' 
                  : 'Game uninstalled successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Uninstall error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Uninstall error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          _isUninstalling = false;
        });
        // Reload game details to get updated state
        Provider.of<GameDetailsViewModel>(context, listen: false).loadGameDetails(widget.game.gameId);
      }
    }
  }

  Future<void> _safeDeleteGame(BuildContext context) async {
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 1);
    final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
    
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        await _downloadService.deleteGame(widget.game.gameId, settingsViewModel.downloadPath);
        return; // Success
      } catch (e) {
        debugPrint('Delete attempt ${attempt + 1} failed: $e');
        
        if (attempt < maxRetries - 1) {
          // Wait before retrying
          await Future.delayed(retryDelay);
        } else {
          // Last attempt failed, rethrow the error
          rethrow;
        }
      }
    }
  }
}