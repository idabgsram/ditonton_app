import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/ota_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OTATVPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-shows/on-the-air';

  @override
  _OTATVPageState createState() => _OTATVPageState();
}

class _OTATVPageState extends State<OTATVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OTATVNotifier>(context, listen: false)
            .fetchOTATV());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On The Air TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<OTATVNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tvList[index];
                  return ItemCard(tv);
                },
                itemCount: data.tvList.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
