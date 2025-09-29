import 'package:bxb/router/router.dart';
import 'package:bxb/services/auth/auth_service.dart';
import 'package:bxb/services/auth/models/auth_response_model.dart';
import 'package:bxb/services/auth/providers/auth_service_provider.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:bxb/utils/common/widgets/toast_msg.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_view_model.g.dart';

abstract class AuthViewModel {
  Future<void> getOtp(BuildContext context,
      {required String emailOrPhone, required String type});
  Future<void> otpVerify(
    BuildContext context, {
    required String otp,
  });
  Future<void> register(
    BuildContext context, {
    required String name,
  });
}

class AuthState {
  final String? type;
  final String? otp;
  final String? emailOrPhone;

  AuthState({this.type, this.otp, this.emailOrPhone});

  AuthState copyWith({
    String? type,
    String? otp,
    String? emailOrPhone,
  }) {
    return AuthState(
      type: type ?? this.type,
      otp: otp ?? this.otp,
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
    );
  }
}

@Riverpod(keepAlive: true) //ref.invalidate(authViewModelImplProvider);
class AuthViewModelImpl extends _$AuthViewModelImpl implements AuthViewModel {
  late final AuthService _authService;
  @override
  AuthState build() {
    _authService = ref.read(authServiceProvider);
    return AuthState();
  }

  @override
  Future<void> getOtp(BuildContext context,
      {required String emailOrPhone, required String type}) async {
    state = state.copyWith(emailOrPhone: emailOrPhone, type: type);
    DialogManger.showLoading(context);
    final res =
        await _authService.getOtp({"phoneOrEmail": emailOrPhone, "type": type});
    DialogManger.closeDialog(context);
    if (res.isSuccess) {
      ToastMsg.show(context, message: res.msg ?? "");
      context.pushNamed(
        RouteNames.auth.otpVerify,
      );
    } else {
      ToastMsg.show(context, message: res.error ?? "", isError: true);
    }
  }

  @override
  Future<void> otpVerify(
    BuildContext context, {
    required String otp,
  }) async {
    state = state.copyWith(otp: otp);
    DialogManger.showLoading(context);
    final res = await _authService.verifyOtp({
      "phoneOrEmail": state.emailOrPhone,
      "otp": "1234",
      "type": state.type
    });
    DialogManger.closeDialog(context);
    if (res.isSuccess) {
      ToastMsg.show(context, message: res.msg ?? "");
      if (res.data is AuthResponseModel) {
        context.pushNamed(RouteNames.auth.fillUserInfo);
      } else {
        // ref.invalidate(authViewModelImplProvider);
        context.pushNamed(RouteNames.main.home);
      }
    } else {
      ToastMsg.show(context, message: res.error ?? "", isError: true);
    }
  }

  @override
  Future<void> register(
    BuildContext context, {
    required String name,
  }) async {
    DialogManger.showLoading(context);
    final res = await _authService.register({
      "name": name,
      "phoneOrEmail": state.emailOrPhone,
      "otp": state.otp,
      "type": state.type,
      "agentCode": ""
    });
    DialogManger.closeDialog(context);
    if (res.isSuccess) {
      ToastMsg.show(context, message: res.msg ?? "");
      //ref.invalidate(authViewModelImplProvider);
      context.pushNamed(RouteNames.main.home);
    } else {
      ToastMsg.show(context, message: res.error ?? "", isError: true);
    }
  }
}
