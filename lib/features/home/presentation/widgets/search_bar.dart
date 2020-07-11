import 'package:autotrie/autotrie.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/features/states/presentation/pages/state_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _showSuggestions = false;
  bool _showClearButton = false;
  bool _showResults = false;

  FocusNode _focus = new FocusNode();
  TextEditingController _textController = new TextEditingController();

  var _statesBox = Hive.box('states');
  var _districtsBox = Hive.box('districts');

  @override
  void initState() {
    super.initState();

    _showSuggestions = false;
    _showClearButton = false;
    _showResults = false;

    _focus.addListener(_onFocusChange);
    _textController.addListener(_onTextChange);

    STATE_CODE_MAP.entries.forEach((e) {
      _statesBox
          .put(e.value, {'name': e.value, 'type': 'state', 'route': e.key});
    });

    STATE_DISTRICT_MAP.entries.forEach((e) {
      e.value.forEach((districtName) {
        _districtsBox.put(districtName,
            {'name': districtName, 'type': 'district', 'route': e.key});
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _focus.dispose();
    _textController.dispose();
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      setState(() {
        _showSuggestions = true;
      });
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _onTextChange() {
    if (_textController.text.length > 0) {
      setState(() {
        _showClearButton = true;
        _showResults = true;
      });
    } else {
      setState(() {
        _showClearButton = false;
        _showResults = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              focusNode: _focus,
              controller: _textController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Search your district or state',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _getClearButton(),
                filled: true,
                fillColor: Color(0x7417060),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
        if (this._showSuggestions != null &&
            this._showSuggestions &&
            (this._showResults == null || !this._showResults))
          _buildSuggestionBox(),
        if (this._showResults != null && this._showResults) _buildResultsBox(),
      ],
    );
  }

  Widget _buildResultsBox() {
    Map suggestedStates = _statesBox?.searchKeys(_textController?.text);
    Map suggestedDistricts = _districtsBox?.searchKeys(_textController?.text);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.35),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...suggestedStates.entries.map(
                    (e) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            e.value['name'],
                            softWrap: true,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 32.0),
                        ButtonTheme(
                          minWidth: 36,
                          height: 36,
                          child: FlatButton(
                            color: Colors.orange.withAlpha(50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                StatePage.routeName,
                                arguments: StatePageArguments(
                                    stateCode: e.value['route']),
                              );
                            },
                            child: Text(e.value['route'],
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
                          ),
                        ),
                        SizedBox(width: 16.0),
                      ],
                    ),
                  ),
                  ...suggestedDistricts.entries.map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 16.0),
                          Expanded(
                            flex: 1,
                            child: Text(
                              e.value['name'] +
                                  ", " +
                                  STATE_CODE_MAP[e.value['route']],
                              softWrap: true,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          SizedBox(width: 32.0),
                          Expanded(
                            flex: 0,
                            child: ButtonTheme(
                              minWidth: 36,
                              height: 36,
                              child: FlatButton(
                                color: Colors.orange.withAlpha(50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    StatePage.routeName,
                                    arguments: StatePageArguments(
                                        stateCode: e.value['route'],
                                        districtName: e.value['name']),
                                  );
                                },
                                child: Text(e.value['route'],
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange)),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                        ],
                      ))
                ]),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionBox() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "District",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  ...DISTRICT_SUGGESTIONS
                      .map((e) => _buildSuggestion(e))
                      .toList()
                ],
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "State",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  ...STATE_SUGGESTIONS.map((e) => _buildSuggestion(e)).toList()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestion(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " - ",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Flexible(
                child: GestureDetector(
              onTap: () {
                _textController?.text = text;
                _focus?.unfocus();
              },
              child: Text(
                text,
                softWrap: true,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            )),
          ],
        ),
        SizedBox(height: 4.0),
      ],
    );
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return null;
    }

    return IconButton(
      onPressed: () => _textController.clear(),
      icon: Icon(Icons.clear),
    );
  }
}
