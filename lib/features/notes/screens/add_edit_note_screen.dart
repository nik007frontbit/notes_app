import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/common_widgets/my_button.dart';
import '../../../widgets/common_widgets/my_text_field.dart';
import '../cubit/notes_cubit.dart';
import '../models/note_model.dart';

class AddEditNoteScreen extends StatefulWidget {
  final NoteModel? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      if (widget.note == null) {
        context.read<NotesCubit>().addNote(
              _titleController.text.trim(),
              _contentController.text.trim(),
            );
      } else {
        context.read<NotesCubit>().updateNote(
              widget.note!.copyWith(
                title: _titleController.text.trim(),
                content: _contentController.text.trim(),
              ),
            );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
            left: 24,
            right: 24,
            bottom: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyTextField(
                  controller: _titleController,
                  labelText: 'Title',
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: _contentController,
                  labelText: 'Content',
                  maxLines: 12,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Content is required'
                      : null,
                ),
                const SizedBox(height: 32),
                MyButton(
                  onPressed: _onSave,
                  text: 'Save Note',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
