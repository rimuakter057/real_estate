import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../state/app_session.dart';
import 'route_paths.dart';

import '../../shared/models/user_model.dart';

import '../../features/auth/splash_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/forgot_password_screen.dart';

import '../../features/buyer/shell/buyer_shell.dart';
import '../../features/buyer/home/buyer_home_screen.dart';
import '../../features/buyer/explore/explore_screen.dart';
import '../../features/buyer/explore/advanced_filter_screen.dart';
import '../../features/buyer/property_details/property_details_screen.dart';
import '../../features/buyer/property_details/property_gallery_screen.dart';
import '../../features/buyer/map/map_view_screen.dart';
import '../../features/buyer/favorites/favorites_screen.dart';
import '../../features/buyer/notifications/notifications_screen.dart';
import '../../features/buyer/messages/chat_list_screen.dart';
import '../../features/buyer/messages/chat_detail_screen.dart';
import '../../features/buyer/visits/schedule_visit_screen.dart';
import '../../features/buyer/visits/my_visits_screen.dart';
import '../../features/buyer/profile/agent_profile_screen.dart';
import '../../features/buyer/profile/buyer_profile_screen.dart';
import '../../features/buyer/profile/edit_profile_screen.dart';

import '../../features/owner/shell/owner_shell.dart';
import '../../features/owner/dashboard/owner_dashboard_screen.dart';
import '../../features/owner/properties/my_properties_screen.dart';
import '../../features/owner/properties/property_preview_screen.dart';
import '../../features/owner/properties/edit_property_screen.dart';
import '../../features/owner/add_property/add_property_flow_screen.dart';
import '../../features/owner/leads/leads_screen.dart';
import '../../features/owner/leads/lead_details_screen.dart';
import '../../features/owner/visits/visit_requests_screen.dart';
import '../../features/owner/messages/owner_chat_list_screen.dart';
import '../../features/owner/messages/owner_chat_detail_screen.dart';
import '../../features/owner/notifications/owner_notifications_screen.dart';
import '../../features/owner/profile/owner_profile_screen.dart';
import '../../features/owner/profile/owner_edit_profile_screen.dart';

import '../../features/admin/shell/admin_shell.dart';
import '../../features/admin/dashboard/admin_dashboard_screen.dart';
import '../../features/admin/users/users_screen.dart';
import '../../features/admin/users/user_details_screen.dart';
import '../../features/admin/agents/agents_screen.dart';
import '../../features/admin/agents/agent_details_screen.dart';
import '../../features/admin/properties/admin_properties_screen.dart';
import '../../features/admin/properties/admin_property_details_screen.dart';
import '../../features/admin/approvals/pending_approval_screen.dart';
import '../../features/admin/approvals/approval_details_screen.dart';
import '../../features/admin/reports/reports_screen.dart';
import '../../features/admin/featured/featured_listings_screen.dart';
import '../../features/admin/categories/categories_screen.dart';
import '../../features/admin/settings/admin_settings_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RoutePaths.splash,
  refreshListenable: AppSession.instance,
  redirect: (context, state) {
    final role = AppSession.instance.role;
    final loc = state.matchedLocation;
    final isAuthRoute = loc == RoutePaths.splash ||
        loc == RoutePaths.onboarding ||
        loc == RoutePaths.login ||
        loc == RoutePaths.register ||
        loc == RoutePaths.forgotPassword;

    if (role == null) {
      return isAuthRoute ? null : RoutePaths.login;
    }

    // Signed in: keep each role inside its own navigation area.
    if (loc == RoutePaths.login || loc == RoutePaths.splash || loc == RoutePaths.onboarding) {
      return switch (role) {
        UserRole.buyer => RoutePaths.buyerHome,
        UserRole.owner => RoutePaths.ownerDashboard,
        UserRole.admin => RoutePaths.adminDashboard,
      };
    }
    if (role != UserRole.buyer && loc.startsWith('/buyer')) {
      return role == UserRole.owner ? RoutePaths.ownerDashboard : RoutePaths.adminDashboard;
    }
    if (role != UserRole.owner && loc.startsWith('/owner')) {
      return role == UserRole.buyer ? RoutePaths.buyerHome : RoutePaths.adminDashboard;
    }
    if (role != UserRole.admin && loc.startsWith('/admin')) {
      return role == UserRole.buyer ? RoutePaths.buyerHome : RoutePaths.ownerDashboard;
    }
    return null;
  },
  routes: [
    GoRoute(path: RoutePaths.splash, builder: (context, state) => const SplashScreen()),
    GoRoute(path: RoutePaths.onboarding, builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: RoutePaths.login, builder: (context, state) => const LoginScreen()),
    GoRoute(path: RoutePaths.register, builder: (context, state) => const RegisterScreen()),
    GoRoute(path: RoutePaths.forgotPassword, builder: (context, state) => const ForgotPasswordScreen()),

    // ---------------- BUYER ----------------
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => BuyerShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.buyerHome, builder: (context, state) => const BuyerHomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.buyerExplore, builder: (context, state) => const ExploreScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.buyerFavorites, builder: (context, state) => const FavoritesScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.buyerMessages, builder: (context, state) => const ChatListScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.buyerProfile, builder: (context, state) => const BuyerProfileScreen()),
        ]),
      ],
    ),
    GoRoute(
      path: RoutePaths.buyerFilter,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const AdvancedFilterScreen(),
    ),
    GoRoute(
      path: RoutePaths.buyerMap,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const MapViewScreen(),
    ),
    GoRoute(
      path: RoutePaths.buyerNotifications,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: RoutePaths.buyerMyVisits,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const MyVisitsScreen(),
    ),
    GoRoute(
      path: RoutePaths.buyerEditProfile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/buyer/property/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => PropertyDetailsScreen(propertyId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/buyer/property/:id/gallery',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => PropertyGalleryScreen(propertyId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/buyer/chat/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => ChatDetailScreen(conversationId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/buyer/schedule-visit/:propertyId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => ScheduleVisitScreen(propertyId: state.pathParameters['propertyId']!),
    ),
    GoRoute(
      path: '/buyer/agent/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => AgentProfileScreen(agentId: state.pathParameters['id']!),
    ),

    // ---------------- OWNER ----------------
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => OwnerShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.ownerDashboard, builder: (context, state) => const OwnerDashboardScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.ownerProperties, builder: (context, state) => const MyPropertiesScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.ownerAddProperty, builder: (context, state) => const AddPropertyFlowScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.ownerLeads, builder: (context, state) => const LeadsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.ownerProfile, builder: (context, state) => const OwnerProfileScreen()),
        ]),
      ],
    ),
    GoRoute(
      path: RoutePaths.ownerVisitRequests,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const VisitRequestsScreen(),
    ),
    GoRoute(
      path: RoutePaths.ownerNotifications,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerNotificationsScreen(),
    ),
    GoRoute(
      path: RoutePaths.ownerEditProfile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerEditProfileScreen(),
    ),
    GoRoute(
      path: RoutePaths.ownerMessages,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerChatListScreen(),
    ),
    GoRoute(
      path: '/owner/property/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => PropertyPreviewScreen(propertyId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/owner/property/:id/edit',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => EditPropertyScreen(propertyId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/owner/lead/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => LeadDetailsScreen(leadId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/owner/chat/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => OwnerChatDetailScreen(conversationId: state.pathParameters['id']!),
    ),

    // ---------------- ADMIN ----------------
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AdminShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.adminDashboard, builder: (context, state) => const AdminDashboardScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.adminUsers, builder: (context, state) => const UsersScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.adminAgents, builder: (context, state) => const AgentsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.adminProperties, builder: (context, state) => const AdminPropertiesScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.adminApprovals, builder: (context, state) => const PendingApprovalScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.adminReports, builder: (context, state) => const ReportsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.adminFeatured, builder: (context, state) => const FeaturedListingsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.adminCategories, builder: (context, state) => const CategoriesScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.adminSettings, builder: (context, state) => const AdminSettingsScreen()),
        ]),
      ],
    ),
    GoRoute(
      path: '/admin/users/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => UserDetailsScreen(userId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/admin/agents/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => AgentDetailsScreen(agentId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/admin/properties/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => AdminPropertyDetailsScreen(propertyId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/admin/pending-approval/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => ApprovalDetailsScreen(propertyId: state.pathParameters['id']!),
    ),
  ],
);
