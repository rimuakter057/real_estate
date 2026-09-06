class RoutePaths {
  RoutePaths._();

  // Auth
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // Buyer shell branches
  static const buyerHome = '/buyer/home';
  static const buyerExplore = '/buyer/explore';
  static const buyerFavorites = '/buyer/favorites';
  static const buyerMessages = '/buyer/messages';
  static const buyerProfile = '/buyer/profile';

  // Buyer pushed routes
  static const buyerFilter = '/buyer/filter';
  static const buyerMap = '/buyer/map';
  static const buyerNotifications = '/buyer/notifications';
  static const buyerMyVisits = '/buyer/my-visits';
  static const buyerEditProfile = '/buyer/edit-profile';
  static String buyerPropertyDetails(String id) => '/buyer/property/$id';
  static String buyerPropertyGallery(String id) => '/buyer/property/$id/gallery';
  static String buyerChatDetail(String id) => '/buyer/chat/$id';
  static String buyerScheduleVisit(String propertyId) => '/buyer/schedule-visit/$propertyId';
  static String buyerAgentProfile(String id) => '/buyer/agent/$id';

  // Owner shell branches
  static const ownerDashboard = '/owner/dashboard';
  static const ownerProperties = '/owner/properties';
  static const ownerAddProperty = '/owner/add-property';
  static const ownerLeads = '/owner/leads';
  static const ownerProfile = '/owner/profile';

  // Owner pushed routes
  static const ownerVisitRequests = '/owner/visit-requests';
  static const ownerNotifications = '/owner/notifications';
  static const ownerEditProfile = '/owner/edit-profile';
  static const ownerMessages = '/owner/messages';
  static String ownerPropertyPreview(String id) => '/owner/property/$id';
  static String ownerPropertyEdit(String id) => '/owner/property/$id/edit';
  static String ownerLeadDetails(String id) => '/owner/lead/$id';
  static String ownerChatDetail(String id) => '/owner/chat/$id';

  // Admin shell branches
  static const adminDashboard = '/admin/dashboard';
  static const adminUsers = '/admin/users';
  static const adminAgents = '/admin/agents';
  static const adminProperties = '/admin/properties';
  static const adminApprovals = '/admin/pending-approval';
  static const adminReports = '/admin/reports';
  static const adminFeatured = '/admin/featured-listings';
  static const adminCategories = '/admin/categories';
  static const adminSettings = '/admin/settings';

  // Admin pushed routes
  static String adminUserDetails(String id) => '/admin/users/$id';
  static String adminAgentDetails(String id) => '/admin/agents/$id';
  static String adminPropertyDetails(String id) => '/admin/properties/$id';
  static String adminApprovalDetails(String id) => '/admin/pending-approval/$id';
}
