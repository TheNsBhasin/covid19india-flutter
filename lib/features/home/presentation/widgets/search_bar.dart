import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showSuggestions;
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();

    showSuggestions = false;
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      setState(() {
        showSuggestions = true;
      });
    } else {
      setState(() {
        showSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
            child: TextField(
              focusNode: _focus,
              decoration: InputDecoration(
                hintText: 'Search your city, resources, etc',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color(0x7417060),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
        if (this.showSuggestions != null && this.showSuggestions)
          _buildSuggestionBox()
      ],
    );
  }

  Widget _buildSuggestionBox() {
    return SizedBox(
      height: 200,
    );
  }
}
