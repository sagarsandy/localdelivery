import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/session/user_session.dart';
import '../domain/use_cases/get_profile_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfileUseCase) : super(ProfileInitial());

  final GetProfileUseCase _getProfileUseCase;

  Future<void> loadProfile() async {
    final userId = UserSession.instance.userId;
    if (userId == null) {
      emit(const ProfileError('User not logged in.'));
      return;
    }
    emit(ProfileLoading());
    final result = await _getProfileUseCase.getProfile(userId: userId);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> signOut() async {
    await UserSession.instance.signOut();
  }
}
