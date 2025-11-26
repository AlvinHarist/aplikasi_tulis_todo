import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- KONSTANTA WARNA SESUAI DESAIN ---
const Color kBackgroundColor = Color(0xFFFDF9F3); // Latar belakang cream
const Color kPrimaryGreen = Color(0xFF3DD598); // Hijau utama
const Color kCardColor = Color(0xFFF8F1EB); // Warna card tugas aktif
const Color kCompletedColor = Color(0xFFE0E0E0); // Warna card tugas selesai
const Color kTextHeader = Color(0xFF303030); // Teks hitam/abu tua
const Color kTextSub = Color(0xFF9E9E9E); // Teks abu muda

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tulis App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBackgroundColor,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryGreen,
          primary: kPrimaryGreen,
          surface: kBackgroundColor,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return kPrimaryGreen;
            }
            return null;
          }),
        ),
      ),
      home: const TodoListPage(),
    );
  }
}

// --- MODEL DATA ---
class Todo {
  String title;
  String description;
  bool isDone;

  Todo({
    required this.title,
    required this.description,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'isDone': isDone,
      };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json['title'],
        description: json['description'],
        isDone: json['isDone'] ?? false,
      );
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todos = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // --- FUNGSI STORAGE & LOGIKA ---
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(todos.map((e) => e.toJson()).toList());
    await prefs.setString('todos_data', encodedData);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('todos_data');
    if (encodedData != null) {
      final List<dynamic> decodedJson = jsonDecode(encodedData);
      setState(() {
        todos = decodedJson.map((e) => Todo.fromJson(e)).toList();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _addTodo() {
    if (titleController.text.isNotEmpty) {
      setState(() {
        todos.add(Todo(
            title: titleController.text, description: descController.text));
      });
      _saveData();
      _clearControllers();
      Navigator.pop(context);
    }
  }

  void _editTodo(int index) {
    if (titleController.text.isNotEmpty) {
      setState(() {
        todos[index].title = titleController.text;
        todos[index].description = descController.text;
      });
      _saveData();
      _clearControllers();
      Navigator.pop(context);
    }
  }

  void _deleteTodo(Todo task) {
    setState(() {
      todos.remove(task);
    });
    _saveData();
  }

  void _toggleStatus(Todo task, bool? value) {
    setState(() {
      task.isDone = value ?? false;
    });
    _saveData();
  }

  void _clearControllers() {
    titleController.clear();
    descController.clear();
  }

  // --- UI: CUSTOM HEADER WIDGET ---
  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      width: double.infinity,
      child: Column(
        children: const [
          Text(
            'Tulis',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: kPrimaryGreen,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'To Do List Aplikasi',
            style: TextStyle(
              fontSize: 16,
              color: kTextSub,
            ),
          ),
        ],
      ),
    );
  }

  // --- UI: WIDGET TAMPILAN KOSONG (Sticky Notes) ---
  // Dipisahkan agar kode utama lebih bersih
  Widget _buildEmptyStateWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/notes.png',
            width: 280,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const Text(
            'Ayo tulis\nkegiatanmu!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF34C759),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI: BOTTOM SHEET FORM ---
  void _showForm(BuildContext context, {int? index}) {
    bool isEditing = index != null;
    if (isEditing) {
      titleController.text = todos[index].title;
      descController.text = todos[index].description;
    } else {
      _clearControllers();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 25,
            right: 25,
            top: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: const [
                    Text('Tulis',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryGreen)),
                    Text('To Do List Aplikasi',
                        style: TextStyle(color: kTextSub)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text('Judul',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Masukan tugas',
                  hintStyle: TextStyle(color: Colors.black26),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text('Deskripsi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  hintText: 'Masukan deskripsi tugas',
                  hintStyle: TextStyle(color: Colors.black26),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => isEditing ? _editTodo(index) : _addTodo(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Simpan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- UI: WIDGET ITEM TUGAS ---
  Widget _buildTaskItem(Todo task, int index) {
    bool isCompleted = task.isDone;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? kCompletedColor : kCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: task.isDone,
            side: BorderSide(
                color: isCompleted ? Colors.transparent : kPrimaryGreen,
                width: 1.5),
            onChanged: (value) => _toggleStatus(task, value),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isCompleted ? kTextHeader.withOpacity(0.6) : kPrimaryGreen,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description.isNotEmpty
            ? Text(
                task.description,
                style: TextStyle(
                  color: isCompleted ? kTextSub : kTextHeader,
                  fontSize: 13,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined,
                  color: isCompleted ? Colors.grey : Colors.blueAccent),
              onPressed: () => _showForm(context, index: index),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline,
                  color: isCompleted ? Colors.grey : Colors.redAccent),
              onPressed: () => _deleteTodo(task),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pisahkan tugas aktif dan selesai
    final activeTodos = todos.where((todo) => !todo.isDone).toList();
    final completedTodos = todos.where((todo) => todo.isDone).toList();

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildCustomHeader(),
                  Expanded(
                    // LOGIKA TAMPILAN UTAMA DIUBAH DISINI
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [
                        // --- BAGIAN 1: TUGAS AKTIF ATAU EMPTY STATE ---
                        if (activeTodos.isEmpty)
                          // Jika tidak ada tugas aktif, tampilkan ilustrasi
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: _buildEmptyStateWidget(),
                          )
                        else
                          // Jika ada tugas aktif, tampilkan daftarnya
                          ...activeTodos.map((task) {
                            int index = todos.indexOf(task);
                            return _buildTaskItem(task, index);
                          }).toList(),

                        // --- BAGIAN 2: TUGAS SELESAI (Selalu muncul jika ada datanya) ---
                        if (completedTodos.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
                            child: Text(
                              'Selesai',
                              style: TextStyle(
                                color: kPrimaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ...completedTodos.map((task) {
                            int index = todos.indexOf(task);
                            return _buildTaskItem(task, index);
                          }).toList(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () => _showForm(context),
          backgroundColor: kPrimaryGreen.withOpacity(0.9),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}