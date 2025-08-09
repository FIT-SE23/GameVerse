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
  double _downloadProgress = 0.0;
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
            'Downloading... ${(_downloadProgress * 100).toStringAsFixed(1)}%',
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
    });

    try {
      // final downloadUrl = widget.game.binaries!.first;
      // final success = await _downloadService.downloadGame(
      //   gameId: widget.game.gameId,
      //   downloadUrl: downloadUrl,
      //   downloadPath: settingsViewModel.downloadPath,
      //   onProgress: (progress) {
      //     setState(() {
      //       _downloadProgress = progress;
      //     });
      //   },
      // );
      // We download all binaries and executables
      final numFiles = widget.game.binaries!.length + widget.game.exes!.length;
      final downloadUrls = [...widget.game.binaries!, ...widget.game.exes!];
      for (int i = 0; i < numFiles; i++) {
        final downloadUrl = downloadUrls[i];
        final baseName = path.basename(downloadUrl);
        // Get name until the first string 'token' appear
        final tokenIndex = baseName.indexOf('?token');
        String nameFile = baseName;
        if (tokenIndex != -1) {
          nameFile = baseName.substring(0, tokenIndex);
        }
        final success = await _downloadService.downloadGame(
          nameFile: nameFile,
          gameId: widget.game.gameId,
          downloadUrl: downloadUrl,
          downloadPath: settingsViewModel.downloadPath,
          onProgress: (progress) {
            setState(() {
              _downloadProgress = (i + progress) / numFiles;
            });
          },
        );

        if (!success) {
          throw Exception('Failed to download $nameFile');
        }
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
              content: Text('Download failed'),
              backgroundColor: Colors.red,
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
          _isInstalled = true;
        });
          // Reload game details
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
        content: Text('Are you sure you want to uninstall "${widget.game.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Uninstall'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
      await _downloadService.deleteGame(widget.game.gameId, settingsViewModel.downloadPath);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Game uninstalled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}