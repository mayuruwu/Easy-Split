class Member {
  final String id; // usually Firebase uid
  final String name;
  final String? upi;
  final String? photoUrl;

  Member({required this.id, required this.name, this.upi, this.photoUrl});

  // 🔸 Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'upi': upi, 'photoUrl': photoUrl};
  }

  // 🔸 Convert from Firestore
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      name: map['name'],
      upi: map['upi'],
      photoUrl: map['photoUrl'],
    );
  }
}
