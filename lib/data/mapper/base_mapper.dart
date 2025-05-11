abstract class BaseMapper<D, E> {
  D toDTO(E entity);
  E toEntity(D dto);
}