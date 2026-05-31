import 'package:cinemapedia/infrastructure/services/key_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageServiceImpl implements KeyValueStorageService {
  /**
   * Método para obtener la instancia de shared preferences
   */
  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  /**
   * Obtener el valor mediante la clave que se envía
   */
  Future<T?> getValue<T>(String key) async {
    final preferences = await getSharedPreferences();

    switch (T) {
      case int:
        return preferences.getInt(key) as T?;

      case String:
        return preferences.getString(key) as T?;
    }
  }

  @override
  /**
   * Método para eliminar un valor mediante la clave que se envía
   */
  Future<bool> removeKey(String key) async {
    final preferences = await getSharedPreferences();
    return await preferences.remove(key);
  }

  @override
  /**
   * Se establece un valor mediante la clave que se envía
   */
  Future<void> setKeyValue<T>(String key, T value) async {
    final preferences = await getSharedPreferences();

    switch (T) {
      case int:
        preferences.setInt(key, value as int);
        break;

      case String:
        preferences.setString(key, value as String);
        break;
    }
  }
}
