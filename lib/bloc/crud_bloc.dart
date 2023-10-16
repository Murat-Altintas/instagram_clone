import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/extensions.dart';

part 'crud_event.dart';

part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  var firebase = FirebaseFirestore.instance;

  CrudBloc() : super(const CrudState()) {
    on<CrudInitialEvent>(crudInitialEvent);
    on<CrudLoginEvent>(crudLoginEvent);
    on<CrudAddUserEvent>(crudAddUserEvent);
    on<CrudLogoutEvent>(crudLogoutEvent);
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> crudInitialEvent(CrudInitialEvent event, Emitter<CrudState> emit) async {
    emit(CrudInitialState());
  }

  Future<void> crudLoginEvent(CrudLoginEvent event, Emitter<CrudState> emit) async {
    await db.collection("users").get().then((value) {
      for (var doc in value.docs) {
        if (doc.data().containsValue(event.mail) && doc.data().containsValue(event.pass)) {
          doc.data().log();
          emit(CrudSuccessfulState());
        }
      }
    });
  }

  Future<void> crudAddUserEvent(CrudAddUserEvent event, Emitter<CrudState> emit) async {
    late Map<String, dynamic> currentUsersData = {};
    final Map<String, dynamic> newUsers = {"mail": event.mail, "pass": event.pass};

    //TODO: çok hızlı "Add User" a basarsam await'ten önce algılayıp tekrar ekliyor. Yani başka bir neden bulamadım. Mümkün mü? :D
    await db.collection("users").get().then((value) {
      for (var element in value.docs) {
        currentUsersData = element.data();
      }

      if (!currentUsersData.keys.contains(event.mail) && !currentUsersData.values.contains(event.pass)) {
        db.collection("users").add(newUsers);
        emit(CrudSuccessfulState());
      }
    });
  }

  Future<void> crudLogoutEvent(CrudLogoutEvent event, Emitter<CrudState> emit) async {
    emit(CrudInitialState());
  }
}
