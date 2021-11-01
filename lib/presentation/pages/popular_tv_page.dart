import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-shows/popular';

  @override
  _PopularTVPageState createState() => _PopularTVPageState();
}

class _PopularTVPageState extends State<PopularTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PopularTVBloc>().add(FetchData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV'),
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
        child: BlocBuilder<PopularTVBloc, PopularTVState>(
          builder: (context, state) {
            if (state is DataLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataAvailable) {
              return ListView.builder(
                key: Key('popular_tv_lv'),
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return ItemCard(tv);
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
