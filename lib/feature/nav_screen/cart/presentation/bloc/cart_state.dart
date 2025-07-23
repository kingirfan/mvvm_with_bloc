part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  final String id;

  const CartSuccess({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

final class CartFailure extends CartState {
  final AppException error;

  const CartFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
