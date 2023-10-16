part of 'crud_bloc.dart';

abstract class CrudEvent extends Equatable {
  const CrudEvent();

  @override
  List<Object?> get props => [];
}

class CrudLoginEvent extends CrudEvent {
  final int pass;
  final String mail;

  const CrudLoginEvent({required this.pass, required this.mail});
}

class CrudAddUserEvent extends CrudEvent {
  final int pass;
  final String mail;

  const CrudAddUserEvent({required this.pass, required this.mail});
}

class CrudInitialEvent extends CrudEvent {}

class CrudLogoutEvent extends CrudEvent {}