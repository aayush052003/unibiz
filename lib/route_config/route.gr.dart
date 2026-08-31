// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i29;
import 'package:flutter/material.dart' as _i30;
import 'package:unibiz/modules/auth/owner_forgot_password/owner_forgot_password_screen.dart'
    as _i16;
import 'package:unibiz/modules/auth/owner_sign_in/owner_sign_in_screen.dart'
    as _i19;
import 'package:unibiz/modules/auth/owner_sign_up/owner_sign_up_screen.dart'
    as _i20;
import 'package:unibiz/modules/auth/role_selection/role_selection_screen.dart'
    as _i22;
import 'package:unibiz/modules/auth/staff_sign_in/staff_sign_in_screen.dart'
    as _i27;
import 'package:unibiz/modules/home/employee/employee_home/employee_home_screen.dart'
    as _i9;
import 'package:unibiz/modules/home/manager/manager_home/manager_home_screen.dart'
    as _i14;
import 'package:unibiz/modules/home/owner/add_business/add_business_screen.dart'
    as _i1;
import 'package:unibiz/modules/home/owner/add_employee/add_employee_screen.dart'
    as _i2;
import 'package:unibiz/modules/home/owner/business_detail/business_detail_screen.dart'
    as _i6;
import 'package:unibiz/modules/home/owner/dashboard/dashboard_screen.dart'
    as _i7;
import 'package:unibiz/modules/home/owner/data/data_screen.dart' as _i8;
import 'package:unibiz/modules/home/owner/employee/owner_employee_screen.dart'
    as _i15;
import 'package:unibiz/modules/home/owner/inventory/inventory_screen.dart'
    as _i12;
import 'package:unibiz/modules/home/owner/manage/manage_screen.dart' as _i13;
import 'package:unibiz/modules/home/owner/owner_home/owner_home_screen.dart'
    as _i17;
import 'package:unibiz/modules/home/owner/profile/owner_profile_screen.dart'
    as _i18;
import 'package:unibiz/modules/home/owner/sales/sales_screen.dart' as _i24;
import 'package:unibiz/modules/home/owner/shop/shop_screen.dart' as _i26;
import 'package:unibiz/modules/shared/add_expense/add_expense_screen.dart'
    as _i3;
import 'package:unibiz/modules/shared/add_product/add_product_screen.dart'
    as _i4;
import 'package:unibiz/modules/shared/add_stock/add_stock_screen.dart' as _i5;
import 'package:unibiz/modules/shared/expense/expense_screen.dart' as _i11;
import 'package:unibiz/modules/shared/expense_detail/expense_detail_screen.dart'
    as _i10;
import 'package:unibiz/modules/shared/products/products_screen.dart' as _i21;
import 'package:unibiz/modules/shared/sales/sales_screen.dart' as _i25;
import 'package:unibiz/modules/shared/stock/stock_screen.dart' as _i28;
import 'package:unibiz/route_config/route_decider_screen.dart' as _i23;

/// generated route for
/// [_i1.AddBusinessScreen]
class AddBusinessRoute extends _i29.PageRouteInfo<void> {
  const AddBusinessRoute({List<_i29.PageRouteInfo>? children})
    : super(AddBusinessRoute.name, initialChildren: children);

  static const String name = 'AddBusinessRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddBusinessScreen();
    },
  );
}

/// generated route for
/// [_i2.AddEmployeeScreen]
class AddEmployeeRoute extends _i29.PageRouteInfo<void> {
  const AddEmployeeRoute({List<_i29.PageRouteInfo>? children})
    : super(AddEmployeeRoute.name, initialChildren: children);

  static const String name = 'AddEmployeeRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i2.AddEmployeeScreen();
    },
  );
}

/// generated route for
/// [_i3.AddExpenseScreen]
class AddExpenseRoute extends _i29.PageRouteInfo<AddExpenseRouteArgs> {
  AddExpenseRoute({
    _i30.Key? key,
    required String businessId,
    List<_i29.PageRouteInfo>? children,
  }) : super(
         AddExpenseRoute.name,
         args: AddExpenseRouteArgs(key: key, businessId: businessId),
         initialChildren: children,
       );

  static const String name = 'AddExpenseRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddExpenseRouteArgs>();
      return _i3.AddExpenseScreen(key: args.key, businessId: args.businessId);
    },
  );
}

class AddExpenseRouteArgs {
  const AddExpenseRouteArgs({this.key, required this.businessId});

  final _i30.Key? key;

  final String businessId;

  @override
  String toString() {
    return 'AddExpenseRouteArgs{key: $key, businessId: $businessId}';
  }
}

/// generated route for
/// [_i4.AddProductScreen]
class AddProductRoute extends _i29.PageRouteInfo<AddProductRouteArgs> {
  AddProductRoute({
    _i30.Key? key,
    required String businessId,
    List<_i29.PageRouteInfo>? children,
  }) : super(
         AddProductRoute.name,
         args: AddProductRouteArgs(key: key, businessId: businessId),
         initialChildren: children,
       );

  static const String name = 'AddProductRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddProductRouteArgs>();
      return _i4.AddProductScreen(key: args.key, businessId: args.businessId);
    },
  );
}

class AddProductRouteArgs {
  const AddProductRouteArgs({this.key, required this.businessId});

  final _i30.Key? key;

  final String businessId;

  @override
  String toString() {
    return 'AddProductRouteArgs{key: $key, businessId: $businessId}';
  }
}

/// generated route for
/// [_i5.AddStockScreen]
class AddStockRoute extends _i29.PageRouteInfo<AddStockRouteArgs> {
  AddStockRoute({
    _i30.Key? key,
    required String businessId,
    List<_i29.PageRouteInfo>? children,
  }) : super(
         AddStockRoute.name,
         args: AddStockRouteArgs(key: key, businessId: businessId),
         initialChildren: children,
       );

  static const String name = 'AddStockRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddStockRouteArgs>();
      return _i5.AddStockScreen(key: args.key, businessId: args.businessId);
    },
  );
}

class AddStockRouteArgs {
  const AddStockRouteArgs({this.key, required this.businessId});

  final _i30.Key? key;

  final String businessId;

  @override
  String toString() {
    return 'AddStockRouteArgs{key: $key, businessId: $businessId}';
  }
}

/// generated route for
/// [_i6.BusinessDetailScreen]
class BusinessDetailRoute extends _i29.PageRouteInfo<BusinessDetailRouteArgs> {
  BusinessDetailRoute({
    _i30.Key? key,
    required String businessId,
    required String businessName,
    List<_i29.PageRouteInfo>? children,
  }) : super(
         BusinessDetailRoute.name,
         args: BusinessDetailRouteArgs(
           key: key,
           businessId: businessId,
           businessName: businessName,
         ),
         initialChildren: children,
       );

  static const String name = 'BusinessDetailRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BusinessDetailRouteArgs>();
      return _i6.BusinessDetailScreen(
        key: args.key,
        businessId: args.businessId,
        businessName: args.businessName,
      );
    },
  );
}

class BusinessDetailRouteArgs {
  const BusinessDetailRouteArgs({
    this.key,
    required this.businessId,
    required this.businessName,
  });

  final _i30.Key? key;

  final String businessId;

  final String businessName;

  @override
  String toString() {
    return 'BusinessDetailRouteArgs{key: $key, businessId: $businessId, businessName: $businessName}';
  }
}

/// generated route for
/// [_i7.DashboardScreen]
class DashboardRoute extends _i29.PageRouteInfo<void> {
  const DashboardRoute({List<_i29.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i7.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i8.DataScreen]
class DataRoute extends _i29.PageRouteInfo<void> {
  const DataRoute({List<_i29.PageRouteInfo>? children})
    : super(DataRoute.name, initialChildren: children);

  static const String name = 'DataRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i8.DataScreen();
    },
  );
}

/// generated route for
/// [_i9.EmployeeHomeScreen]
class EmployeeHomeRoute extends _i29.PageRouteInfo<void> {
  const EmployeeHomeRoute({List<_i29.PageRouteInfo>? children})
    : super(EmployeeHomeRoute.name, initialChildren: children);

  static const String name = 'EmployeeHomeRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i9.EmployeeHomeScreen();
    },
  );
}

/// generated route for
/// [_i10.ExpenseDetailScreen]
class ExpenseDetailRoute extends _i29.PageRouteInfo<ExpenseDetailRouteArgs> {
  ExpenseDetailRoute({
    _i30.Key? key,
    required String businessId,
    required String businessName,
    List<_i29.PageRouteInfo>? children,
  }) : super(
         ExpenseDetailRoute.name,
         args: ExpenseDetailRouteArgs(
           key: key,
           businessId: businessId,
           businessName: businessName,
         ),
         initialChildren: children,
       );

  static const String name = 'ExpenseDetailRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ExpenseDetailRouteArgs>();
      return _i10.ExpenseDetailScreen(
        key: args.key,
        businessId: args.businessId,
        businessName: args.businessName,
      );
    },
  );
}

class ExpenseDetailRouteArgs {
  const ExpenseDetailRouteArgs({
    this.key,
    required this.businessId,
    required this.businessName,
  });

  final _i30.Key? key;

  final String businessId;

  final String businessName;

  @override
  String toString() {
    return 'ExpenseDetailRouteArgs{key: $key, businessId: $businessId, businessName: $businessName}';
  }
}

/// generated route for
/// [_i11.ExpenseScreen]
class ExpenseRoute extends _i29.PageRouteInfo<void> {
  const ExpenseRoute({List<_i29.PageRouteInfo>? children})
    : super(ExpenseRoute.name, initialChildren: children);

  static const String name = 'ExpenseRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i11.ExpenseScreen();
    },
  );
}

/// generated route for
/// [_i12.InventoryScreen]
class InventoryRoute extends _i29.PageRouteInfo<void> {
  const InventoryRoute({List<_i29.PageRouteInfo>? children})
    : super(InventoryRoute.name, initialChildren: children);

  static const String name = 'InventoryRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i12.InventoryScreen();
    },
  );
}

/// generated route for
/// [_i13.ManageScreen]
class ManageRoute extends _i29.PageRouteInfo<void> {
  const ManageRoute({List<_i29.PageRouteInfo>? children})
    : super(ManageRoute.name, initialChildren: children);

  static const String name = 'ManageRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i13.ManageScreen();
    },
  );
}

/// generated route for
/// [_i14.ManagerHomeScreen]
class ManagerHomeRoute extends _i29.PageRouteInfo<void> {
  const ManagerHomeRoute({List<_i29.PageRouteInfo>? children})
    : super(ManagerHomeRoute.name, initialChildren: children);

  static const String name = 'ManagerHomeRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i14.ManagerHomeScreen();
    },
  );
}

/// generated route for
/// [_i15.OwnerEmployeeScreen]
class OwnerEmployeeRoute extends _i29.PageRouteInfo<void> {
  const OwnerEmployeeRoute({List<_i29.PageRouteInfo>? children})
    : super(OwnerEmployeeRoute.name, initialChildren: children);

  static const String name = 'OwnerEmployeeRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i15.OwnerEmployeeScreen();
    },
  );
}

/// generated route for
/// [_i16.OwnerForgotPasswordScreen]
class OwnerForgotPasswordRoute extends _i29.PageRouteInfo<void> {
  const OwnerForgotPasswordRoute({List<_i29.PageRouteInfo>? children})
    : super(OwnerForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'OwnerForgotPasswordRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i16.OwnerForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i17.OwnerHomeScreen]
class OwnerHomeRoute extends _i29.PageRouteInfo<void> {
  const OwnerHomeRoute({List<_i29.PageRouteInfo>? children})
    : super(OwnerHomeRoute.name, initialChildren: children);

  static const String name = 'OwnerHomeRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i17.OwnerHomeScreen();
    },
  );
}

/// generated route for
/// [_i18.OwnerProfileScreen]
class OwnerProfileRoute extends _i29.PageRouteInfo<void> {
  const OwnerProfileRoute({List<_i29.PageRouteInfo>? children})
    : super(OwnerProfileRoute.name, initialChildren: children);

  static const String name = 'OwnerProfileRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i18.OwnerProfileScreen();
    },
  );
}

/// generated route for
/// [_i19.OwnerSignInScreen]
class OwnerSignInRoute extends _i29.PageRouteInfo<void> {
  const OwnerSignInRoute({List<_i29.PageRouteInfo>? children})
    : super(OwnerSignInRoute.name, initialChildren: children);

  static const String name = 'OwnerSignInRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i19.OwnerSignInScreen();
    },
  );
}

/// generated route for
/// [_i20.OwnerSignUpScreen]
class OwnerSignUpRoute extends _i29.PageRouteInfo<void> {
  const OwnerSignUpRoute({List<_i29.PageRouteInfo>? children})
    : super(OwnerSignUpRoute.name, initialChildren: children);

  static const String name = 'OwnerSignUpRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i20.OwnerSignUpScreen();
    },
  );
}

/// generated route for
/// [_i21.ProductsScreen]
class ProductsRoute extends _i29.PageRouteInfo<ProductsRouteArgs> {
  ProductsRoute({
    _i30.Key? key,
    required String businessId,
    List<_i29.PageRouteInfo>? children,
  }) : super(
         ProductsRoute.name,
         args: ProductsRouteArgs(key: key, businessId: businessId),
         initialChildren: children,
       );

  static const String name = 'ProductsRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductsRouteArgs>();
      return _i21.ProductsScreen(key: args.key, businessId: args.businessId);
    },
  );
}

class ProductsRouteArgs {
  const ProductsRouteArgs({this.key, required this.businessId});

  final _i30.Key? key;

  final String businessId;

  @override
  String toString() {
    return 'ProductsRouteArgs{key: $key, businessId: $businessId}';
  }
}

/// generated route for
/// [_i22.RoleSelectionScreen]
class RoleSelectionRoute extends _i29.PageRouteInfo<void> {
  const RoleSelectionRoute({List<_i29.PageRouteInfo>? children})
    : super(RoleSelectionRoute.name, initialChildren: children);

  static const String name = 'RoleSelectionRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i22.RoleSelectionScreen();
    },
  );
}

/// generated route for
/// [_i23.RouteDeciderScreen]
class RouteDeciderRoute extends _i29.PageRouteInfo<void> {
  const RouteDeciderRoute({List<_i29.PageRouteInfo>? children})
    : super(RouteDeciderRoute.name, initialChildren: children);

  static const String name = 'RouteDeciderRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i23.RouteDeciderScreen();
    },
  );
}

/// generated route for
/// [_i24.SalesScreen]
class SalesRoute extends _i29.PageRouteInfo<SalesRouteArgs> {
  SalesRoute({
    _i30.Key? key,
    _i30.VoidCallback? onBack,
    List<_i29.PageRouteInfo>? children,
  }) : super(
         SalesRoute.name,
         args: SalesRouteArgs(key: key, onBack: onBack),
         initialChildren: children,
       );

  static const String name = 'SalesRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SalesRouteArgs>(
        orElse: () => const SalesRouteArgs(),
      );
      return _i24.SalesScreen(key: args.key, onBack: args.onBack);
    },
  );
}

class SalesRouteArgs {
  const SalesRouteArgs({this.key, this.onBack});

  final _i30.Key? key;

  final _i30.VoidCallback? onBack;

  @override
  String toString() {
    return 'SalesRouteArgs{key: $key, onBack: $onBack}';
  }
}

/// generated route for
/// [_i25.SharedSalesScreen]
class SharedSalesRoute extends _i29.PageRouteInfo<SharedSalesRouteArgs> {
  SharedSalesRoute({
    _i30.Key? key,
    required String businessId,
    List<_i29.PageRouteInfo>? children,
  }) : super(
         SharedSalesRoute.name,
         args: SharedSalesRouteArgs(key: key, businessId: businessId),
         initialChildren: children,
       );

  static const String name = 'SharedSalesRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SharedSalesRouteArgs>();
      return _i25.SharedSalesScreen(key: args.key, businessId: args.businessId);
    },
  );
}

class SharedSalesRouteArgs {
  const SharedSalesRouteArgs({this.key, required this.businessId});

  final _i30.Key? key;

  final String businessId;

  @override
  String toString() {
    return 'SharedSalesRouteArgs{key: $key, businessId: $businessId}';
  }
}

/// generated route for
/// [_i26.ShopScreen]
class ShopRoute extends _i29.PageRouteInfo<void> {
  const ShopRoute({List<_i29.PageRouteInfo>? children})
    : super(ShopRoute.name, initialChildren: children);

  static const String name = 'ShopRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i26.ShopScreen();
    },
  );
}

/// generated route for
/// [_i27.StaffSignInScreen]
class StaffSignInRoute extends _i29.PageRouteInfo<void> {
  const StaffSignInRoute({List<_i29.PageRouteInfo>? children})
    : super(StaffSignInRoute.name, initialChildren: children);

  static const String name = 'StaffSignInRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i27.StaffSignInScreen();
    },
  );
}

/// generated route for
/// [_i28.StockScreen]
class StockRoute extends _i29.PageRouteInfo<StockRouteArgs> {
  StockRoute({
    _i30.Key? key,
    required String businessId,
    _i30.VoidCallback? onBack,
    List<_i29.PageRouteInfo>? children,
  }) : super(
         StockRoute.name,
         args: StockRouteArgs(key: key, businessId: businessId, onBack: onBack),
         initialChildren: children,
       );

  static const String name = 'StockRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StockRouteArgs>();
      return _i28.StockScreen(
        key: args.key,
        businessId: args.businessId,
        onBack: args.onBack,
      );
    },
  );
}

class StockRouteArgs {
  const StockRouteArgs({this.key, required this.businessId, this.onBack});

  final _i30.Key? key;

  final String businessId;

  final _i30.VoidCallback? onBack;

  @override
  String toString() {
    return 'StockRouteArgs{key: $key, businessId: $businessId, onBack: $onBack}';
  }
}
