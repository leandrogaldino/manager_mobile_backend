abstract class ServiceGetByDate<T> {
  Future<List<T>> getByDate(DateTime start, DateTime end);
}
