import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_flutter/services/data/user.dart';
import 'package:vital_flutter_example/vital_bloc.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VitalBloc bloc = Provider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vital SDK example app'),
          actions: [
            IconButton(
              onPressed: () {
                _displayCreateUserDialog(context);
              },
              icon: const Icon(Icons.person_add),
            ),
            IconButton(
              onPressed: () {
                bloc.refresh();
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: const UsersPage());
  }
}

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VitalBloc bloc = Provider.of(context);
    return StreamBuilder(
      stream: bloc.getUsers(),
      builder: (context, AsyncSnapshot<List<User>?> snapshot) {
        final users = snapshot.data;
        if (users == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return SafeArea(
          child: Column(children: [
            Expanded(
                child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: ((context, index) => UserWidget(
                    user: users[index],
                    linkAction: () => bloc.launchLink(users[index]),
                    deleteAction: () => bloc.deleteUser(users[index]),
                    onTap: () => bloc.selectUser(users[index]),
                  )),
              itemCount: users.length,
            )),
            HealthKitWidget(bloc: bloc)
          ]),
        );
      },
    );
  }
}

class HealthKitWidget extends StatelessWidget {
  const HealthKitWidget({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  final VitalBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text(
          'HealthKit:',
          style: TextStyle(fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Wrap(
            spacing: 8,
            children: [
              MaterialButton(
                color: Colors.blueGrey.shade100,
                onPressed: () {
                  bloc.askForHealthResources();
                },
                child: const Text('Ask for resources'),
              ),
              StreamBuilder(
                stream: bloc.selectedUser,
                builder: (context, AsyncSnapshot<User?> snapshot) => MaterialButton(
                  color: Colors.blueGrey.shade100,
                  onPressed: snapshot.data != null
                      ? () {
                          bloc.syncHealthPlatform();
                        }
                      : null,
                  child: const Text('Sync data'),
                ),
              ),
              const SizedBox(height: 40)
            ],
          ),
        ),
        StreamBuilder(
          stream: bloc.status,
          builder: ((context, AsyncSnapshot<String> snapshot) {
            return Text('Status: ${snapshot.data ?? '-'}');
          }),
        )
      ]),
    );
  }
}

class UserWidget extends StatelessWidget {
  final User user;
  final VoidCallback? linkAction;
  final VoidCallback? deleteAction;
  final VoidCallback? onTap;

  const UserWidget({
    Key? key,
    required this.user,
    this.linkAction,
    this.deleteAction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              color: Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                user.clientUserId ?? '',
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            if (linkAction != null) ...[
              const SizedBox(width: 12),
              IconButton(
                onPressed: linkAction,
                icon: const Icon(
                  Icons.copy,
                  color: Colors.grey,
                ),
              )
            ],
            if (deleteAction != null) ...[
              const SizedBox(width: 12),
              IconButton(
                onPressed: deleteAction,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

Future<void> _displayCreateUserDialog(BuildContext context) async {
  final VitalBloc bloc = Provider.of(context, listen: false);
  final textFieldController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User name:'),
          content: TextField(
            onChanged: (value) {},
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "User name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                bloc.createUser(textFieldController.text);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      });
}
