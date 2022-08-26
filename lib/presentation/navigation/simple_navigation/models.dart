class BookId {
  String id;
  BookId(this.id);
}
class NavigationStateDTO {
  bool welcome;
  String? bookId;
  NavigationStateDTO(this.welcome, this.bookId);
  NavigationStateDTO.welcome()
      : welcome = true,
        bookId = null;
  NavigationStateDTO.books()
      : welcome = false,
        bookId = null;
  NavigationStateDTO.book(String id)
      : welcome = false,
        bookId = id;
}
