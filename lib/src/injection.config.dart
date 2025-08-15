// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'bus/bus.dart' as _i461;
import 'core/analytics/analytics_manager.dart' as _i958;
import 'core/device/infrastructure/interfaces/i_device_info_local_provider.dart'
    as _i23;
import 'core/device/infrastructure/providers/device_info_local_provider.dart'
    as _i505;
import 'core/file/file_manager.dart' as _i891;
import 'core/firebase/firebase_client.dart' as _i248;
import 'core/http_client/dio_module.dart' as _i871;
import 'core/http_client/http_client.dart' as _i356;
import 'core/image_picker/image_picker_client.dart' as _i917;
import 'core/llm/llm_service.dart' as _i681;
import 'core/media/infrastructure/interfaces/i_media_info_local_provider.dart'
    as _i130;
import 'core/media/infrastructure/providers/media_info_local_provider.dart'
    as _i1061;
import 'database/app_database.dart' as _i587;
import 'feature/moment/application/moments/moment_list_bloc.dart' as _i269;
import 'feature/moment/domain/entity/moment.dart' as _i900;
import 'feature/moment/moment_calendar/application/moment_calendar_bloc.dart'
    as _i307;
import 'feature/moment/moment_list/domain/interface/i_moment_list_repository.dart'
    as _i1053;
import 'feature/moment/moment_list/infrastructure/interfaces/i_moment_list_local_provider.dart'
    as _i63;
import 'feature/moment/moment_list/infrastructure/providers/moment_list_local_provider.dart'
    as _i801;
import 'feature/moment/moment_list/infrastructure/repositories/moment_list_repository.dart'
    as _i203;
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
import 'feature/settings/application/settings_bloc.dart' as _i584;

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
    gh.factory<_i584.SettingsBloc>(() => _i584.SettingsBloc());
    gh.factory<_i307.MomentCalendarBloc>(() => _i307.MomentCalendarBloc());
    gh.singleton<_i681.Gemini>(() => _i681.Gemini());
    gh.singleton<_i891.FileManager>(() => _i891.FileManager());
    gh.singleton<_i917.ImagePickerClient>(() => _i917.ImagePickerClient());
    gh.singleton<_i248.FirebaseClient>(() => _i248.FirebaseClient());
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i958.AnalyticsManager>(() => _i958.AnalyticsManager());
    gh.lazySingleton<_i461.Bus>(() => _i461.Bus());
    gh.lazySingleton<_i1039.IWriteMomentExternalProvider>(
        () => _i550.WriteMomentExternalProvider(
              gh<_i681.Gemini>(),
              gh<_i248.FirebaseClient>(),
            ));
    gh.singleton<_i356.HttpClient>(() => _i356.HttpClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i130.IMeidaInfoLocalProvider>(
        () => _i1061.MediaInfoLocalProvider());
    gh.lazySingleton<_i23.IDeviceInfoLocalProvider>(
        () => _i505.DeviceInfoLocalProvider());
    gh.singleton<_i587.Database>(() => _i587.Database(gh<String>()));
    gh.lazySingleton<_i772.IWriteMomentInternalProvider>(
        () => _i603.WriteMomentInternalProvider(gh<_i356.HttpClient>()));
    gh.factory<_i468.IWriteMomentLocalProvider>(
        () => _i220.WriteMomentLocalProvider(gh<_i587.Database>()));
    gh.lazySingleton<_i79.IWriteMomentRepository>(() =>
        _i767.WriteMomentRepository(
          writeMomentExternalProvider:
              gh<_i1039.IWriteMomentExternalProvider>(),
          writeMomentInternalProvider: gh<_i772.IWriteMomentInternalProvider>(),
          writeMomentLocalProvider: gh<_i468.IWriteMomentLocalProvider>(),
          deviceInfoLocalProvider: gh<_i23.IDeviceInfoLocalProvider>(),
          mediaInfoLocalProvider: gh<_i130.IMeidaInfoLocalProvider>(),
        ));
    gh.factoryParam<_i812.WriteMomentBloc, _i900.Moment?, DateTime>((
      moment,
      date,
    ) =>
        _i812.WriteMomentBloc(
          gh<_i461.Bus>(),
          moment,
          date,
          gh<_i79.IWriteMomentRepository>(),
        ));
    gh.factory<_i63.IMomentListLocalProvider>(
        () => _i801.MomentListLocalProvider(gh<_i587.Database>()));
    gh.factory<_i1053.IMomentListRepository>(
        () => _i203.MomentListRepository(gh<_i63.IMomentListLocalProvider>()));
    gh.factory<_i269.MomentListBloc>(() => _i269.MomentListBloc(
          gh<_i461.Bus>(),
          gh<_i1053.IMomentListRepository>(),
        ));
    return this;
  }
}

class _$DioModule extends _i871.DioModule {}
