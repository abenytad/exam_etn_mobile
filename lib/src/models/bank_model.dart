class BankModel {
  final String id;
  final String name;
  final String accountNumber;
  final String imageUrl;
  final String referenceNumber;
  BankModel({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.imageUrl,
    required this.referenceNumber,
  });
  BankModel.fromApi(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        name = parsedJson['name'] ?? '',
        accountNumber = parsedJson['accountNumber'] ?? '',
        imageUrl = parsedJson['imageUrl'] ?? '',
        referenceNumber = parsedJson['referenceNumber'] ?? '';
}


