part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class GetTasksFromDataBase extends TasksEvent {}

class SetReminder extends TasksEvent {}

class CreateNewTask extends TasksEvent {
  final Task newTask;

  CreateNewTask(this.newTask);

  @override
  List<Object> get props => [newTask];
}

class EditTasks extends TasksEvent {}

class MoveTask extends TasksEvent {
  final int id;
  final MovementDirection direction;

  MoveTask(this.id, this.direction);

  @override
  List<Object> get props => [id, direction];
}

enum MovementDirection { up, down }

class DoneTask extends TasksEvent {
  final int index;

  DoneTask(this.index);
  
  @override
  List<Object> get props => [index,];

}
