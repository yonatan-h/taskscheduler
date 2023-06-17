import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_scheduler/data_providers/notifications_db.dart';
import 'package:task_scheduler/data_providers/tasks_db.dart';
import 'package:task_scheduler/models/task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksDataProvider tasksDataProvider;
  NotificationsDataProvider notificationsDataProvider;
  TasksBloc(
      {required this.tasksDataProvider,
      required this.notificationsDataProvider})
      : super(TasksInitial()) {
    notificationsDataProvider.stream
        .listen((event) => add(ReminderDisplayed()));

    on<GetTasksFromDataBase>(_fecthData);
    on<CreateNewTask>(_createTask);
    on<EditTasks>(_editTasks);
    on<MoveTask>(_reorderTasks);
    on<DoneTask>(_deleteTask);
    on<ReminderDisplayed>(_refreshReminders);
  }
  _fecthData(event, emit) async {
    emit(TasksLoading());
    try {
      List<Task> taskList = await tasksDataProvider.getTasks();
      if (taskList.isEmpty) {
        emit(NoTasks());
      } else {
        emit(TasksLoaded(task: taskList, status: TaskProgress.None));
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      emit(TaskError());
    }
  }

  _createTask(CreateNewTask event, emit) async {
    if (state is TasksLoaded || state is NoTasks) {
      final Task taskCreated = event.newTask;
      List<Task> newTaskList = [];

      if (state is TasksLoaded) {
        newTaskList = List.of((state as TasksLoaded).task);
      }

      newTaskList.add(taskCreated);
      emit(TaskSuccess());
      await Future.delayed(Duration(seconds: 1));

      await notificationsDataProvider.replaceReminders(newTaskList);
      await tasksDataProvider.replaceTasks(newTaskList);
      newTaskList = await tasksDataProvider.getTasks();

      emit(TasksLoaded(task: newTaskList, status: TaskProgress.Create));
    }
  }

  _editTasks(EditTasks event, emit) async {
    if (state is TasksLoaded) {
      int index = 0;
      final _state = state as TasksLoaded;
      List<Task> newTask = List.of(_state.task);
      while (newTask[index].id != event.id) index++;
      newTask[index].content = event.updatedTask;

      emit(TasksLoading());

      await notificationsDataProvider.replaceReminders(newTask);
      await tasksDataProvider.replaceTasks(newTask);
      newTask = await tasksDataProvider.getTasks();

      await Future.delayed(Duration(seconds: 0));
      emit(TasksLoaded(task: newTask, status: TaskProgress.Edit));
    }
  }

  _reorderTasks(MoveTask event, emit) async {
    if (state is TasksLoaded) {
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

      await notificationsDataProvider.replaceReminders(orderedTask);
      await tasksDataProvider.replaceTasks(orderedTask);
      orderedTask = await tasksDataProvider.getTasks();

      emit(TasksLoaded(task: orderedTask, status: TaskProgress.None));
    }
  }

  _deleteTask(DoneTask event, emit) async {
    if (state is TasksLoaded) {
      final _state = state as TasksLoaded;
      List<Task> newTaskList = List.of(_state.task);
      int index = 0;
      while (newTaskList[index].id != event.id) index++;
      newTaskList.removeAt(index);

      await notificationsDataProvider.replaceReminders(newTaskList);
      await tasksDataProvider.replaceTasks(newTaskList);
      newTaskList = await tasksDataProvider.getTasks();

      if (newTaskList.isEmpty)
        emit(NoTasks());
      else {
        emit(TasksLoaded(task: newTaskList, status: TaskProgress.Done));
      }
    }
  }

  _refreshReminders(ReminderDisplayed event, emit) async {
    print('refresh is called');
    if (state is TasksLoaded) {
      final _state = state as TasksLoaded;
      List<Task> tasks = List.of(_state.task);

      emit(TasksLoading());

      await notificationsDataProvider.replaceReminders(tasks);
      await tasksDataProvider.replaceTasks(tasks);
      tasks = await tasksDataProvider.getTasks();

      emit(TasksLoaded(task: tasks, status: TaskProgress.None));
    }
  }
}
