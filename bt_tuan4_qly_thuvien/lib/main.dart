import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Hệ thống\nQuản lý Thư viện'),
    );
  }
}

// 1. TÍNH TRỪU TƯỢNG (Abstraction): Định nghĩa lớp trừu tượng LibraryItem làm khuôn mẫu chung, chỉ khai báo phương thức trừu tượng getDisplayInfo() mà ẩn đi chi tiết triển khai bên trong.
abstract class LibraryItem {
  // 2. TÍNH ĐÓNG GÓI (Encapsulation): Che giấu dữ liệu bằng biến private (_id, _title, _category) và chỉ cho phép truy cập an toàn từ bên ngoài thông qua các getter/setter.
  final String _id;
  String _title;
  String _category;

  LibraryItem(this._id, this._title, this._category);

  String get id => _id;
  String get title => _title;
  String get category => _category;

  set title(String value) {
    if (value.trim().isNotEmpty) _title = value;
  }

  set category(String value) {
    if (value.trim().isNotEmpty) _category = value;
  }

  String getDisplayInfo();
}

// 3. TÍNH KẾ THỪA (Inheritance): Lớp Book kế thừa (extends) từ lớp cha LibraryItem để tái sử dụng các thuộc tính và phương thức mà không cần viết lại code.
class Book extends LibraryItem {
  final String author;

  Book(super.id, super.title, super.category, {this.author = 'Chưa rõ'});

  // 4. TÍNH ĐA HÌNH (Polymorphism): Ghi đè (@override) phương thức getDisplayInfo() của lớp cha để cung cấp cách hiển thị thông tin riêng biệt cho đối tượng Book.
  @override
  String getDisplayInfo() {
    return 'Mã: $id • Chủ đề: $category • Tác giả: $author';
  }
}

class Student {
  final String _id;
  final String _name;
  final String _major;
  final String _email;
  final Set<String> _borrowedBookIds = {};

  Student(this._id, this._name, this._major, this._email);

  String get id => _id;
  String get name => _name;
  String get major => _major;
  String get email => _email;

  bool hasBorrowed(String bookId) => _borrowedBookIds.contains(bookId);

  void toggleBorrow(String bookId) {
    if (_borrowedBookIds.contains(bookId)) {
      _borrowedBookIds.remove(bookId);
    } else {
      _borrowedBookIds.add(bookId);
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentTab = 0;
  int _currentStudentIndex = 0;

  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';

  final List<String> _categories = [
    'Tất cả',
    'Công nghệ',
    'Khoa học',
    'Kinh tế',
    'Văn học',
    'Khác',
  ];

  final List<LibraryItem> _books = [
    Book('B01', 'Sách 01 - Lập trình OOP', 'Công nghệ', author: 'Nguyễn Văn X'),
    Book('B02', 'Sách 02 - Cấu trúc dữ liệu', 'Công nghệ', author: 'Trần Thị Y'),
    Book('B03', 'Vũ trụ trong vỏ hạt dẻ', 'Khoa học', author: 'Stephen Hawking'),
    Book('B04', 'Kinh tế học vĩ mô', 'Kinh tế', author: 'N. Gregory Mankiw'),
    Book('B05', 'Sổ tay kỹ năng mềm', 'Khác', author: 'Lê Văn Z'),
  ];

  final List<Student> _students = [
    Student('SV001', 'Nguyen Van A', 'Công nghệ thông tin', 'vana@edu.vn'),
    Student('SV002', 'Tran Thi B', 'Quản trị kinh doanh', 'thib@edu.vn'),
    Student('SV003', 'Le Van C', 'Khoa học dữ liệu', 'vanc@edu.vn'),
  ];

  @override
  void initState() {
    super.initState();
    _students[0].toggleBorrow('B01');
    _students[0].toggleBorrow('B02');
    _students[1].toggleBorrow('B04');
  }

  void _changeStudent() {
    setState(() {
      _currentStudentIndex = (_currentStudentIndex + 1) % _students.length;
    });
  }

  void _showAddBookDialog() {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    String dialogCategory = 'Công nghệ';
    final addCategories = _categories.where((c) => c != 'Tất cả').toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Thêm sách mới'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Tên sách',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: authorController,
                      decoration: const InputDecoration(
                        labelText: 'Tác giả',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: dialogCategory,
                      decoration: const InputDecoration(
                        labelText: 'Chủ đề',
                        border: OutlineInputBorder(),
                      ),
                      items: addCategories
                          .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => dialogCategory = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nextIndex = _books.length + 1;
                    final formattedNum = nextIndex.toString().padLeft(2, '0');
                    final title = titleController.text.trim().isEmpty
                        ? 'Sách $formattedNum'
                        : titleController.text.trim();
                    final author = authorController.text.trim().isEmpty
                        ? 'Chưa rõ'
                        : authorController.text.trim();

                    setState(() {
                      _books.add(Book(
                        'B$formattedNum',
                        title,
                        dialogCategory,
                        author: author,
                      ));
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildManageTab(Student currentStudent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Sinh viên',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  currentStudent.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _changeStudent,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Thay đổi'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Danh sách sách',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              itemCount: _books.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final book = _books[index];
                final isBorrowed = currentStudent.hasBorrowed(book.id);
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF8B1E2F),
                    value: isBorrowed,
                    title: Text(
                      book.title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(book.getDisplayInfo()),
                    onChanged: (_) {
                      setState(() {
                        currentStudent.toggleBorrow(book.id);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: 150,
            height: 44,
            child: ElevatedButton(
              onPressed: _showAddBookDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Thêm'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookListTab() {
    final filteredBooks = _books.where((book) {
      final matchesSearch =
      book.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'Tất cả' || book.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Tra cứu Danh sách Sách',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm theo tên sách...',
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'Chủ đề: ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _categories
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: filteredBooks.isEmpty
              ? const Center(
            child: Text('Không tìm thấy sách phù hợp.'),
          )
              : ListView.separated(
            itemCount: filteredBooks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final book = filteredBooks[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    child: Text(book.id),
                  ),
                  title: Text(
                    book.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(book.getDisplayInfo()),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStudentTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Thông tin Sinh viên',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: _students.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final student = _students[index];
              final borrowedTitles = _books
                  .where((b) => student.hasBorrowed(b.id))
                  .map((b) => b.title)
                  .toList();

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF0D47A1),
                            foregroundColor: Colors.white,
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'MSSV: ${student.id} • Ngành: ${student.major}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Text('Email: ${student.email}'),
                      const SizedBox(height: 6),
                      Text(
                        'Sách đang mượn (${borrowedTitles.length}): ${borrowedTitles.isEmpty ? "Chưa mượn sách" : borrowedTitles.join(", ")}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStudent = _students[_currentStudentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: _currentTab == 0
              ? _buildManageTab(currentStudent)
              : _currentTab == 1
              ? _buildBookListTab()
              : _buildStudentTab(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentTab = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Quản lý'),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'DS Sách',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Sinh viên'),
        ],
      ),
    );
  }
}