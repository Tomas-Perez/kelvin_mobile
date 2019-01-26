class LinkParser {
  const LinkParser();

  LinkInfo parse(String link) {
    final linkParts = link.split('/');
    if (linkParts.length != 2) throw FormatException();
    final type = linkParts[0].toLowerCase();
    final id = linkParts[1];
    return LinkInfo.fromTypeString(type: type, id: id);
  }
}

class LinkInfo {
  final LinkType type;
  final String id;

  LinkInfo({this.type, this.id});

  LinkInfo.fromTypeString({String type, this.id}) : type = stringToType(type);

  static LinkType stringToType(String type) {
    switch (type) {
      case 'device':
        return LinkType.device;
      case 'vehicle':
        return LinkType.vehicle;
      default:
        throw UnknownTypeException();
    }
  }
}

enum LinkType { device, vehicle }

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
