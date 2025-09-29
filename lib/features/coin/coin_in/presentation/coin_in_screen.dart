import 'package:bxb/features/coin/coin_in/view_model/coin_in_view_model.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/common/widgets/txt_input_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
part '_widgets/_select_payment_method_widget.dart';
part '_widgets/_bank_info_widget.dart';
part '_widgets/_deposit_amount_widget.dart';
part '_widgets/_transaction_id_input_widget.dart';

class CoinInScreen extends ConsumerStatefulWidget {
  const CoinInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoinInScreenState();
}

class _CoinInScreenState extends ConsumerState<CoinInScreen> {
  late final CoinInViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(coinInViewModelImplProvider.notifier);
    Future.microtask(() {
      _viewModel.initializeData();
    });
  }

  final TextEditingController amountController = TextEditingController();
  final TextEditingController txnIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _submit() {
    if (_formKey.currentState!.validate()) {
      _viewModel.onSubmit(context,
          amount: amountController.text, transactionId: txnIdController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(coinInViewModelImplProvider.select((s) => s.isLoading));

    final selectedPayment =
        ref.watch(coinInViewModelImplProvider.select((s) => s.selectedPayment));
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("ငွေသွင်းခြင်း"),
      ),
      body: isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _SelectPaymentMethodWidget(),
                      const Gap(16),
                      if (selectedPayment != -1) ...[
                        const _BanKInfoWidget(),
                        const Gap(16),
                        _DepositAmountWidget(
                            amountController: amountController),
                        const Gap(16),
                        _TransactionIdInputWidget(
                            txnIdController: txnIdController),
                        const Gap(20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _submit,
                            child: const Text('ပို့မည်',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
