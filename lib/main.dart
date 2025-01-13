import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

}

//tek sayfalı hali 


// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;


//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }


//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //Text('A random AWESOME idea'),
//             // Text(appState.current.asLowerCase),
//             BigCard(pair: pair),  //ctrl .  ile extract widget de sonra ısım ver sınıf olusturuyor asagida (oncesı  : Text(pair.asLowerCase))
//             SizedBox(height: 10), //bosluk bırakmak
//             Row(
//               mainAxisSize: MainAxisSize.min,  //Row ürününe mevcut yatay alanın tamamını kullanmamasını bildirir.
//               children: [

//                 ElevatedButton.icon(
//                   onPressed: () {
//                     appState.toggleFavorite();
//                   },
//                   icon: Icon(icon),
//                   label: Text('Like'),
//                 ),
//                 SizedBox(width: 10),


//                 ElevatedButton(
//                   onPressed: () {
//                     // print('button pressed!');
//                     appState.getNext(); 
//                   },
//                   child: Text('Next'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),

//     );
//   }
// }

// ...


//birden fazla sayfa 


class MyHomePage extends StatefulWidget {         //oncesinde stateless idi . ctrl . ile convert dedık
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {  //alt çizgi (_) bu sınıfı gizli hale getirir ve derleyici tarafından uygulanır.
  
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
  switch (selectedIndex) {
    case 0:
      page = GeneratorPage();
      break;
    case 1:
      page = FavoritesPage(); //carpılı dıkdortgen hazırlanıyor sayfası gıbı
      break;
    default:
      throw UnimplementedError('no widget for $selectedIndex');
}
    return LayoutBuilder(
      builder: (context,constraints) { // constraints öğesini sorgulayarak etiketin gösterilip gösterilmey eceğine karar verebilir. yatay ve dikeylik ıcın responsıve olacak 
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(  //gezinme düğmelerinin mobil durum çubuğu tarafından gizlenmesini önlemek için NavigationRail etrafını kaplar.
                  extended: constraints.maxWidth >= 600,   //true / false dersen sadece simge ama yatay ya da dikey kullanımda otomatık olması ıcın bu  responsıve olacak
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                   // print('selected: $value');
        
                    setState(() {
                      selectedIndex = value;
                    });
        
        
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                 // child: GeneratorPage(),
                  child:page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context); //  uygulamanın mevcut temasını ister.

    final style = theme.textTheme.displayMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );

    return Card(
      color: theme.colorScheme.primary, //
      child: Padding(        //wrapwiyhwidget yaptım child oldu 
        padding: const EdgeInsets.all(50.0),
        //child: Text(pair.asLowerCase, style: style),
        child:Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", // ekran okuyucular oluşturulan her bir kelime çiftini doğru telaffuz ede
        )
        
//       child: Text(pair.asLowerCase),
      ),
    );   // eski hali : return Text(pair.asLowerCase);  wrap with padd,ing yaptım ctrl .  ile 
  }
}


// ...

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); //MyAppState e herhangi bir widget'tan erişme

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }


    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

