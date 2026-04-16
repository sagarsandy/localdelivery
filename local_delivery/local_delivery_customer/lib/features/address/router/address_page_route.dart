import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../../../app/router/ld_page_route.dart';
import '../presentation/pages/address_page.dart';
import '../presentation/pages/add_address_page.dart';

class AddressPageRoute {
  List<GoRoute> get routes => [
        GoRoute(
          name: LDAppRoute.addresses.name,
          path: LDAppRoute.addresses.path,
          pageBuilder: (context, state) => buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const AddressPage(),
          ),
        ),
        GoRoute(
          name: LDAppRoute.addAddress.name,
          path: LDAppRoute.addAddress.path,
          pageBuilder: (context, state) => buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const AddAddressPage(),
          ),
        ),
      ];
}
