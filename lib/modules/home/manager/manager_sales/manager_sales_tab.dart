import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/colors.dart';
import '../../../../helper/hive_service.dart';
import '../../../shared/sales/sales_screen.dart';

class ManagerSalesTab extends StatefulWidget {
  final String? businessId;

  const ManagerSalesTab({super.key, this.businessId});

  @override
  State<ManagerSalesTab> createState() => _ManagerSalesTabState();
}

class _ManagerSalesTabState extends State<ManagerSalesTab> {
  String? _businessId;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _businessId = widget.businessId;
    if (_businessId == null) {
      _fetchBusinessId();
    }
  }

  Future<void> _fetchBusinessId() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = HiveService.getUserId();
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final response = await Supabase.instance.client
          .from('business_members')
          .select('business_id')
          .eq('user_id', userId)
          .eq('role', 'manager')
          .maybeSingle();

      if (response != null && response['business_id'] != null) {
        if (mounted) {
          setState(() {
            _businessId = response['business_id'] as String;
            _isLoading = false;
          });
        }
      } else {
        throw Exception('No business assigned to this manager');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_businessId != null) {
      return SharedSalesScreen(businessId: _businessId!);
    }

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchBusinessId,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

