class NavigationStateDTO {
  bool isTodos;
  String? todoUuid;
  NavigationStateDTO(this.isTodos, this.todoUuid);
  NavigationStateDTO.todos()
      : isTodos = false,
        todoUuid = null;
  NavigationStateDTO.create()
      : isTodos = true,
        todoUuid = null;
  NavigationStateDTO.todo(String? id)
      : isTodos = true,
        todoUuid = id;
}
