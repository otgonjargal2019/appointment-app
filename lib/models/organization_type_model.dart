class OrganizationTypeModel {
  final String name;
  final String? description;

  OrganizationTypeModel({
    required this.name,
    this.description,
  });

  factory OrganizationTypeModel.fromJson(Map<String, dynamic> json) {
    return OrganizationTypeModel(
        name: json['name'], description: json['description']);
  }
}
