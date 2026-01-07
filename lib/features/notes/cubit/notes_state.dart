import 'package:equatable/equatable.dart';
import '../models/note_model.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<NoteModel> notes;
  final String searchQuery;

  const NotesLoaded({required this.notes, this.searchQuery = ''});

  List<NoteModel> get filteredNotes {
    if (searchQuery.isEmpty) return notes;
    return notes
        .where((note) =>
            note.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  List<Object?> get props => [notes, searchQuery];
}

class NotesError extends NotesState {
  final String message;
  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}
