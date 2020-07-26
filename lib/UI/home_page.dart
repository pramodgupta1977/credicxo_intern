import 'package:credicxo_intern/UI/bookMarked.dart';
import 'package:credicxo_intern/bloc/track_bloc/track_bloc.dart';
import 'package:credicxo_intern/bloc/track_bloc/track_event.dart';
import 'package:credicxo_intern/bloc/track_bloc/track_state.dart';
import 'package:credicxo_intern/data/models/ApiTrackDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:credicxo_intern/UI/trackinfo_page.dart';
import 'package:credicxo_intern/UI/checkConnection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TrackBloc trackBloc;
  SharedPreferences prefs;
  bool isBookMarked=false;

  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  @override
  void initState() {
    super.initState();
    trackBloc = BlocProvider.of<TrackBloc>(context);
    trackBloc.add(FetchTrackEvent());

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    aaa();
  }

  aaa() async{
    prefs = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        string = "Offline";
        print(string);
        break;
      case ConnectivityResult.mobile:
        string = "Mobile: Online";
        print(string);
        break;
      case ConnectivityResult.wifi:
        print(string);
        string = "WiFi: Online";
    }
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Material(
            child: Scaffold(
              appBar: AppBar(
                title: Text("Trending"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.bookmark),
                    onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              BookMarked())
                      );
                    },
                  )
                ],

              ),
              body: string=="Offline"?Container(
                child: Center(
                  child: Text("No Internet"),
                ),
              ):Container(
                child: BlocListener<TrackBloc, TrackState>(
                  listener: (context, state) {
                    if (state is TrackErrorState) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<TrackBloc, TrackState>(
                    builder: (context, state) {
                      if (state is TrackInitialState) {
                        return buildLoading();
                      } else if (state is TrackLoadingState) {
                        return buildLoading();
                      } else if (state is TrackLoadedState) {
                        return buildArticleList(state.tracks);
                      } else if (state is TrackErrorState) {
                        return buildErrorUi(state.error);
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildArticleList(List<TrackList> tracks) {
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (ctx, pos) {


        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      TrackInfo(trackId: tracks[pos].track.trackId,))
              );
            },
            title: Text(tracks[pos].track.trackName),
            subtitle: Text(tracks[pos].track.albumName),
            trailing: IconButton(
              icon: FutureBuilder(
                future: _check(tracks[pos].track.trackId.toString()),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data==true){
                      return Icon(Icons.bookmark);
                    }
                    if(snapshot.data==false){
                      return Icon(Icons.bookmark_border);
                    }
                  }
                  else{
                    return Icon(Icons.bookmark_border);
                  }
              },
              ),
               onPressed: () async{
              if(await _check(tracks[pos].track.trackId.toString())==false){
                prefs.setString(tracks[pos].track.trackId.toString(), tracks[pos].track.trackName.toString());
                print("added");
                setState(() {

                });
              }else{
                prefs.remove(tracks[pos].track.trackId.toString());
                print("remove");
                setState(() {

                });
              }

          },
            ),
          ),
        );
      },
    );
  }

}
Future<bool> _check(check) async{
  final prefs = await SharedPreferences.getInstance();
  bool result;
  result =prefs.containsKey(check);
  return result;

}