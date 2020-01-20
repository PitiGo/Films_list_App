import 'dart:async';
import 'package:flutter/material.dart';
import 'package:My_Films/l10n/messages_all.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }


// The movie is already on your list

  String get title {
    return Intl.message('My films', name: 'title', desc: 'Movies');
  }

  String get popular {
    return Intl.message('Popular', name: 'popular', desc: 'Popular');
  }

  String get discover {
    return Intl.message('Discover', name: 'discover', desc: 'discover');
  }

  String get mylist {
    return Intl.message('My List', name: 'mylist', desc: 'My list');
  }

  String get search {
    return Intl.message('Search', name: 'search', desc: 'Search');
  }

  String get watch {
    return Intl.message('To watch', name: 'watch', desc: 'To watch');
  }

  String get viewed {
    return Intl.message('viewed', name: 'viewed', desc: 'already watched');
  }
  String get notviewed {
    return Intl.message('Movie not seen yet', name: 'notviewed', desc: 'Movie not seen yet');
  }
  String get sharemovie {
    return Intl.message('Share movie', name: 'sharemovie', desc: 'Share movie');
  }
  String get watchthismovie {
    return Intl.message('Watch this movie!', name: 'watchthismovie', desc: 'Watch this movie');
  }
  String get movieadded {
    return Intl.message('Movie added to your list', name: 'movieadded', desc: 'Movie added to your list');
  }
  String get moviealready {
    return Intl.message('The movie is already on your list', name: 'moviealready', desc: 'The movie is already on your list');
  }

  String get towatchagain {
    return Intl.message('Add to watch again',
        name: 'towatchagain', desc: 'already watched');
  }


  String get movieremoved {
    return Intl.message('Movie removed',
        name: 'movieremoved', desc: 'Movie removed');
  }

  String get list {
    return Intl.message('List', name: 'list');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'pt', 'de', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
