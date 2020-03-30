import 'package:MyFilms/responsive/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:MyFilms/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  const CardSwiper({Key key, @required this.peliculas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return BaseWidget(builder: (context, sizingInformation) {
      bool portrait = (sizingInformation.orientation == Orientation.portrait);
      double width=sizingInformation.screenSize.width;
      double height=sizingInformation.screenSize.height;

      if (!portrait)  {
        width = sizingInformation.screenSize.height;
        height = sizingInformation.screenSize.width;
      }

      return Container(
        padding: EdgeInsets.all(15),
        width: width,
        height: height * 0.6,
        child: new Swiper(
          layout: SwiperLayout.STACK,

          itemWidth: width * 0.7,
          itemHeight: height * 0.6,
          itemBuilder: (BuildContext context, int index) {
            peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

            return Hero(
              tag: peliculas[index].uniqueId,
              child: new ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                // borderRadius: BorderRadius.circular(0.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'detalle',
                        arguments: peliculas[index]);
                  },
                  child: FadeInImage(
                    image: NetworkImage(
                      peliculas[index].getPosterImg(),
                    ),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          itemCount: peliculas.length,
          // pagination: new SwiperPagination(),
          // control: new SwiperControl(),
        ),
      );
    });
  }
}

// e8686676734d36b9c2b28f181906511b

// https://api.themoviedb.org/3/movie/550?api_key=e8686676734d36b9c2b28f181906511b

// eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlODY4NjY3NjczNGQzNmI5YzJiMjhmMTgxOTA2NTExYiIsInN1YiI6IjVkZGQ1OWQ5M2ZhYmEwMDAxOTAyYzhmMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Us7LU2-D-Tek_Fi4qakofpdqScy_SPKhadOfoxb9mRU
