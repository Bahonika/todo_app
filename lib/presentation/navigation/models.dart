class NavigationStateDTO {
  bool isTodos;
  String? todoUuid;
  NavigationStateDTO(this.isTodos, this.todoUuid);
  NavigationStateDTO.todos()
      : isTodos = true,
        todoUuid = null;
  NavigationStateDTO.create()
      : isTodos = false,
        todoUuid = null;
  NavigationStateDTO.todo(String? id)
      : isTodos = false,
        todoUuid = id;
}
