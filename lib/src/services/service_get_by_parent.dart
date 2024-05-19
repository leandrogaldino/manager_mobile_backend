abstract class ServiceGetByParent<T> {
  Future<List<T>> getByParentId(int parentId);
}
