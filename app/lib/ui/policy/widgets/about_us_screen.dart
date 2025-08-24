import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero section
                  Center(
                    child: Column(
                      children: [
                        if (Theme.brightnessOf(context) == Brightness.dark)
                          SvgPicture.asset(
                            'assets/logo/logo_vertical_white.svg',
                            width: 200,
                          )
                        else
                          SvgPicture.asset(
                            'assets/logo/logo_vertical_black.svg',
                            width: 200,
                          ),
                        const SizedBox(height: 24),
                        Text(
                          'Redefining Game Distribution',
                          style: theme.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Building a vibrant community for gamers and developers since 2025',
                          style: theme.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Our story
                  Text(
                    'Our Story',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'GameVerse was founded with a simple yet powerful vision: to create a platform where game developers and players could connect without barriers. '
                    'In an industry dominated by a few major platforms, we saw the need for a more open, transparent, and developer-friendly alternative.\n\n'
                    'Started by a small team of passionate gamers and developers in 2024, GameVerse has grown into a thriving marketplace for indie and mainstream games alike. '
                    'We believe that great games deserve to be discovered, and talented developers deserve fair compensation for their work.',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Mission & Values
                  Text(
                    'Our Mission',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMissionItem(
                    context,
                    icon: Icons.handshake,
                    title: 'Fair Revenue Sharing',
                    description: 'We offer one of the most competitive revenue splits in the industry, ensuring developers are properly rewarded for their creativity and hard work.',
                  ),
                  _buildMissionItem(
                    context,
                    icon: Icons.visibility,
                    title: 'Transparency',
                    description: 'We believe in being open about our policies, review process, and revenue sharing. No hidden fees or surprise changes.',
                  ),
                  _buildMissionItem(
                    context,
                    icon: Icons.diversity_3,
                    title: 'Community Focus',
                    description: 'We\'re building more than a store—we\'re fostering a community where players and developers can connect, share feedback, and collaborate.',
                  ),
                  _buildMissionItem(
                    context,
                    icon: Icons.auto_awesome,
                    title: 'Quality Over Quantity',
                    description: 'While we welcome games of all types and sizes, we maintain quality standards to ensure players find experiences worth their time and money.',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Team section
                  Text(
                    'Our Team',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildTeamMember(
                        context,
                        name: 'Châu Đình Phúc',
                        role: 'CEO & Co-Founder',
                        bio: 'Former game developer with a passion for indie games and fair distribution models.',
                      ),
                      _buildTeamMember(
                        context,
                        name: 'Nguyễn Đình Mạnh',
                        role: 'CTO & Co-Founder',
                        bio: 'Technology expert with background in platform development and cloud architecture.',
                      ),
                      _buildTeamMember(
                        context,
                        name: 'Nguyễn Trọng Nhân',
                        role: 'Head of Developer Relations & Co-Founder',
                        bio: 'Helping developers navigate the platform and maximize their success.',
                      ),
                      _buildTeamMember(
                        context,
                        name: 'Nguyễn Đức Khương Lam',
                        role: 'Community Header & Co-Founder',
                        bio: 'Building bridges between players and developers to create a vibrant ecosystem.',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Contact info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Get in Touch',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Icon(Icons.email),
                              SizedBox(width: 8),
                              Text('contact@gameverse.com'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(width: 8),
                              Text('123 Game Street, Digital City, GV 12345'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Icon(Icons.public),
                              SizedBox(width: 8),
                              Text('www.gameverse.com'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
    BuildContext context, {
    required String name,
    required String role,
    required String bio,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                name.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              role,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}