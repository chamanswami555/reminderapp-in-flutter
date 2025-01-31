import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../buttons/cancel_button.dart';
import '../buttons/done_button.dart';
import '../buttons/update_button.dart';
import '../statwids/statProvider.dart';
import '../tasks/taskData.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode fnode;
  bool updating = false;
  late int donebutton;
  late TaskData task;
  late TextEditingController tx1;
  late TextEditingController tx2;

  void updateTask() async {
    setState(() {
      updating = !updating;
    });
    if (mounted) {
      int s = Provider.of<StatProvider>(context, listen: false).score;
      int ts = Provider.of<StatProvider>(context, listen: false).totalScore;
      if (donebutton != task.reached) {
        if (donebutton == 1) {
          await Provider.of<StatProvider>(context, listen: false)
              .updateScore(s + 1, ts);
        } else {
          await Provider.of<StatProvider>(context, listen: false)
              .updateScore(s - 1, ts);
        }
      }

      await task
          .didupdate(tx1.text, tx2.text, donebutton)
          .then((value) => Navigator.of(context).pop());
    }
  }

  @override
  void didChangeDependencies() {
    fnode = FocusNode();
    task = (ModalRoute.of(context)!.settings.arguments) as TaskData;
    donebutton = task.reached;
    tx1 = TextEditingController(text: task.title);
    tx2 = TextEditingController(text: task.description);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    fnode.dispose();
    tx1.dispose();
    tx2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (!updating)
        ? Scaffold(
            backgroundColor: const Color.fromRGBO(197, 179, 255, 1),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 30, left: 50, right: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'TITLE',
                                focusedBorder: UnderlineInputBorder(),
                                labelStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(42, 27, 70, 1)),
                                focusColor: Color.fromRGBO(42, 27, 70, 1),
                                hoverColor: Color.fromRGBO(42, 27, 70, 1),
                              ),
                              controller: tx1,
                              maxLength: 30,
                              style: Theme.of(context).textTheme.titleLarge,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(),
                                  focusColor: Color.fromRGBO(42, 27, 70, 1),
                                  hoverColor: Color.fromRGBO(42, 27, 70, 1),
                                  labelText: 'DESCRIPTION',
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(42, 27, 70, 1),
                                  )),
                              controller: tx2,
                              style: Theme.of(context).textTheme.titleLarge,
                              keyboardType: TextInputType.multiline,
                              minLines: 2,
                              maxLines: 2,
                              maxLength: 100,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FittedBox(
                              child: DoneButton(() {
                                setState(() {
                                  donebutton = (donebutton == 0) ? 1 : 0;
                                });
                              }, donebutton),
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UpdateButton(() {
                                  if (_formKey.currentState!.validate()) {
                                    updateTask();
                                  }
                                }),
                                const SizedBox(
                                  width: 10,
                                ),
                                CancelButton(() {
                                  Navigator.of(context).pop(false);
                                })
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            color: Colors.deepPurple.shade700,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                color: Colors.white,
              ),
            ));
  }
}
