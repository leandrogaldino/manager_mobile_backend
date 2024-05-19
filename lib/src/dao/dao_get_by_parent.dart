abstract class GetByParentDAO<T> {
  Future<List<T>> getByParentId(int parentId);
}
