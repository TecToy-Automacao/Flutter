/* class InputDialog {
  static Future<void> displayListInputDialog(String Title, String hintText,
      List oldValue, BuildContext context, String variavel) async {
    TextEditingController _textFieldController = new TextEditingController();
    List oldText = oldValue;
    int _id = 0;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Title),
          content: ListView.builder(
            shrinkWrap: true,
            itemCount: oldText.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('${oldText[index]}'),
                onTap: () {
                  _id = index;

                  Navigator.pop(context);
                },
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
} */
