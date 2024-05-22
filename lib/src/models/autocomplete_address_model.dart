class AutoCompleteAddress {
  AutoCompleteAddress({
    this.predictions = const [],
    this.status = '',
  });

  factory AutoCompleteAddress.fromJson(Map<String, dynamic> json) =>
      AutoCompleteAddress(
        predictions: List<Prediction>.from(
          (json['predictions'] ?? []).map(
            (x) => Prediction.fromJson(x ?? {}),
          ),
        ),
        status: json['status'] ?? '',
      );
  List<Prediction> predictions;
  String status;

  Map<String, dynamic> toJson() => {
        'predictions':
            List<dynamic>.from(predictions.map((Prediction x) => x.toJson())),
        'status': status,
      };
}

class Prediction {
  Prediction({
    this.description = '',
    this.matchedSubstrings = const [],
    this.placeId = '',
    this.reference = '',
    this.structuredFormatting,
    this.terms = const [],
    this.types = const [],
  }) {
    structuredFormatting ??= StructuredFormatting();
  }

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json['description'] ?? '',
        matchedSubstrings: List<MatchedSubstring>.from(
          (json['matched_substrings'] ?? []).map(
            (x) => MatchedSubstring.fromJson(x),
          ),
        ),
        placeId: json['place_id'] ?? '',
        reference: json['reference'] ?? '',
        structuredFormatting:
            StructuredFormatting.fromJson(json['structured_formatting'] ?? {}),
        terms: List<Term>.from(
          (json['terms'] ?? []).map(
            (x) => Term.fromJson(x),
          ),
        ),
        types: List<String>.from(
          (json['types'] ?? []).map(
            (x) => x,
          ),
        ),
      );
  String description;
  List<MatchedSubstring> matchedSubstrings;
  String placeId;
  String reference;
  StructuredFormatting? structuredFormatting;
  List<Term> terms;
  List<String> types;

  Map<String, dynamic> toJson() => {
        'description': description,
        'matched_substrings': List<dynamic>.from(
            matchedSubstrings.map((MatchedSubstring x) => x.toJson())),
        'place_id': placeId,
        'reference': reference,
        'structured_formatting': structuredFormatting!.toJson(),
        'terms': List<dynamic>.from(terms.map((Term x) => x.toJson())),
        'types': List<dynamic>.from(types.map((String x) => x)),
      };
}

class MatchedSubstring {
  MatchedSubstring({
    this.length = 0,
    this.offset = 0,
  });

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json['length'] ?? 0,
        offset: json['offset'] ?? 0,
      );
  int length;
  int offset;

  Map<String, dynamic> toJson() => {
        'length': length,
        'offset': offset,
      };
}

class StructuredFormatting {
  StructuredFormatting({
    this.mainText = '',
    this.mainTextMatchedSubstrings = const [],
    this.secondaryText = '',
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json['main_text'] ?? '',
        mainTextMatchedSubstrings: List<MatchedSubstring>.from(
            (json['main_text_matched_substrings'] ?? [])
                .map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: (json['secondary_text'] ?? ''),
      );
  String mainText;
  List<MatchedSubstring> mainTextMatchedSubstrings;
  String secondaryText;

  Map<String, dynamic> toJson() => {
        'main_text': mainText,
        'main_text_matched_substrings': List<dynamic>.from(
            mainTextMatchedSubstrings.map((MatchedSubstring x) => x.toJson())),
        'secondary_text': secondaryText,
      };
}

class Term {
  Term({
    this.offset = 0,
    this.value = '',
  });

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        offset: json['offset'] = 0,
        value: json['value'] = '',
      );
  int offset;
  String value;

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'value': value,
      };
}
