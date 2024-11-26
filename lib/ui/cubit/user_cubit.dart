import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/repo/product_repo.dart';

class UserCubit extends Cubit<Map<String, String?>> {
  final ProductRepo productRepo;

  UserCubit(this.productRepo) : super({});

  Future<void> fetchUserInfo() async {
    final userInfo = await productRepo.fetchUserInfo();
    emit(userInfo);
  }

}
