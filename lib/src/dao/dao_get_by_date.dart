abstract class GetByDateDAO<T> {
  Future<List<T>> getByDate(DateTime start, DateTime end);
}
