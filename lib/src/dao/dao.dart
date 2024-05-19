abstract class DAO<T> {
  Future<T> create(T value);
  Future<T> update(T value);
  Future<bool> delete(int id);
  Future<T?> getById(int id);
}
