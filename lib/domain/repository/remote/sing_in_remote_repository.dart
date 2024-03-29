import 'package:synword/domain/model/user/user_sign_in_data.dart';

import '../../model/user/user_info.dart';

abstract class SignInRemoteRepository {
  Stream<UserInfo> get userDataChanges;

  Future<void> initialize();

  Future<void> signIn();

  UserSignInData? getAuthorizationData();

  Future<void> logout();
}
