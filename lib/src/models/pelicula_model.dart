class Peliculas {
  List<Pelicula> items = new List();
  Peliculas();

  Peliculas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null)
      return;
    else {
     
      for (var item in jsonList) {
        final pelicula = new Pelicula.fromJsonMap(item);
        items.add(pelicula);
      }

    
    }
  }
}

class Pelicula {
  
  String uniqueId;

  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;
  int seen = 0;

  Pelicula(
      {this.voteCount,
      this.video,
      this.popularity,
      this.posterPath,
      this.id,
      this.adult,
      this.backdropPath,
      this.originalLanguage,
      this.originalTitle,
      this.genreIds,
      this.title,
      this.voteAverage,
      this.overview,
      this.releaseDate,
      this.seen});

  Pelicula.fromJsonMap(Map<String, dynamic> json) {
    voteCount = json['vote_count'];
    video = json['video'];
    popularity = json['popularity'] / 1;
    posterPath = json['poster_path'];
    id = json['id'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    title = json['title'];
    voteAverage = json['vote_average'] / 1;
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

  Map<String, dynamic> toJson() => {
        "vote_count": voteCount,
        "video": video,
        "popularity": popularity,
        "poster_path": posterPath,
        "id": id,
        "adult": adult,
        "backdrop_path": backdropPath,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "genre_ids": genreIds,
        "title": title,
        "vote_average": voteAverage,
        "overview": overview,
        "release_date": releaseDate,
        "seen": seen
      };
  factory Pelicula.fromJson(Map<String, dynamic> json) => Pelicula(
        voteCount: json['vote_count'],
        // video: json['video'] as bool,
        popularity: json['popularity'] / 1,
        posterPath: json['poster_path'],
        id: json['id'],
        // adult: json['adult'] as bool,
        backdropPath: json['backdrop_path'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        // genreIds: json['genre_ids'].cast<int>(),
        title: json['title'],
        voteAverage: json['vote_average'] / 1,
        overview: json['overview'],
        releaseDate: json['release_date'],
        seen: json['seen'],
      );

  String getPosterImg() {
    if (posterPath == null) {
      return 'https://matthewsenvironmentalsolutions.com/images/com_hikashop/upload/thumbnails/400x400/not-available.png';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }

  String getBackgroundImg() {
    if (posterPath == null) {
      return 'https://matthewsenvironmentalsolutions.com/images/com_hikashop/upload/thumbnails/400x400/not-available.png';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }
  }
}
