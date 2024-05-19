abstract class Database<T> {
  Future<T> createConnection();
  Future<T> get connection;
}
