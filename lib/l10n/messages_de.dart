// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "discover" : MessageLookupByLibrary.simpleMessage("Entdecken"),
    "list" : MessageLookupByLibrary.simpleMessage("List"),
    "movieadded" : MessageLookupByLibrary.simpleMessage("Film zu Ihrer Liste hinzugefügt"),
    "moviealready" : MessageLookupByLibrary.simpleMessage("Der Film ist bereits auf Ihrer Liste"),
    "movieremoved" : MessageLookupByLibrary.simpleMessage("Film entfernt"),
    "mylist" : MessageLookupByLibrary.simpleMessage("Meine Liste"),
    "notviewed" : MessageLookupByLibrary.simpleMessage("Film noch nicht gesehen"),
    "popular" : MessageLookupByLibrary.simpleMessage("Beliebt"),
    "search" : MessageLookupByLibrary.simpleMessage("Suchen nach"),
    "sharemovie" : MessageLookupByLibrary.simpleMessage("Film teilen"),
    "title" : MessageLookupByLibrary.simpleMessage("Movies App"),
    "towatchagain" : MessageLookupByLibrary.simpleMessage("Zum Ansehen erneut hinzufügen"),
    "viewed" : MessageLookupByLibrary.simpleMessage("schon gesehen"),
    "watch" : MessageLookupByLibrary.simpleMessage("schauen"),
    "watchthismovie" : MessageLookupByLibrary.simpleMessage("Schau dir diesen Film an!")
  };
}
