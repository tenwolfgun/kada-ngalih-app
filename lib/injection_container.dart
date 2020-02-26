import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'core/platform/device_location.dart';
import 'core/util/input_converter.dart';
import 'features/nearby_location/data/datasources/nearby_location_remote_data_source.dart';
import 'features/nearby_location/data/repositories/nearby_location_repository_impl.dart';
import 'features/nearby_location/domain/repositories/nearby_location_repository.dart';
import 'features/nearby_location/domain/usecases/get_nearby_location.dart';
import 'features/nearby_location/presentation/bloc/nearby_location_bloc.dart';

var sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => NearbyLocationBloc(
      getNearbyLocation: sl(),
      inputConverter: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetNearbyLocation(sl()));

  // Repository
  sl.registerLazySingleton<NearbyLocationRepository>(
    () => NearbyLocationRepositoryImpl(
      deviceLocation: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data Source
  sl.registerLazySingleton<NearbyLocationRemoteDataSource>(
    () => NearbyLocationRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  // core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<DeviceLocation>(
    () => DeviceLocationImpl(
      sl(),
    ),
  );

  // external
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => PermissionHandler());
}
