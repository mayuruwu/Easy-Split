class Group {
  final String id;
  final String name;
  final List<String> memberIds;

  Group({required this.id, required this.name, required this.memberIds});

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
      memberIds: List<String>.from(map['memberIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'memberIds': memberIds};
  }
}
