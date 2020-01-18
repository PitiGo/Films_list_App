import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<dynamic> peliculas;
  

  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 3,
    viewportFraction: 0.33,
  );

 
 
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      // _pageController.position.minScrollExtent = 0;

     

      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });


    return Container(
      height: _screenSize.height * 0.27,
      child: PageView.builder(
          scrollDirection: Axis.horizontal,
          physics: PageScrollPhysics(),
          controller: _pageController,
          pageSnapping: false,
          itemCount: peliculas.length,
          itemBuilder: (context, index) => _tarjeta(context, peliculas[index])

          // children: _tarjetas(context),
          ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-poster';
    final tarjeta = Container(

      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              // clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(
                  pelicula.getPosterImg(),
                ),
                height: 120.0,
              ),
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

    

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: tarjeta,
    );
  }

  // List<Widget> _tarjetas(BuildContext context) {
  //   return peliculas.map((pelicula) {
  //     return Container(
  //       margin: EdgeInsets.only(right: 15.0),
  //       child: Column(
  //         children: <Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(20),
  //             child: FadeInImage(
  //               fit: BoxFit.cover,
  //               placeholder: AssetImage('assets/img/no-image.jpg'),
  //               image: NetworkImage(
  //                 pelicula.getPosterImg(),
  //               ),
  //               height: 120.0,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 2.0,
  //           ),
  //           Text(
  //             pelicula.title,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption,
  //           ),
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
}
