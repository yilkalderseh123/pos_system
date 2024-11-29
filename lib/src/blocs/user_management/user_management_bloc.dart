import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

// User Model
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'role': role,
      };

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
    );
  }
}

// States
abstract class UserManagementState extends Equatable {
  const UserManagementState();

  @override
  List<Object> get props => [];
}

class UserManagementInitial extends UserManagementState {}

class UserManagementLoaded extends UserManagementState {
  final List<User> users;

  const UserManagementLoaded(this.users);

  @override
  List<Object> get props => [users];
}

// Events
abstract class UserManagementEvent extends Equatable {
  const UserManagementEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserManagementEvent {}

class AddUser extends UserManagementEvent {
  final User user;

  const AddUser(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateUser extends UserManagementEvent {
  final User user;

  const UpdateUser(this.user);

  @override
  List<Object> get props => [user];
}

class DeleteUser extends UserManagementEvent {
  final String userId;

  const DeleteUser(this.userId);

  @override
  List<Object> get props => [userId];
}

// Bloc
class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  final Box<Map> userBox;

  UserManagementBloc({required this.userBox}) : super(UserManagementInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  void _onLoadUsers(LoadUsers event, Emitter<UserManagementState> emit) {
    final users = userBox.values
        .map((e) => User.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    emit(UserManagementLoaded(users));
  }

  void _onAddUser(AddUser event, Emitter<UserManagementState> emit) async {
    await userBox.put(event.user.id, event.user.toMap());
    add(LoadUsers());
  }

  void _onUpdateUser(
      UpdateUser event, Emitter<UserManagementState> emit) async {
    if (userBox.containsKey(event.user.id)) {
      await userBox.put(event.user.id, event.user.toMap());
      add(LoadUsers());
    }
  }

  void _onDeleteUser(
      DeleteUser event, Emitter<UserManagementState> emit) async {
    if (userBox.containsKey(event.userId)) {
      await userBox.delete(event.userId);
      add(LoadUsers());
    }
  }
}
