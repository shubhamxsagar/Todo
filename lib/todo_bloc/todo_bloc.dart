import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:todo/data/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends HydratedBloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    // TODO: implement event handler\
    on<TodoStatred>(_onStarted);
    on<AddTodo>(_onAddTodo);
    on<RemoveTodo>(_onRemoveTodo);
    on<AlterTodo>(_onAlterTodo);
  }

  void _onStarted(
    TodoEvent event,
    Emitter<TodoState> emit,
  ) {
    if (state.status == TodoStatus.success) return;
    emit(state.copyWith(todos: state.todos, status: TodoStatus.success));
  }

  void _onAddTodo(
    AddTodo event,
    Emitter<TodoState> emit,
  ) {
    emit(state.copyWith(
      status: TodoStatus.success,
    ));
    try {
      List<Todo> temp = [];
      temp.addAll(state.todos);
      temp.insert(0, event.todo);
      emit(
        state.copyWith(
          todos: temp,
          status: TodoStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
        ),
      );
    }
  }

  void _onRemoveTodo(
    RemoveTodo event,
    Emitter<TodoState> emit,
  ) {
    emit(state.copyWith(
      status: TodoStatus.loading,
    ));
    try {
      state.todos.remove(event.todo);
      emit(
        state.copyWith(
          todos: state.todos,
          status: TodoStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
        ),
      );
    }
  }

  void _onAlterTodo(
    AlterTodo event,
    Emitter<TodoState> emit,
  ) {
    emit(state.copyWith(
      status: TodoStatus.loading,
    ));
    try {
      state.todos[event.index].isDone = !state.todos[event.index].isDone;
      emit(
        state.copyWith(
          todos: state.todos,
          status: TodoStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
        ),
      );
    }
  }

  @override
  TodoState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return TodoState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {
    // TODO: implement toJson
    return state.toJson();
  }
}
