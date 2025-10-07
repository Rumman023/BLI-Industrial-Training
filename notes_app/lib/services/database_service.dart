import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;
  final _store = intMapStoreFactory.store('notes');

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final dbPath = join(appDir.path, 'notes.db');
    return await databaseFactoryIo.openDatabase(dbPath);
  }

  // Create or Update a note
  Future<void> saveNote(Note note) async {
    final db = await database;
    await _store.record(note.id.hashCode).put(db, note.toMap());
  }

  // Get all notes
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final snapshots = await _store.find(db);
    return snapshots.map((snapshot) {
      return Note.fromMap(snapshot.value);
    }).toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // Get a single note by ID
  Future<Note?> getNote(String id) async {
    final db = await database;
    final snapshot = await _store.record(id.hashCode).get(db);
    if (snapshot == null) return null;
    return Note.fromMap(snapshot);
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    final db = await database;
    await _store.record(id.hashCode).delete(db);
  }

  // Delete all notes
  Future<void> deleteAllNotes() async {
    final db = await database;
    await _store.delete(db);
  }
}