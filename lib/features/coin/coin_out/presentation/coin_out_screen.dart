import 'package:bxb/features/coin/coin_in/view_model/coin_in_view_model.dart';
import 'package:bxb/features/coin/coin_out/view_model/coin_out_view_model.dart';
import 'package:bxb/router/router.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/common/widgets/txt_input_widget.dart';
import 'package:bxb/utils/extension/num_extension.dart';
import 'package:bxb/utils/helpers/validator_functions.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
part '_widgets/_select_payment_method_widget.dart';

class CoinOutScreen extends ConsumerStatefulWidget {
  const CoinOutScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoinOutScreenState();
}

class _CoinOutScreenState extends ConsumerState<CoinOutScreen> with RouteAware {
  late final CoinOutViewModel _viewModel;
  late final TextEditingController amountController = TextEditingController();
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController phoneController = TextEditingController();

  bool _hasFocusOnAmt = false;
  bool _hasFocusName = false;
  bool _hasFocusOnPhone = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(coinOutViewModelImplProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initializeData(context);
    });

    // amountController.addListener(_amtValidationListener);
    // nameController.addListener(_nameValidationListener);
    // phoneController.addListener(_phoneValidationListener);
  }

  // _nameValidationListener() {
  //   if (_hasFocusName) {
  //     _formKey.currentState!.validate();
  //   }
  // }

  // _amtValidationListener() {
  //   if (_hasFocusOnAmt) {
  //     _formKey.currentState!.validate();
  //   }
  // }

  // _phoneValidationListener() {
  //   if (_hasFocusOnPhone) {
  //     _formKey.currentState!.validate();
  //   }
  // }

  final _formKey = GlobalKey<FormState>();

  _submit() {
    if (_formKey.currentState!.validate()) {
      final selectedPayment = ref
          .read(coinOutViewModelImplProvider.select((s) => s.selectedPayment));
      final userData =
          ref.read(coinOutViewModelImplProvider.select((s) => s.userData));
      if (selectedPayment == -1) {
        DialogManger.showAutoCloseResultDialog(context,
            isSuccess: false, description: "ငွေလက်ခံမည့် နည်းလမ်းရွှေးချယ်ပါ");
      } else {
        if (!(userData?.updatedPin ?? false)) {
          DialogManger.showSetPinAlert(
            context,
          );
          return;
        } else {
          DialogManger.showConfirmPinDialog(
            context,
            onConfirm: (pin) {
              _viewModel.onSubmit(context,
                  amount: amountController.text,
                  name: nameController.text,
                  phone: phoneController.text,
                  pin: pin);
            },
          );
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context)! as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    amountController.dispose();
    nameController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  void didPopNext() {
    _viewModel.initializeData(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(coinOutViewModelImplProvider.select((s) => s.isLoading));
    final myCoin =
        ref.watch(coinOutViewModelImplProvider.select((s) => s.myCoins));

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("ငွေထုတ်ခြင်း"),
      ),
      body: isLoading
          ? const LoadingWidget()
          : GestureDetector(
              onTap: () {
                _formKey.currentState!.validate();
              },
              child: SingleChildScrollView(
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 0),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E5E5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('ငွေလက်ခံမည့် အကောင့်',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                              const Divider(
                                height: 50,
                              ),
                              TxtInputWidget(
                                  name: "နာမည်",
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  controller: nameController,
                                  style: const TextStyle(color: Colors.black),
                                  boxBorder: Border.all(color: Colors.grey),
                                  hintText: 'Enter name',
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  borderRadius: 8,
                                  onChanged: (_) {
                                    setState(() {
                                      _hasFocusName = true;
                                    });
                                  },
                                  validator: nameValidator),
                              const SizedBox(height: 15),
                              TxtInputWidget(
                                  name: "အကောင့်နံပါတ် / ဖုန်းနံပါတ်",
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  controller: phoneController,
                                  style: const TextStyle(color: Colors.black),
                                  boxBorder: Border.all(color: Colors.grey),
                                  keyboardType: TextInputType.phone,
                                  hintText: 'Enter your account number',
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  borderRadius: 8,
                                  onChanged: (_) {
                                    setState(() {
                                      _hasFocusOnPhone = true;
                                    });
                                  },
                                  validator: phoneValidator),
                              const SizedBox(height: 15),
                              TxtInputWidget(
                                name: "ထုတ်မည့် ငွေပမာဏ",
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                controller: amountController,
                                style: const TextStyle(color: Colors.black),
                                boxBorder: Border.all(color: Colors.grey),
                                keyboardType: TextInputType.number,
                                hintText: 'Enter amount',
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                                borderRadius: 8,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Amount is required';
                                  }
                                  final numValue =
                                      int.tryParse(value.replaceAll(',', ''));
                                  if (numValue == null) {
                                    return 'Enter a valid number';
                                  }
                                  if (numValue < 5000) {
                                    return 'Amount must be at least 5,000 MMK';
                                  }
                                  return null;
                                },
                                onChanged: (_) {
                                  setState(() {
                                    _hasFocusOnAmt = true;
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                  'ထုတ်ငွေ အနည်းဆုံး ၅,၀၀၀ ကျပ် ဖြစ်ရမည်',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey)),
                              const SizedBox(height: 20),
                              Text(
                                'လက်ကျန်ငွေ : ${myCoin.toPricing}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              )
                            ],
                          ),
                        ),
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
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
