import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/mock_data/mock_agents.dart';
import '../../../shared/mock_data/mock_properties.dart';
import '../../../shared/models/agent_model.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    var agents = MockAgents.all;
    if (_query.isNotEmpty) {
      agents = agents.where((a) => a.name.toLowerCase().contains(_query.toLowerCase())).toList();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Agents')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSearchField(hint: 'Search agents by name', onChanged: (v) => setState(() => _query = v)),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: agents.isEmpty
                  ? const EmptyState(icon: Icons.badge_outlined, title: 'No Agents Found', message: 'Try a different search term.')
                  : ListView.separated(
                      itemCount: agents.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) => _agentTile(context, agents[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _agentTile(BuildContext context, AgentModel agent) {
    final count = MockProperties.byAgent(agent.id).length;
    return GestureDetector(
      onTap: () => context.push(RoutePaths.adminAgentDetails(agent.id)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Row(
          children: [
            AppAvatar(imageUrl: agent.avatarUrl, size: 46),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(agent.name, style: Theme.of(context).textTheme.titleMedium),
                  Text('$count listings • ${agent.rating} ★', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusChip(
                  status: agent.verification == VerificationStatus.verified ? AppStatus.verified : AppStatus.pending,
                  label: agent.verification == VerificationStatus.verified ? 'Verified' : 'Pending',
                ),
                const SizedBox(height: 4),
                Text(agent.active ? 'Active' : 'Deactivated', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
