class Quote {
  final int id;
  final String quote;
  final String meaning;

  Quote({
    required this.id,
    required this.quote,
    required this.meaning,
  });

  // Factory method to create a Quote from a map (e.g., from JSON)
  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      quote: map['quote'],
      meaning: map['meaning'],
    );
  }

  // Method to convert a Quote instance to a map (e.g., to JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quote': quote,
      'meaning': meaning,
    };
  }}