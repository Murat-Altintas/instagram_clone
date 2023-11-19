part of 'crud_bloc.dart';

 class CrudState extends Equatable {
  const CrudState();

  @override
  List<Object?> get props => [];
}

class CrudSuccessfulState extends CrudState {}

class CrudLoadingState extends CrudState {}

class CrudErrorState extends CrudState {
  final String error;

  const CrudErrorState({required this.error});
}

class CrudDataLoadedState extends CrudState {
}

class CrudLogoutState extends CrudState {}

class CrudInitialState extends CrudState {}