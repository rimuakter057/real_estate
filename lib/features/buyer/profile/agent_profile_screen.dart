import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/state/app_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../shared/mock_data/mock_agents.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/agent_model.dart';
import '../../../shared/widgets/property_card.dart';

class AgentProfileScreen extends StatelessWidget {
  const AgentProfileScreen({super.key, required this.agentId});
  final String agentId;

  @override
  Widget build(BuildContext context) {
    final agent = MockAgents.all.firstWhere((a) => a.id == agentId, orElse: () => MockAgents.sofia);
    final listings = MockProperties.byAgent(agent.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Agent Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipOval(child: CachedNetworkImage(imageUrl: agent.avatarUrl, height: 96, width: 96, fit: BoxFit.cover)),
                    if (agent.verification == VerificationStatus.verified)
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(radius: 13, backgroundColor: AppColors.success, child: Icon(Icons.check_rounded, color: Colors.white, size: 16)),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(agent.name, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 2),
                Text(agent.title, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(agent.company, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(
              children: [
                Expanded(child: _stat(context, '${agent.rating}', 'Rating', Icons.star_rounded)),
                Expanded(child: _stat(context, '${agent.reviewsCount}', 'Reviews', Icons.reviews_outlined)),
                Expanded(child: _stat(context, '${agent.propertiesCount}', 'Listings', Icons.apartment_rounded)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('About', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(agent.about, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Call',
                  icon: Icons.call_outlined,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                      title: Text('Call ${agent.name}'),
                      content: Text(agent.phone),
                      actions: [
                        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
                        FilledButton(onPressed: () => context.pop(), child: const Text('Call')),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: 'Message',
                  icon: Icons.chat_bubble_outline_rounded,
                  onPressed: () => context.push(RoutePaths.buyerChatDetail('c1')),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Listings by ${agent.name.split(' ').first}', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          if (listings.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(child: Text('No active listings right now.', style: Theme.of(context).textTheme.bodyMedium)),
            )
          else
            SizedBox(
              height: 360,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: listings.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) => SizedBox(
                  width: 240,
                  child: AnimatedBuilder(
                    animation: AppSession.instance,
                    builder: (context, _) => PropertyCard(
                      property: listings[i],
                      isFavorite: AppSession.instance.isFavorite(listings[i].id),
                      onFavoriteToggle: () => AppSession.instance.toggleFavorite(listings[i].id),
                      onTap: () => context.push(RoutePaths.buyerPropertyDetails(listings[i].id)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
