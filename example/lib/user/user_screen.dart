import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vital_flutter_example/user/user_bloc.dart';
import 'package:vital_health/vital_health.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<UserBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Copied to clipboard")));
                          Clipboard.setData(
                              ClipboardData(text: bloc.user.userId));
                        },
                        child: ListTile(
                          title: const Text('Id'),
                          subtitle: Text(bloc.user.userId ?? ""),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Copied to clipboard")));
                          Clipboard.setData(
                              ClipboardData(text: bloc.user.clientUserId));
                        },
                        child: ListTile(
                          title: const Text('Client User Id'),
                          subtitle: Text(bloc.user.clientUserId ?? ""),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Copied to clipboard")));
                          Clipboard.setData(
                              ClipboardData(text: bloc.user.teamId));
                        },
                        child: ListTile(
                          title: const Text('Team Id'),
                          subtitle: Text(bloc.user.teamId ?? ""),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text("Health Data Sync",
                  style: Theme.of(context).textTheme.headlineSmall),
              ListTile(
                title: const Text('Request the permissions for health data'),
                trailing: OutlinedButton(
                  onPressed: () => bloc.askForHealthResources(),
                  child: const Text('Ask'),
                ),
              ),
              ListTile(
                title: const Text('Force sync health data'),
                trailing: OutlinedButton(
                  onPressed: () => bloc.sync(),
                  child: const Text('Sync'),
                ),
              ),
              ListTile(
                title: const Text('Health sync status'),
                subtitle: StreamBuilder(
                  stream: bloc.status,
                  builder: ((context, AsyncSnapshot<String> snapshot) {
                    return Text('Status: ${snapshot.data ?? '-'}');
                  }),
                ),
              ),
              Text("Health Data Write",
                  style: Theme.of(context).textTheme.headlineSmall),
              ListTile(
                title: const Text('Add water'),
                subtitle: const Text('Add 100ml of water'),
                trailing: OutlinedButton(
                  onPressed: () => bloc.water(),
                  child: const Text('Write'),
                ),
              ),
              ListTile(
                title: const Text('Add caffeine'),
                subtitle: const Text('Add 100 mg of caffeine'),
                trailing: OutlinedButton(
                  onPressed: () => bloc.caffeine(),
                  child: const Text('Write'),
                ),
              ),
              ListTile(
                title: const Text('Add mindful session'),
                subtitle: const Text('Add 10 minutes of mindful session'),
                trailing: OutlinedButton(
                  onPressed: () => bloc.mindfulSession(),
                  child: const Text('Write'),
                ),
              ),
              Text("Health Data Read",
                  style: Theme.of(context).textTheme.headlineSmall),
              ...HealthResource.values.map((e) => ListTile(
                    title: Text(e.name.toUpperCase()),
                    subtitle: const Text("Print last 10 days to console"),
                    trailing: OutlinedButton(
                      onPressed: () => bloc.read(e),
                      child: const Text('Read'),
                    ),
                  )),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}
