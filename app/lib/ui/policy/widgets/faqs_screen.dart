import 'package:flutter/material.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    'Frequently Asked Questions',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 32),
                  
                  _buildFaqSection(
                    context,
                    title: 'Account & Registration',
                    faqs: [
                      {
                        'question': 'How do I create a GameVerse account?',
                        'answer': 'You can create a GameVerse account by clicking the "Register" button on the top right of the homepage. You\'ll need to provide a valid email address, create a password, and verify your email address.'
                      },
                      {
                        'question': 'Can I use GameVerse without creating an account?',
                        'answer': 'You can browse games without an account, but you\'ll need to create one to download or play games on the platform.'
                      },
                      {
                        'question': 'How do I become a publisher?',
                        'answer': 'You can register as a publisher by selecting the "Publisher" option during registration. You\'ll need to provide additional information about your company and agree to our Publisher Policy.'
                      },
                      {
                        'question': 'I forgot my password. What should I do?',
                        'answer': 'Click on the "Forgot Password" link on the login page, enter your email address, and follow the instructions sent to your email to reset your password.'
                      },
                    ],
                  ),
                  
                  _buildFaqSection(
                    context,
                    title: 'Games & Downloads',
                    faqs: [
                      {
                        'question': 'How do I download games?',
                        'answer': 'After logging in, navigate to a game\'s detail page and click the "Download" button. The game will be downloaded to the location specified in your settings.'
                      },
                      {
                        'question': 'Can I pause and resume downloads?',
                        'answer': 'Yes, you can pause downloads by clicking the "Cancel" button during download. To resume, simply click "Resume Download" on the game\'s page.'
                      },
                      {
                        'question': 'How do I uninstall a game?',
                        'answer': 'Go to the game\'s detail page and click the trash icon next to the "Play" button. Confirm the uninstallation when prompted.'
                      },
                      {
                        'question': 'What happens to my saved games if I uninstall?',
                        'answer': 'Game save data is typically stored separately from the game files. Uninstalling a game usually doesn\'t remove your save files, but this can vary by game.'
                      },
                    ],
                  ),
                  
                  _buildFaqSection(
                    context,
                    title: 'Publishers & Developers',
                    faqs: [
                      {
                        'question': 'How do I submit a game to GameVerse?',
                        'answer': 'After registering as a publisher, you can submit games through the Publisher Dashboard. You\'ll need to provide game details, upload files, and set pricing information.'
                      },
                      {
                        'question': 'How long does the approval process take?',
                        'answer': 'Game submissions are typically reviewed within 3-5 business days. You\'ll receive a notification once your game has been approved or if any changes are needed.'
                      },
                      {
                        'question': 'What are the revenue sharing terms?',
                        'answer': 'GameVerse offers a 70/30 split, where publishers receive 70% of the revenue from their games. Payments are processed monthly for balances over the minimum threshold.'
                      },
                      {
                        'question': 'Can I update my game after it\'s published?',
                        'answer': 'Yes, you can submit updates through the Publisher Dashboard. Updates go through a review process similar to initial submissions but typically faster.'
                      },
                    ],
                  ),
                  
                  _buildFaqSection(
                    context,
                    title: 'Technical Support',
                    faqs: [
                      {
                        'question': 'What are the system requirements for GameVerse?',
                        'answer': 'GameVerse client requires Windows 10 or newer, macOS 10.15 or newer, or a modern web browser for the web version. Individual games may have additional requirements.'
                      },
                      {
                        'question': 'The game I downloaded won\'t start. What should I do?',
                        'answer': 'First, verify your system meets the game\'s requirements. Try restarting the GameVerse client, or reinstalling the game. If problems persist, contact our support team.'
                      },
                      {
                        'question': 'How do I report a bug?',
                        'answer': 'You can report bugs through the "Help & Support" section in the app, or by clicking the Support button in the top navigation bar.'
                      },
                      {
                        'question': 'Can I use GameVerse on multiple devices?',
                        'answer': 'Yes, you can use your GameVerse account on multiple devices. Your library and purchases will be available across all your devices.'
                      },
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Still have questions?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to contact or support
                            Navigator.of(context).pushNamed('/support');
                          },
                          icon: const Icon(Icons.support_agent),
                          label: const Text('Contact Support'),
                        ),
                      ],
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

  Widget _buildFaqSection(
    BuildContext context, {
    required String title,
    required List<Map<String, String>> faqs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        ...faqs.map((faq) => _buildFaqItem(context, faq)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFaqItem(BuildContext context, Map<String, String> faq) {
    return ExpansionTile(
      title: Text(
        faq['question'] ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(faq['answer'] ?? ''),
        ),
      ],
    );
  }
}