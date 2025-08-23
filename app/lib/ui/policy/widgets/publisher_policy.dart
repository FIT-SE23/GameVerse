import 'package:flutter/material.dart';

class PublisherPolicyScreen extends StatelessWidget {
  const PublisherPolicyScreen({super.key});

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
                  Text(
                    'Publisher Policy Agreement',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last Updated: August 23, 2025',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Introduction
                  _buildSectionTitle(context, 'Introduction'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    'This Publisher Policy Agreement ("Agreement") is entered into between GameVerse ("Platform") and you as a Publisher '
                    '("Publisher"). By registering as a Publisher on GameVerse, you acknowledge that you have read, understood, '
                    'and agree to comply with all terms and conditions outlined in this Agreement.'
                  ),
                  _buildParagraph(
                    'GameVerse aims to provide a platform where game developers can distribute their games to players '
                    'worldwide while maintaining high standards of quality, security, and ethical conduct. This Agreement '
                    'outlines the responsibilities, rights, and obligations of Publishers using our platform.'
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Eligibility
                  _buildSectionTitle(context, '1. Eligibility'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '1.1. Publishers must be at least 18 years of age or the legal age of majority in their jurisdiction, whichever is higher.'
                  ),
                  _buildParagraph(
                    '1.2. Publishers must have the legal right to enter into contracts in their jurisdiction.'
                  ),
                  _buildParagraph(
                    '1.3. Publishers must provide accurate and complete information during the registration process.'
                  ),
                  _buildParagraph(
                    '1.4. GameVerse reserves the right to verify Publisher identity through appropriate documentation.'
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Application and Approval Process
                  _buildSectionTitle(context, '2. Application and Approval Process'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '2.1. All Publisher applications are subject to review by GameVerse Operators.'
                  ),
                  _buildParagraph(
                    '2.2. The review process typically takes 3-5 business days but may vary depending on volume.'
                  ),
                  _buildParagraph(
                    '2.3. GameVerse may request additional information or documentation to verify your identity or qualifications.'
                  ),
                  _buildParagraph(
                    '2.4. Approval as a Publisher does not guarantee approval of individual game submissions.'
                  ),
                  _buildParagraph(
                    '2.5. GameVerse reserves the right to deny Publisher status at its sole discretion.'
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Operator Review Process
                  _buildSectionTitle(context, '3. Operator Review Process'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '3.1. GameVerse Operators are responsible for reviewing all Publisher applications and game submissions.'
                  ),
                  _buildParagraph(
                    '3.2. Operators will evaluate applications based on the following criteria:'
                  ),
                  _buildBulletPoints([
                    'Completeness and accuracy of provided information',
                    'Professional history and experience in game development',
                    'Quality of previous work (if applicable)',
                    'Compliance with legal and ethical standards',
                    'Alignment with GameVerse\'s values and objectives'
                  ]),
                  _buildParagraph(
                    '3.3. Operators may approve, reject, or request modifications to Publisher applications.'
                  ),
                  _buildParagraph(
                    '3.4. Decisions are made on a case-by-case basis, and Operators maintain detailed records of their review process.'
                  ),
                  _buildParagraph(
                    '3.5. Operators follow strict guidelines to ensure fair and consistent evaluation of all applications.'
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Acceptance Terms
                  _buildSectionTitle(context, '4. Acceptance Terms'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '4.1. Upon acceptance as a Publisher:'
                  ),
                  _buildBulletPoints([
                    'You will gain access to the Publisher Dashboard',
                    'You can submit games for review and distribution on GameVerse',
                    'You will receive credentials for the GameVerse Developer API (if applicable)',
                    'You will be eligible for revenue sharing as outlined in Section 7',
                    'You will have access to analytics and reporting tools for your published content'
                  ]),
                  _buildParagraph(
                    '4.2. Acceptance as a Publisher constitutes a business relationship, not an employment relationship.'
                  ),
                  _buildParagraph(
                    '4.3. GameVerse will notify you of acceptance via the email provided during registration.'
                  ),
                  _buildParagraph(
                    '4.4. You must complete any required tax or payment documentation within 30 days of acceptance.'
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Rejection Terms
                  _buildSectionTitle(context, '5. Rejection Terms'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '5.1. Common reasons for application rejection include but are not limited to:'
                  ),
                  _buildBulletPoints([
                    'Incomplete or inaccurate application information',
                    'History of policy violations on other platforms',
                    'Insufficient evidence of game development experience',
                    'Concerns regarding content type or quality based on portfolio',
                    'Suspected fraudulent activity or misrepresentation'
                  ]),
                  _buildParagraph(
                    '5.2. If your application is rejected, you will receive a notification explaining the primary reason(s).'
                  ),
                  _buildParagraph(
                    '5.3. You may appeal a rejection by submitting additional information or clarification through our appeal form.'
                  ),
                  _buildParagraph(
                    '5.4. After rejection, you must wait at least 30 days before submitting a new application, unless otherwise specified.'
                  ),
                  _buildParagraph(
                    '5.5. Repeated rejections may result in a longer waiting period before you can reapply.'
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Content Requirements
                  _buildSectionTitle(context, '6. Content Requirements'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '6.1. Publishers must ensure all submitted content:'
                  ),
                  _buildBulletPoints([
                    'Does not infringe upon intellectual property rights of others',
                    'Does not contain malicious code, malware, or viruses',
                    'Complies with all applicable laws and regulations',
                    'Is accurately described and rated appropriately for its content',
                    'Does not promote hatred, violence, discrimination, or illegal activities',
                    'Does not contain sexually explicit content without appropriate age verification',
                    'Respects user privacy and data security'
                  ]),
                  _buildParagraph(
                    '6.2. Publishers must provide accurate metadata, screenshots, and descriptions for all games.'
                  ),
                  _buildParagraph(
                    '6.3. All games must include appropriate age ratings using recognized systems (ESRB, PEGI, etc.).'
                  ),
                  _buildParagraph(
                    '6.4. GameVerse reserves the right to reject or remove any content that violates these requirements.'
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Revenue Sharing
                  _buildSectionTitle(context, '7. Revenue Sharing'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '7.1. GameVerse operates on a revenue sharing model with the following standard terms:'
                  ),
                  _buildBulletPoints([
                    '70% of net revenue to Publisher',
                    '30% of net revenue to GameVerse'
                  ]),
                  _buildParagraph(
                    '7.2. Net revenue is defined as the gross revenue from sales, minus applicable taxes, payment processing fees, '
                    'chargebacks, refunds, and any platform fees where applicable.'
                  ),
                  _buildParagraph(
                    '7.3. Payment will be made monthly for balances exceeding \$50 USD. Balances below this threshold '
                    'will roll over to the following month until the threshold is reached.'
                  ),
                  _buildParagraph(
                    '7.4. Publishers are responsible for any taxes applicable in their jurisdiction.'
                  ),
                  _buildParagraph(
                    '7.5. GameVerse reserves the right to withhold payment if fraud or policy violations are suspected '
                    'pending investigation.'
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Term and Termination
                  _buildSectionTitle(context, '8. Term and Termination'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '8.1. This Agreement remains in effect until terminated by either party.'
                  ),
                  _buildParagraph(
                    '8.2. Publishers may terminate this Agreement with 30 days written notice to GameVerse.'
                  ),
                  _buildParagraph(
                    '8.3. GameVerse may terminate this Agreement immediately if:'
                  ),
                  _buildBulletPoints([
                    'Publisher violates any terms of this Agreement',
                    'Publisher submits fraudulent or malicious content',
                    'Publisher engages in deceptive practices or misrepresentation',
                    'Required by law or legal action',
                    'GameVerse ceases operations or undergoes significant restructuring'
                  ]),
                  _buildParagraph(
                    '8.4. Upon termination:'
                  ),
                  _buildBulletPoints([
                    'Publisher content may be removed from the platform',
                    'Publisher access to the dashboard will be revoked',
                    'Final payment of any outstanding balance will be processed according to the regular payment schedule',
                    'Publisher must cease using all GameVerse assets and intellectual property'
                  ]),
                  
                  const SizedBox(height: 24),
                  
                  // Operator Responsibilities
                  _buildSectionTitle(context, '9. Operator Responsibilities'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '9.1. GameVerse Operators are responsible for:'
                  ),
                  _buildBulletPoints([
                    'Reviewing Publisher applications fairly and consistently',
                    'Evaluating game submissions for compliance with platform policies',
                    'Maintaining communication with Publishers regarding application status',
                    'Providing clear reasons for rejections when applicable',
                    'Reviewing appeals and reconsiderations',
                    'Monitoring published content for ongoing compliance',
                    'Addressing user reports regarding Publisher content'
                  ]),
                  _buildParagraph(
                    '9.2. Operators commit to reviewing applications within the stated timeframe.'
                  ),
                  _buildParagraph(
                    '9.3. Operators will maintain confidentiality of all Publisher information.'
                  ),
                  _buildParagraph(
                    '9.4. Operators are prohibited from discriminating against applications based on factors not relevant to platform policies.'
                  ),
                  _buildParagraph(
                    '9.5. Operators are subject to regular audits to ensure fair application of policies.'
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Dispute Resolution
                  _buildSectionTitle(context, '10. Dispute Resolution'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '10.1. In case of disputes regarding application decisions or policy interpretations:'
                  ),
                  _buildBulletPoints([
                    'Publishers may submit a formal appeal through the designated appeal form',
                    'Appeals will be reviewed by a different Operator than the one who made the initial decision',
                    'A final decision will be provided within 14 business days of appeal submission',
                    'Serious disputes may be escalated to senior management for review'
                  ]),
                  _buildParagraph(
                    '10.2. For payment or technical disputes, Publishers should contact publisher-support@gameverse.com.'
                  ),
                  _buildParagraph(
                    '10.3. For legal disputes, arbitration will be conducted according to the terms in the general Terms of Service.'
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Amendments
                  _buildSectionTitle(context, '11. Amendments'),
                  const SizedBox(height: 16),
                  _buildParagraph(
                    '11.1. GameVerse reserves the right to amend this Agreement at any time.'
                  ),
                  _buildParagraph(
                    '11.2. Publishers will be notified of material changes at least 30 days in advance.'
                  ),
                  _buildParagraph(
                    '11.3. Continued use of the platform after amendments constitutes acceptance of the new terms.'
                  ),
                  _buildParagraph(
                    '11.4. If a Publisher does not agree with the amendments, they may terminate this Agreement as outlined in Section 8.'
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Conclusion
                  _buildParagraph(
                    'By checking "I agree to the Publisher Policy" during registration, you acknowledge that you have read, '
                    'understood, and agree to be bound by all terms and conditions outlined in this Agreement.',
                    isBold: true,
                  ),
                  
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Have questions about our Publisher Policy?',
                          style: TextStyle(
                            fontSize: 16,
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildParagraph(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: points.map((point) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(point)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}