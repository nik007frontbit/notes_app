import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/notes_repository.dart';
import '../models/note_model.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NotesRepository _notesRepository;
  final String userId;
  StreamSubscription? _notesSubscription;

  NotesCubit({
    required NotesRepository notesRepository,
    required this.userId,
  })  : _notesRepository = notesRepository,
        super(NotesInitial()) {
    _fetchNotes();
  }

  void _fetchNotes() {
    emit(NotesLoading());
    _notesSubscription = _notesRepository.getNotes(userId).listen(
      (notes) {
        emit(NotesLoaded(notes: notes));
      },
      onError: (error) {
        emit(NotesError(error.toString()));
      },
    );
  }

  void searchNotes(String query) {
    if (state is NotesLoaded) {
      final currentState = state as NotesLoaded;
      emit(NotesLoaded(notes: currentState.notes, searchQuery: query));
    }
  }

  Future<void> addNote(String title, String content) async {
    try {
      final note = NoteModel(
        id: '', // Firestore sets ID
        title: title,
        content: content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: userId,
      );
      await _notesRepository.addNote(note);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      final updatedNote = note.copyWith(
        updatedAt: DateTime.now(),
      );
      await _notesRepository.updateNote(updatedNote);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _notesRepository.deleteNote(noteId);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
