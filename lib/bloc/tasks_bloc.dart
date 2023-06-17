import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:task_scheduler/db.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  DataProvider dataProvider;
  TasksBloc({required this.dataProvider}) : super(TasksInitial()) {
    on<GetTasksFromDataBase>(_fecthData);
    on<CreateNewTask>(_createTask);
    on<EditTasks>(_editTasks);
    on<MoveTask>(_reorderTasks);
    on<DoneTask>(_deleteTask);
  }
  _fecthData(event, emit) async {
    emit(TasksLoading());
    try {
      List<Task> taskList = await dataProvider.getTasks();
      if (taskList.isEmpty) {
        emit(NoTasks());
      } else {
        emit(TasksLoaded(task: taskList, status: TaskProgress.None));
      }
    } catch (e) {
      emit(TaskError());
    }
  }

  _createTask(CreateNewTask event, emit) async {
    if (state is TasksLoaded) {
      final Task taskCreated = event.newTask;
      final List<Task> newTaskList = List.of((state as TasksLoaded).task);

      newTaskList.add(taskCreated);
      emit(TaskSuccess());
      await Future.delayed(Duration(seconds: 1));

      emit(TasksLoaded(task: newTaskList, status: TaskProgress.Create));
    }
  }

  _editTasks(event, emit) {
    //pass for now
  }
  _reorderTasks(MoveTask event, emit) async {
    if (state is TasksLoaded) {
      print("Someone is being called here");
      final _state = state as TasksLoaded;
      int index = 0;
      while (_state.task[index].id! != event.id) {
        index++;
      }
      List<Task> orderedTask = List.of(_state.task);
      if (event.direction == MovementDirection.up && index > 0) {
        Task temp = orderedTask[index];
        orderedTask[index] = orderedTask[index - 1];
        orderedTask[index - 1] = temp;
      } else if (event.direction == MovementDirection.down &&
          index < orderedTask.length - 1) {
        Task temp = orderedTask[index];
        orderedTask[index] = orderedTask[index + 1];
        orderedTask[index + 1] = temp;
      }

      await dataProvider.replaceTasks(orderedTask);
      emit(TasksLoaded(task: orderedTask, status: TaskProgress.None));
    }
  }

  _deleteTask(DoneTask event, emit) async {
    if (state is TasksLoaded) {
      final _state = state as TasksLoaded;
      List<Task> newTaskList = List.of(_state.task);
      newTaskList.removeAt(event.index);
      if (newTaskList.isEmpty)
        emit(NoTasks());
      else {
        emit(TasksLoaded(task: newTaskList, status: TaskProgress.Done));
      }
    }
  }
}
