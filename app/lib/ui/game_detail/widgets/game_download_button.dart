import 'package:flutter/material.dart';
import 'package:gameverse/ui/game_detail/view_model/game_details_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import 'package:gameverse/ui/settings/view_model/settings_viewmodel.dart';
import 'package:gameverse/data/services/game_download_service.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/data/repositories/game_repository.dart';

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
  bool _isDownloading = false;
  bool _isInstalled = false;
  bool _isUninstalling = false;
  double _downloadProgress = 0.0;
  String _currentDownloadFile = '';
  GameModel get game => widget.game;
  final GameDownloadService _downloadService = GameDownloadService();
  final settingsViewModel = SettingsViewModel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _isInstalled = game.isInstalled;
    
    if (_isDownloading) {
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
              onPressed: () => _launchGame(context),
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

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.game.binaries?.isNotEmpty == true
            ? () => _downloadGame(context)
            : null,
        icon: const Icon(Icons.download),
        label: const Text('Download'),
      ),
    );
  }

  Future<void> _downloadGame(BuildContext context) async {
    if (widget.game.binaries?.isNotEmpty != true || widget.game.exes?.isNotEmpty != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download URL not available for this game'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _currentDownloadFile = '';
    });

    try {
      // Combine all files to download
      final downloadUrls = [...widget.game.binaries!, ...widget.game.exes!];
      final numFiles = downloadUrls.length;
      
      for (int i = 0; i < numFiles; i++) {
        final downloadUrl = downloadUrls[i];
        final baseName = path.basename(downloadUrl);
        
        // Clean filename by removing token parameters
        final tokenIndex = baseName.indexOf('?token');
        String nameFile = baseName;
        if (tokenIndex != -1) {
          nameFile = baseName.substring(0, tokenIndex);
        }
        
        setState(() {
          _currentDownloadFile = nameFile;
        });

        final success = await _downloadService.downloadGame(
          nameFile: nameFile,
          gameId: widget.game.gameId,
          downloadUrl: downloadUrl,
          downloadPath: settingsViewModel.downloadPath,
          onProgress: (fileProgress) {
            setState(() {
              // Calculate total progress: completed files + current file progress
              _downloadProgress = (i + fileProgress) / numFiles;
            });
          },
        );

        if (!success) {
          throw Exception('Failed to download $nameFile');
        }
        
        // Update progress for completed file
        setState(() {
          _downloadProgress = (i + 1) / numFiles;
        });
      }

      if (context.mounted) {
        final GameRepository gameRepository = Provider.of<GameRepository>(context, listen: false);
        gameRepository.setGameInstallationPath(
          widget.game.gameId,
          path.join(settingsViewModel.downloadPath, widget.game.gameId),
        );
        
        // Update game state in repository
        bool isInstalled = await gameRepository.setGameInstallation(widget.game.gameId);

        if (isInstalled && context.mounted) {
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
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          _isDownloading = false;
          _currentDownloadFile = '';
          // Only set installed if we successfully verified installation
        });
        // Reload game details to get updated state
        Provider.of<GameDetailsViewModel>(context, listen: false).loadGameDetails(widget.game.gameId);
      }
    }
  }

  void _launchGame(BuildContext context) {
    // Implementation for launching the game
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Launching game...'),
      ),
    );
  }

  Future<void> _uninstallGame(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Uninstall Game'),
        content: Text('Are you sure you want to uninstall "${widget.game.name}"?\n\nThis will permanently delete all game files.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Uninstall'),
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
        final GameRepository gameRepository = Provider.of<GameRepository>(context, listen: false);
        
        // First, update the game state in repository to mark as uninstalled
        // This prevents other processes from accessing the files
        await gameRepository.setGameInstallation(widget.game.gameId);
        
        // Small delay to ensure any file handles are released
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Try to delete the game directory
        await _safeDeleteGame();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Game uninstalled successfully'),
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

  Future<void> _safeDeleteGame() async {
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 1);
    
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