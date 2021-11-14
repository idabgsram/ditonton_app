import 'package:tv_shows/presentation/bloc/ota_tv_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTATVPage extends StatefulWidget {

  @override
  _OTATVPageState createState() => _OTATVPageState();
}

class _OTATVPageState extends State<OTATVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OTATVBloc>().add(FetchData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On The Air TV'),
        leading: IconButton(
          key: Key('back_button'),
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OTATVBloc, OTATVState>(
          builder: (context, state) {
            if (state is DataLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataAvailable) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return ItemCard(
                    tv,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        TV_DETAIL_ROUTE,
                        arguments: tv.id,
                      );
                    },
                    key: Key('item_$index'),
                  );
                },
                itemCount: state.result.length,
              );
            } else if (state is DataError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                key: Key('empty_image'),
                child: Text('Empty'),
              );
            }
          },
        ),
      ),
    );
  }
}
