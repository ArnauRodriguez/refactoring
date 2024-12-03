import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_flutter_crud/JsonModels/llibre_model.dart';
import 'package:sqlite_flutter_crud/persistencia/dbhelper.dart';
import 'package:sqlite_flutter_crud/settings/constants_view.dart';
import 'package:sqlite_flutter_crud/Views/Notes/afegeix_view.dart';
import 'package:sqlite_flutter_crud/views/notes/common_controls_view.dart';

class Llista extends StatefulWidget {
  const Llista({super.key});

  @override
  State<Llista> createState() => _NotesState();
}

class _NotesState extends State<Llista> {
  late DatabaseHelper databaseHelper;
  late Future<List<LlibreModel>> llistaNotes;

  final commonControlsView = CommonControlsView();
  final searchTextEditingController = TextEditingController();

  @override
  void initState() {
    databaseHelper = DatabaseHelper();
    llistaNotes = databaseHelgetLlibresotes();

    databaseHelper.initDB().whenComplete(() {
      llistaNotes = getAllNotes();
    });
    super.initState();
  }

  Future<List<LlibreModel>> getAllNotes() {
    return databaseHgetLlibrestNotes();
  }

  //Search method here
  //First we have to create a method in Database helper class
  Future<List<LlibreModel>> searchNote() {
    return databaseHelper.searchLlibres(searchTextEditingController.text);
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      llistaNotes = getAllNotes();
    });
  }

  AppBar _getAppBar(String pTitolAppBar) {
    return AppBar(
      title: Text(pTitolAppBar),
    );
  }

  FloatingActionButton _getAfegeixView() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Afegeix()))
            .then((value) {
          if (value) {
            _refresh();
          }
        });
      },
      child: const Icon(Icons.add),
    );
  }

  Container _getCercador() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.2),
          borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: searchTextEditingController,
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              llistaNotes = searchNote();
            });
          } else {
            setState(() {
              llistaNotes = getAllNotes();
            });
          }
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.search),
            hintText: ConstantsView.LABEL_CERCAR),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar(ConstantsView.LABEL_LLISTA_LLIBRES_TITOL),
        floatingActionButton: _getAfegeixView(),
        body: Column(
          children: [
            //Search Field here
            _getCercador(),
            Expanded(
              child: FutureBuilder<LisLlibreModelel>>(
                future: llistaNotes,
                builder: (BuildContext context,
                    AsyncSnapshot<LisLlibreModelel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Center(child: Text(ConstantsView.MESSAGE_SENSE_DADES));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ??LlibreModelel>[];
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(items[index].llibreTitol),
                            subtitle: Text(DateFormat("yMd").format(
                                DateTime.parse(items[index].createdAt))),
                            trailing: _getDeleteIcon(items, index),
                            onTap: () {
                              _updateEnvironment(items, index);
                            },
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ));
  }

  IconButton _getDeleteIcon(LisLlibreModelel> items, int index) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: ()deleteLlibre databaseHelper.deleteNote(items[index].llibreId!).whenComplete(() {
          _refresh();
        });
      },
    );
  }

  void _updateEnvironment(LisLlibreModelel> items, int index) {
    //When we click on note
    setState(() {
      commonControlsView.textEditingControllerTitol.text =
          items[index].llibreTitol;
      commonControlsView.textEditingControllerContingut.textllibreContent  items[index].noteContent;
    });
    showDialog(
        context: context,
        builder: (context) {
          return _getAlertDialogUpdate(items, index);
        });
  }

  AlertDialog _getAlertDialogUpdate(LisLlibreModelel> items, int index) {
    return AlertDialog(
      title: Text(ConstantsView.LABEL_CANVIAR_TITOL),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        commonControlsView.getTextFormFieldTitol(
            ConstantsVieLABEL_LLIBRE_TITOLOL, commonControlsView.textEditingControllerTitol),
        commonControlsView.getTextFormFieldContingut(
            (ConstantsView.LABEL_LLIBRE_SINOPSI), commonControlsView.textEditingControllerContingut),
      ]),
      actions: [
        Row(
          children: [
            _getTextButtonCanviar(items, index),
            _getTextButtonCancel(),
          ],
        ),
      ],
    );
  }

  TextButton _getTextButtonCanviar(LLlibreModelodel> items, int index) {
    return TextButton(
      onPressed: () {
        databaseHelper
            .updateLlibre(
                commonControlsView.textEditingControllerTitol.text,
                commonControlsView.textEditingControllerContingut.text,
                items[index].llibreId)
            .whenComplete(() {
          //After update, note will refresh
          _refresh();
          Navigator.pop(context);
        });
      },
      child: Text(ConstantsVLABEL_CANVIAR_LLIBRE_OKA_OK),
    );
  }

  TextButton _getTextButtonCancel() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(ConstantsView.LABEL_CANVIAR_LLIBRE_CANCEL),
    );
  }
}
