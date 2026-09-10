import 'package:auto_route/auto_route.dart';
import 'route.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: RouteDeciderRoute.page, initial: true),
        AutoRoute(page: RoleSelectionRoute.page),
        AutoRoute(page: OwnerSignInRoute.page),
        AutoRoute(page: OwnerSignUpRoute.page),
        AutoRoute(page: OwnerForgotPasswordRoute.page),
        AutoRoute(page: StaffSignInRoute.page),
        AutoRoute(page: OwnerHomeRoute.page),
        AutoRoute(page: DashboardRoute.page),
        AutoRoute(page: DataRoute.page),
        AutoRoute(page: InventoryRoute.page),
        AutoRoute(page: SalesRoute.page),
        AutoRoute(page: ManageRoute.page),
        AutoRoute(page: OwnerProfileRoute.page),
        AutoRoute(page: OwnerEmployeeRoute.page),
        AutoRoute(page: AddEmployeeRoute.page),
        AutoRoute(page: AddBusinessRoute.page),
        AutoRoute(page: BusinessDetailRoute.page),
        AutoRoute(page: ShopRoute.page),
        AutoRoute(page: ExpenseRoute.page),
        AutoRoute(page: ExpenseDetailRoute.page),
        AutoRoute(page: AddExpenseRoute.page),
        AutoRoute(page: ProductsRoute.page),
        AutoRoute(page: AddProductRoute.page),
        AutoRoute(page: StockRoute.page),
        AutoRoute(page: AddStockRoute.page),
        AutoRoute(page: SharedSalesRoute.page),
        AutoRoute(page: BusinessDataDetailRoute.page),
        AutoRoute(page: ManagerHomeRoute.page),
        AutoRoute(page: EmployeeHomeRoute.page),
      ];
}
