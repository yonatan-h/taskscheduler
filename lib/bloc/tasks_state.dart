part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> task;
  final TaskProgress status;

  TasksLoaded({required this.task, required this.status});

  @override
  List<Object> get props => [task, status];
}

class TasksDone extends TasksState {}

class TaskError extends TasksState {}

class TaskSuccess extends TasksState {}

class TasksFailure extends TasksState {}

class NoTasks extends TasksState {}

enum TaskProgress { Create, Done, Edit, None, Notification }

class TaskNotification extends TasksState {
  final Task task;
  TaskNotification(this.task);
}
