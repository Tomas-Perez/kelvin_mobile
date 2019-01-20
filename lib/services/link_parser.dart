class LinkParser {
  LinkInfo parse(String link) {
    final linkParts = link.split('/');
    if (linkParts.length != 2) throw FormatException();
    final type = linkParts[0].toLowerCase();
    final id = linkParts[1];
    return LinkInfo.fromTypeString(type: type, id: id);
  }

  const LinkParser();
}

class LinkInfo {
  final LinkType type;
  final String id;

  LinkInfo({this.type, this.id});

  static LinkType stringToType(String type) {
    switch (type) {
      case 'device':
        return LinkType.DEVICE;
      case 'vehicle':
        return LinkType.VEHICLE;
      default:
        throw UnknownTypeException();
    }
  }

  LinkInfo.fromTypeString({String type, this.id}) : type = stringToType(type);
}

enum LinkType { DEVICE, VEHICLE }

class LinkParseException implements Exception {
  final String message;

  const LinkParseException(this.message);
}

class UnknownTypeException implements LinkParseException {
  final String message =
      'Link type is unknown, must be one of ${LinkType.values.join(", ")}';

  UnknownTypeException();
}

class FormatException implements LinkParseException {
  final String message = 'Invalid format, must be a pattern of \$type/\$id';

  const FormatException();
}
