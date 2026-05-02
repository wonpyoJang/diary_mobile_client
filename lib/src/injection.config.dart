// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_remote_config/firebase_remote_config.dart' as _i627;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import 'bus/bus.dart' as _i461;
import 'core/analytics/analytics_manager.dart' as _i958;
import 'core/deep_link/deep_link_cubit.dart' as _i740;
import 'core/deep_link/deep_link_service.dart' as _i735;
import 'core/dev/moment_seeder.dart' as _i67;
import 'core/device/infrastructure/interfaces/i_device_info_local_provider.dart'
    as _i23;
import 'core/device/infrastructure/providers/device_info_local_provider.dart'
    as _i505;
import 'core/drift/drift_client.dart' as _i407;
import 'core/feature_mager/feature_manager.dart' as _i694;
import 'core/file/file_manager.dart' as _i891;
import 'core/firebase/firebase_client.dart' as _i248;
import 'core/hive_client/hive_client.dart' as _i951;
import 'core/http_client/dio_module.dart' as _i871;
import 'core/http_client/http_client.dart' as _i356;
import 'core/image_picker/image_picker_client.dart' as _i917;
import 'core/llm/llm_service.dart' as _i681;
import 'core/media/domain/repositories/i_mieda_info_repository.dart' as _i1057;
import 'core/media/infrastructure/providers/interfaces/i_media_info_local_provider.dart'
    as _i579;
import 'core/media/infrastructure/providers/media_info_local_provider.dart'
    as _i1061;
import 'core/media/infrastructure/repositories/media_info_repository.dart'
    as _i1047;
import 'core/remote_config_client/di_injection.dart' as _i407;
import 'core/remote_config_client/remote_config_client.dart' as _i297;
import 'core/supabase/supabase_module.dart' as _i850;
import 'database/app_database.dart' as _i587;
import 'feature/common/moment/domain/entity/moment.dart' as _i517;
import 'feature/common/moment/infrastructure/providers/interfaces/i_moment_list_local_provider.dart'
    as _i579;
import 'feature/common/moment/infrastructure/providers/moment_list_local_provider.dart'
    as _i209;
import 'feature/common/moment/infrastructure/repositories/moment_list_repository.dart'
    as _i690;
import 'feature/common/toast/application/toast_bloc.dart' as _i190;
import 'feature/data_control/application/data_control_bloc.dart' as _i1;
import 'feature/data_control/domain/repositories/interfaces/i_data_control_repository.dart'
    as _i1018;
import 'feature/data_control/infrastructure/providers/interfaces/i_local_data_control_provider.dart'
    as _i163;
import 'feature/data_control/infrastructure/providers/local_data_control_provider.dart'
    as _i186;
import 'feature/data_control/infrastructure/repositories/data_control_repository.dart'
    as _i489;
import 'feature/emotion_statistics/application/emotional_statistics_bloc.dart'
    as _i383;
import 'feature/emotion_statistics/domain/repositories/interfaces/i_emotion_statistics_repository.dart'
    as _i535;
import 'feature/emotion_statistics/infrastructure/providers/emotion_statistics_provider.dart'
    as _i9;
import 'feature/emotion_statistics/infrastructure/providers/interfaces/i_emotion_statistics_provider.dart'
    as _i696;
import 'feature/emotion_statistics/infrastructure/repositories/emotion_statistics_repository.dart'
    as _i446;
import 'feature/generated_image/application/generated_image_bloc.dart' as _i618;
import 'feature/generated_image/domain/repositories/interfaces/i_generated_image_repository.dart'
    as _i894;
import 'feature/generated_image/infrastructure/providers/generated_image_local_provider.dart'
    as _i707;
import 'feature/generated_image/infrastructure/providers/interfaces/i_generated_image_local_provider.dart'
    as _i1046;
import 'feature/generated_image/infrastructure/repositories/generate_image_repository.dart'
    as _i880;
import 'feature/global_loading/application/global_loading_bloc.dart' as _i147;
import 'feature/lock/application/lock_cubit.dart' as _i600;
import 'feature/lock/domain/repositories/interfaces/i_local_authenticator_repository.dart'
    as _i828;
import 'feature/lock/domain/repositories/interfaces/i_lock_repository.dart'
    as _i554;
import 'feature/lock/infrastructure/providers/interfaces/i_local_authenticator_provider.dart'
    as _i895;
import 'feature/lock/infrastructure/providers/interfaces/i_local_lock_provider.dart'
    as _i27;
import 'feature/lock/infrastructure/providers/local_authenticator_provider.dart'
    as _i911;
import 'feature/lock/infrastructure/providers/local_lock_provider.dart'
    as _i625;
import 'feature/lock/infrastructure/repositories/local_authenticator_repository.dart'
    as _i845;
import 'feature/lock/infrastructure/repositories/lock_repository.dart' as _i522;
import 'feature/moment/application/moments/moment_list_bloc.dart' as _i269;
import 'feature/moment/moment_calendar/application/moment_calendar_bloc.dart'
    as _i307;
import 'feature/moment/moment_list/domain/interface/i_moment_list_repository.dart'
    as _i1053;
import 'feature/moment/write_moment/application/write_moment_bloc.dart'
    as _i812;
import 'feature/moment/write_moment/domain/interface/i_write_moment_repository.dart'
    as _i79;
import 'feature/moment/write_moment/infrastucture/interfaces/i_write_moment_external_provider.dart'
    as _i1039;
import 'feature/moment/write_moment/infrastucture/interfaces/i_write_moment_internal_provider.dart'
    as _i772;
import 'feature/moment/write_moment/infrastucture/interfaces/i_write_moment_local_provider.dart'
    as _i468;
import 'feature/moment/write_moment/infrastucture/providers/write_moment_external_provider.dart'
    as _i550;
import 'feature/moment/write_moment/infrastucture/providers/write_moment_internal_provider.dart'
    as _i603;
import 'feature/moment/write_moment/infrastucture/providers/write_moment_local_provider.dart'
    as _i220;
import 'feature/moment/write_moment/infrastucture/repositories/write_moment_repository.dart'
    as _i767;
import 'feature/recommend/application/recommend_bloc.dart' as _i507;
import 'feature/recommend/domain/repositories/interfaces/i_recommend_repository.dart'
    as _i142;
import 'feature/recommend/infrastructure/repositories/recommend_repository.dart'
    as _i877;
import 'feature/settings/application/settings_bloc.dart' as _i584;
import 'feature/settings/configurations/backup/application/backup_bloc.dart'
    as _i186;
import 'feature/settings/configurations/backup/domain/repositories/interfaces/i_backup_repository.dart'
    as _i955;
import 'feature/settings/configurations/backup/infrastructure/providers/backup_local_provider.dart'
    as _i754;
import 'feature/settings/configurations/backup/infrastructure/providers/backup_remote_provider.dart'
    as _i93;
import 'feature/settings/configurations/backup/infrastructure/providers/interfaces/i_backup_local_provider.dart'
    as _i1020;
import 'feature/settings/configurations/backup/infrastructure/providers/interfaces/i_backup_remote_provider.dart'
    as _i359;
import 'feature/settings/configurations/backup/infrastructure/repositories/backup_repository.dart'
    as _i35;
import 'feature/settings/configurations/language/application/language_bloc.dart'
    as _i136;
import 'feature/settings/configurations/version/application/version_bloc.dart'
    as _i635;
import 'feature/settings/configurations/version/domain/repositories/interfaces/i_version_repository.dart'
    as _i170;
import 'feature/settings/configurations/version/infrastructure/providers/interfaces/i_version_local_provider.dart'
    as _i743;
import 'feature/settings/configurations/version/infrastructure/providers/version_local_provider.dart'
    as _i550;
import 'feature/settings/configurations/version/infrastructure/repositories/version_repository.dart'
    as _i191;
import 'feature/settings/settings_controller.dart' as _i890;
import 'feature/settings/settings_service.dart' as _i778;
import 'feature/signin/application/signin_bloc.dart' as _i47;
import 'feature/signin/domain/interfaces/i_auth_repository.dart' as _i738;
import 'feature/signin/infrastructure/providers/interfaces/superbase_auth_provider.dart'
    as _i42;
import 'feature/signin/infrastructure/providers/supabase_auth_provider.dart'
    as _i65;
import 'feature/signin/infrastructure/repositories/auth_repository.dart'
    as _i174;
import 'feature/user/application/user_bloc.dart' as _i428;
import 'feature/user/domain/interfaces/i_user_repository.dart' as _i586;
import 'feature/user/infrastructure/providers/interfaces/i_superbase_user_external_provider.dart'
    as _i633;
import 'feature/user/infrastructure/providers/interfaces/i_user_internal_provider.dart'
    as _i24;
import 'feature/user/infrastructure/providers/supabase_user_external_provider.dart'
    as _i48;
import 'feature/user/infrastructure/providers/user_internal_provider.dart'
    as _i672;
import 'feature/user/infrastructure/repositories/user_repository.dart' as _i885;
import 'native/icloud/icloud_service.dart' as _i178;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioModule = _$DioModule();
    final remoteConfigModule = _$RemoteConfigModule();
    final supabaseModule = _$SupabaseModule();
    gh.factory<_i584.SettingsBloc>(() => _i584.SettingsBloc());
    gh.factory<_i307.MomentCalendarBloc>(() => _i307.MomentCalendarBloc());
    gh.singleton<_i681.Gemini>(() => _i681.Gemini());
    gh.singleton<_i891.FileManager>(() => _i891.FileManager());
    gh.singleton<_i917.ImagePickerClient>(() => _i917.ImagePickerClient());
    gh.singleton<_i248.FirebaseClient>(() => _i248.FirebaseClient());
    gh.singleton<_i178.ICloudService>(() => _i178.ICloudService());
    gh.singleton<_i778.SettingsService>(() => _i778.SettingsService());
    gh.lazySingleton<_i694.FeatureManager>(() => _i694.FeatureManager());
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i627.FirebaseRemoteConfig>(
        () => remoteConfigModule.firebaseRemoteConfig);
    gh.lazySingleton<_i454.SupabaseClient>(
        () => supabaseModule.supabaseClient());
    gh.lazySingleton<_i735.DeepLinkService>(() => _i735.DeepLinkService.new());
    gh.lazySingleton<_i958.AnalyticsManager>(() => _i958.AnalyticsManager());
    gh.lazySingleton<_i461.Bus>(() => _i461.Bus());
    gh.singleton<_i297.RemoteConfigClient>(
        () => _i297.RemoteConfigClient(gh<_i627.FirebaseRemoteConfig>()));
    gh.lazySingleton<_i633.ISupabaseUserExternalProvider>(
        () => _i48.SupabaseUserExternalProvider(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i743.IVersionLocalProvider>(
        () => _i550.VersionLocalProvider());
    gh.lazySingleton<_i1039.IWriteMomentExternalProvider>(
        () => _i550.WriteMomentExternalProvider(
              gh<_i681.Gemini>(),
              gh<_i248.FirebaseClient>(),
            ));
    gh.lazySingleton<_i42.ISupabaseAuthProvider>(
        () => _i65.SupabaseAuthProvider(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i170.IVersionRepository>(
        () => _i191.VersionRepository(gh<_i743.IVersionLocalProvider>()));
    gh.lazySingleton<_i951.HiveClient>(() => const _i951.HiveClientImpl());
    gh.factory<_i895.IAuthenticatorProvider>(
        () => _i911.LocalAuthenticatorProvider());
    gh.lazySingleton<_i579.IMediaInfoLocalProvider>(
        () => _i1061.MediaInfoLocalProvider());
    gh.lazySingleton<_i738.IAuthRepository>(
        () => _i174.AuthRepository(gh<_i42.ISupabaseAuthProvider>()));
    gh.singleton<_i356.HttpClient>(() => _i356.HttpClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i359.IBackupRemoteProvider>(
        () => _i93.BackupRemoteProvider(gh<_i178.ICloudService>()));
    gh.lazySingleton<_i23.IDeviceInfoLocalProvider>(
        () => _i505.DeviceInfoLocalProvider());
    gh.singleton<_i587.Database>(() => _i587.Database(gh<String>()));
    gh.lazySingleton<_i772.IWriteMomentInternalProvider>(
        () => _i603.WriteMomentInternalProvider(gh<_i356.HttpClient>()));
    gh.factory<_i740.DeepLinkCubit>(
        () => _i740.DeepLinkCubit(gh<_i735.DeepLinkService>()));
    gh.factory<_i635.VersionBloc>(
        () => _i635.VersionBloc(gh<_i170.IVersionRepository>()));
    gh.factory<_i47.SignInBloc>(() => _i47.SignInBloc(
          gh<_i738.IAuthRepository>(),
          gh<_i461.Bus>(),
        ));
    gh.lazySingleton<_i1057.IMediaInfoRepository>(
        () => _i1047.MediaInfoRepository(gh<_i579.IMediaInfoLocalProvider>()));
    gh.lazySingleton<_i828.IAuthenticatorRepository>(() =>
        _i845.LocalAuthenticatorRepository(
            authenticatorProvider: gh<_i895.IAuthenticatorProvider>()));
    gh.singleton<_i407.DriftClient>(
        () => _i407.DriftClientImpl(gh<_i587.Database>()));
    gh.singleton<_i890.SettingsController>(
        () => _i890.SettingsController(gh<_i778.SettingsService>()));
    gh.factory<_i147.GlobalLoadingBloc>(
        () => _i147.GlobalLoadingBloc(gh<_i461.Bus>()));
    gh.lazySingleton<_i190.ToastBloc>(() => _i190.ToastBloc(gh<_i461.Bus>()));
    gh.lazySingleton<_i27.ILocalLockProvider>(
        () => _i625.LocalLockProvider(hiveClient: gh<_i951.HiveClient>()));
    gh.lazySingleton<_i1020.IBackupLocalProvider>(
        () => _i754.BackupLocalProvider(
              gh<_i587.Database>(),
              gh<_i407.DriftClient>(),
            ));
    gh.lazySingleton<_i24.IUserInternalProvider>(
        () => _i672.UserInternalProvider(gh<_i407.DriftClient>()));
    gh.factory<_i163.ILocalDataControlProvider>(
        () => _i186.LocalDataControlProvider(gh<_i951.HiveClient>()));
    gh.lazySingleton<_i1018.IDataControlRepository>(() =>
        _i489.DataControlRepository(
            dataControlProvider: gh<_i163.ILocalDataControlProvider>()));
    gh.factory<_i468.IWriteMomentLocalProvider>(
        () => _i220.WriteMomentLocalProvider(gh<_i407.DriftClient>()));
    gh.lazySingleton<_i586.IUserRepository>(() => _i885.UserRepository(
          gh<_i633.ISupabaseUserExternalProvider>(),
          gh<_i24.IUserInternalProvider>(),
        ));
    gh.lazySingleton<_i696.IEmotionStatisticsProvider>(
        () => _i9.EmotionStatisticsProvider(gh<_i407.DriftClient>()));
    gh.lazySingleton<_i1046.IGeneratedImageLocalProvider>(
        () => _i707.GeneratedImageLocalProvider(gh<_i407.DriftClient>()));
    gh.lazySingleton<_i67.MomentSeeder>(
        () => _i67.MomentSeeder(gh<_i407.DriftClient>()));
    gh.lazySingleton<_i955.IBackupRepository>(() => _i35.BackupRepository(
          remoteProvider: gh<_i359.IBackupRemoteProvider>(),
          localProvider: gh<_i1020.IBackupLocalProvider>(),
        ));
    gh.lazySingleton<_i1.DataControlBloc>(() => _i1.DataControlBloc(
          dataControlRepository: gh<_i1018.IDataControlRepository>(),
          authenticatorRepository: gh<_i828.IAuthenticatorRepository>(),
        ));
    gh.factory<_i579.IMomentListLocalProvider>(
        () => _i209.MomentListLocalProvider(
              gh<_i587.Database>(),
              gh<_i407.DriftClient>(),
            ));
    gh.factory<_i136.LanguageCubit>(
        () => _i136.LanguageCubit(gh<_i890.SettingsController>()));
    gh.lazySingleton<_i79.IWriteMomentRepository>(() =>
        _i767.WriteMomentRepository(
          writeMomentExternalProvider:
              gh<_i1039.IWriteMomentExternalProvider>(),
          writeMomentInternalProvider: gh<_i772.IWriteMomentInternalProvider>(),
          writeMomentLocalProvider: gh<_i468.IWriteMomentLocalProvider>(),
          deviceInfoLocalProvider: gh<_i23.IDeviceInfoLocalProvider>(),
          mediaInfoLocalProvider: gh<_i579.IMediaInfoLocalProvider>(),
          driftClient: gh<_i407.DriftClient>(),
        ));
    gh.factory<_i1053.IMomentListRepository>(() => _i690.MomentListRepository(
          gh<_i579.IMomentListLocalProvider>(),
          gh<_i407.DriftClient>(),
        ));
    gh.lazySingleton<_i554.ILockRepository>(() =>
        _i522.LockRepository(localLockProvider: gh<_i27.ILocalLockProvider>()));
    gh.lazySingleton<_i142.IRecommendRepository>(
        () => _i877.RecommendRepository(
              localLockProvider: gh<_i27.ILocalLockProvider>(),
              localDataControlProvider: gh<_i163.ILocalDataControlProvider>(),
            ));
    gh.lazySingleton<_i535.IEmotionStatisticsRepository>(() =>
        _i446.EmotionStatisticsRepository(
            gh<_i696.IEmotionStatisticsProvider>()));
    gh.factory<_i186.BackupBloc>(
        () => _i186.BackupBloc(gh<_i955.IBackupRepository>()));
    gh.factoryParam<_i812.WriteMomentBloc, _i517.Moment?, DateTime>((
      moment,
      date,
    ) =>
        _i812.WriteMomentBloc(
          gh<_i461.Bus>(),
          moment,
          date,
          gh<_i79.IWriteMomentRepository>(),
        ));
    gh.singleton<_i428.UserBloc>(() => _i428.UserBloc(
          gh<_i586.IUserRepository>(),
          gh<_i461.Bus>(),
        ));
    gh.lazySingleton<_i894.IGeneratedImageRepository>(
        () => _i880.GenerateImageRepository(
              gh<_i1046.IGeneratedImageLocalProvider>(),
              gh<_i579.IMediaInfoLocalProvider>(),
            ));
    gh.factory<_i507.RecommendBloc>(() => _i507.RecommendBloc(
          gh<_i461.Bus>(),
          gh<_i142.IRecommendRepository>(),
        ));
    gh.factory<_i383.EmotionalStatisticsBloc>(() =>
        _i383.EmotionalStatisticsBloc(
            gh<_i535.IEmotionStatisticsRepository>()));
    gh.factoryParam<_i618.GeneratedImageBloc, _i517.Moment?, dynamic>((
      moment,
      _,
    ) =>
        _i618.GeneratedImageBloc(
          gh<_i894.IGeneratedImageRepository>(),
          gh<_i1057.IMediaInfoRepository>(),
          moment,
          gh<_i461.Bus>(),
        ));
    gh.factory<_i269.MomentListBloc>(() => _i269.MomentListBloc(
          gh<_i461.Bus>(),
          gh<_i1053.IMomentListRepository>(),
        ));
    gh.singleton<_i600.LockCubit>(() => _i600.LockCubit(
          authenticatorRepository: gh<_i828.IAuthenticatorRepository>(),
          lockRepository: gh<_i554.ILockRepository>(),
          passcode: gh<String>(),
        ));
    return this;
  }
}

class _$DioModule extends _i871.DioModule {}

class _$RemoteConfigModule extends _i407.RemoteConfigModule {}

class _$SupabaseModule extends _i850.SupabaseModule {}
