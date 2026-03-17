import 'package:cinemapedia/infrastructure/datasources/drift_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/local_storage_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider usado para obtener y usar las películas guardadas en la bd local
final localStorageRepositoryProvider = Provider((ref) {
  //Implementación del repositorio que usará la bd local
  return LocalStorageRepositoryImplementation(datasource: DriftDatasource()); //Se usa la bd local de drift y ahí vienen los métodos que interactúan directamente con la bd
});
