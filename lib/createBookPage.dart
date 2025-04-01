import 'package:flutter/material.dart';
import 'package:lab_6/homePage.dart';

class CreateBookPage extends StatefulWidget {
  final BookRate? book; 

  const CreateBookPage({super.key, this.book});

  @override
  State<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      titleController.text = widget.book!.title;
      authorController.text = widget.book!.author;
      rating = widget.book!.rating.toDouble();
    }
  }

  void saveBook() {
    if (titleController.text.isEmpty || authorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and Author cannot be empty!')),
      );
      return;
    }

    Navigator.pop(
      context,
      BookRate(titleController.text, authorController.text, rating.toInt()),
    );
  }

  void deleteBook() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this book?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pop(
                  context,
                  'delete',
                ); 
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'New Book' : 'Edit Book'),
        actions: [
          if (widget.book !=
              null) 
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteBook,
            ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveBook, 
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Rating: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: rating,
                      min: 0,
                      max: 5,
                      activeColor: Colors.black,
                      inactiveColor: Colors.black38,
                      thumbColor: Colors.white,
                      label: rating.round().toString(),
                      onChanged: (double newValue) {
                        setState(() {
                          rating = newValue;
                        });
                      },
                    ),
                  ),
                  Text(
                    '${rating.toInt().toString()}/5',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
