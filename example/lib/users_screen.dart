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
                  bloc.refresh();
                },
                icon: const Icon(Icons.refresh)),
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
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: ((context, index) => UserWidget(
                user: users[index],
                linkAction: () => bloc.launchLink(users[index]),
                deleteAction: () => bloc.deleteUser(users[index]),
              )),
          itemCount: users.length,
        );
      },
    );
  }
}

class UserWidget extends StatelessWidget {
  final User user;
  final VoidCallback? linkAction;
  final VoidCallback? deleteAction;

  const UserWidget({
    Key? key,
    required this.user,
    this.linkAction,
    this.deleteAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
