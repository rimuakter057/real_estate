import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_agents.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/agent_model.dart';
import '../../../shared/widgets/property_card.dart';
import '../../../core/state/app_session.dart';

class AgentDetailsScreen extends StatefulWidget {
  const AgentDetailsScreen({super.key, required this.agentId});
  final String agentId;

  @override
  State<AgentDetailsScreen> createState() => _AgentDetailsScreenState();
}

class _AgentDetailsScreenState extends State<AgentDetailsScreen> {
  late var _agent = MockAgents.all.firstWhere((a) => a.id == widget.agentId, orElse: () => MockAgents.sofia);

  @override
  Widget build(BuildContext context) {
    final listings = MockProperties.byAgent(_agent.id);
    return Scaffold(
      appBar: AppBar(title: const Text('Agent Details')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Column(
              children: [
                AppAvatar(imageUrl: _agent.avatarUrl, size: 88),
                const SizedBox(height: AppSpacing.sm),
                Text(_agent.name, style: Theme.of(context).textTheme.headlineSmall),
                Text(_agent.title, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  StatusChip(
                    status: _agent.verification == VerificationStatus.verified ? AppStatus.verified : AppStatus.pending,
                    label: _agent.verification == VerificationStatus.verified ? 'Verified' : 'Pending Verification',
                  ),
                  const SizedBox(width: 6),
                  StatusChip(status: _agent.active ? AppStatus.active : AppStatus.rejected, label: _agent.active ? 'Active' : 'Deactivated'),
                ]),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.lightSurfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(
              children: [
                Expanded(child: _stat(context, '${listings.length}', 'Properties')),
                Expanded(child: _stat(context, '${_agent.rating}', 'Rating')),
                Expanded(child: _stat(context, '${_agent.reviewsCount}', 'Reviews')),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Contact Information', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          _row(context, Icons.mail_outline_rounded, 'Email', _agent.email),
          _row(context, Icons.phone_outlined, 'Phone', _agent.phone),
          _row(context, Icons.apartment_outlined, 'Company', _agent.company),
          const SizedBox(height: AppSpacing.xl),
          Text('Verification & Access', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              if (_agent.verification != VerificationStatus.verified)
                Expanded(
                  child: PrimaryButton(
                    label: 'Verify Agent',
                    icon: Icons.verified_outlined,
                    onPressed: () async {
                      final confirm = await AppDialogs.confirm(context, title: 'Verify Agent', message: 'Mark ${_agent.name} as a verified agent?');
                      if (confirm) {
                        setState(() => _agent = _agent.copyWith(verification: VerificationStatus.verified));
                        if (mounted) AppDialogs.success(context, 'Agent verified successfully');
                      }
                    },
                  ),
                ),
              if (_agent.verification != VerificationStatus.verified) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _agent.active
                    ? SecondaryButton(
                        label: 'Deactivate',
                        icon: Icons.block_rounded,
                        onPressed: () async {
                          final confirm = await AppDialogs.confirm(context, title: 'Deactivate Agent', message: 'This will hide all of ${_agent.name}\'s listings.', destructive: true, confirmLabel: 'Deactivate');
                          if (confirm) {
                            setState(() => _agent = _agent.copyWith(active: false));
                            if (mounted) AppDialogs.success(context, 'Agent deactivated');
                          }
                        },
                      )
                    : PrimaryButton(
                        label: 'Activate',
                        icon: Icons.check_circle_outline_rounded,
                        onPressed: () {
                          setState(() => _agent = _agent.copyWith(active: true));
                          AppDialogs.success(context, 'Agent activated');
                        },
                      ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Listings', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          if (listings.isEmpty)
            Padding(padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg), child: Text('No listings yet.', style: Theme.of(context).textTheme.bodyMedium))
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
                      onTap: () => context.push(RoutePaths.adminPropertyDetails(listings[i].id)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Column(children: [
      Text(value, style: Theme.of(context).textTheme.titleMedium),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }

  Widget _row(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.grey500),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
