import 'package:flutter/material.dart';
import 'package:lab_6/createBookPage.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class BookRate {
  final String title;
  final String author;
  final int rating;

  BookRate(this.title, this.author, this.rating);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<BookRate> bookReviews = [
    BookRate('Book One', 'Author One', 5),
    BookRate('Book Two', 'Author Two', 4),
    BookRate('Book Three', 'Author Three', 3),
    BookRate('Book Four', 'Author Four', 1),
  ];

  List<BookRate> filteredBookReviews = [];
  String dropdownValue = 'All';

  @override
  void initState() {
    super.initState();
    filteredBookReviews = List.from(bookReviews);
  }

  void sortBooks(String value) {
    setState(() {
      if (value == 'All') {
        filteredBookReviews = List.from(bookReviews)
          ..sort((a, b) => b.rating.compareTo(a.rating));
      } else {
        int selectedRating = int.parse(value);
        filteredBookReviews = bookReviews
            .where((book) => book.rating == selectedRating)
            .toList();
      }
    });
  }

  void editBook(int index) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CreateBookPage(book: filteredBookReviews[index]),
    ),
  );

  if (result == 'delete') {
    setState(() {
      final originalIndex = bookReviews.indexOf(filteredBookReviews[index]);
      bookReviews.removeAt(originalIndex);
      filteredBookReviews.removeAt(index);
    });
  } else if (result != null && result is BookRate) {
    setState(() {
      final originalIndex = bookReviews.indexOf(filteredBookReviews[index]);
      bookReviews[originalIndex] = result;
      filteredBookReviews[index] = result;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Catalog'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newBook = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateBookPage(),
                ),
              );

              if (newBook != null && newBook is BookRate) {
                setState(() {
                  bookReviews.add(newBook);
                  filteredBookReviews = List.from(bookReviews);
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 45,
            child: DropdownButton<String>(
              value: dropdownValue,
              isExpanded: true,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    dropdownValue = value;
                    sortBooks(value);
                  });
                }
              },
              items: ['All', '1', '2', '3', '4', '5']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'All' ? 'All Ratings' : '$value Stars'),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBookReviews.length,
              itemBuilder: (context, index) {
                final book = filteredBookReviews[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < book.rating; i++)
                        Icon(Icons.star, color: Colors.black, size: 20.0),
                    ],
                  ),
                  onTap: () => editBook(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

