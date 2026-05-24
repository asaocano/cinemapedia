//* Errores generales 
/// Problema con la red
class NetworkException implements Exception {} 

/// Acceso no autorizado
class UnauthorizedException implements Exception {} 

/// Error general
class GeneralException implements Exception{}

//* Errores de api
/// Error con the MovieDB API
class MovieDbException implements Exception {} 

//* Errores de películas/actores
/// Actor no encontrado
class ActorNotFoundException implements Exception {} 

///Película no encontrada
class MovieNotFoundException implements Exception {}