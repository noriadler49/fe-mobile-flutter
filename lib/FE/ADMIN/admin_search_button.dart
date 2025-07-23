import 'package:flutter/material.dart';

class FilterButtonWithPopup extends StatefulWidget {
  final String label;
  final void Function(String) onSearch;

  const FilterButtonWithPopup({required this.label, required this.onSearch, super.key});

  @override
  _FilterButtonWithPopupState createState() => _FilterButtonWithPopupState();
}

class _FilterButtonWithPopupState extends State<FilterButtonWithPopup> {
  final TextEditingController _filterController = TextEditingController();

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tìm kiếm ${widget.label}'),
        content: TextField(
          controller: _filterController,
          decoration: InputDecoration(hintText: 'Tìm kiếm'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSearch(_filterController.text);
              Navigator.of(context).pop();
            },
            child: Text('Tìm'),
          ),
          TextButton(
            onPressed: () {
              _filterController.clear();
              widget.onSearch('');
              Navigator.of(context).pop();
            },
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 4),
        GestureDetector(
          onTap: () => _showPopup(context),
          child: Icon(Icons.search, size: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
