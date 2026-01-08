import 'dart:convert';
import 'package:wallet_system_2/providers/base_provider.dart';
import 'package:wallet_system_2/models/transactions_models.dart';



class TransactionsProvider extends BaseProvider {
  List<Data> transactions = [];
  int transCurrentPage = 1;
  int transLastPage = 1;
  bool loading = false;

  Future<void> getTransactions({bool isRefresh = true}) async {
    if (isRefresh) {
      transCurrentPage = 1;
      setBusy(true);
    } else {
      if (transCurrentPage >= transLastPage || loading) return;
      transCurrentPage++;
      loading = true;
    }
    try {
      final response = await api.get(
        "/vendor/transactions",
        page: transCurrentPage,
      );
      if (response.statusCode == 200) {
        final model = TransactionModel.fromJson(json.decode(response.body));
        if (isRefresh) {
          transactions = model.data;
        } else {
          transactions.addAll(model.data);
        }
        transLastPage = model.meta.lastPage;
      }
    } catch (e) {
      setFailed(true);
    } finally {
      loading = false;
      setBusy(false);
    }
  }
}