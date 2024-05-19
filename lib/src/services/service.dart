abstract class Service<T> {
  Future<T?> getById(int id);
  Future<T> save(T value);
  Future<bool> delete(int id);
}
