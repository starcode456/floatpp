
class Profile {
  String name;
  String uni;
  String profilepic;

  Profile({
    this.name,
    this.uni,
    this.profilepic,
  });

  Map toMap(Profile profile) {
    var data = Map<String, dynamic>();
    data['name'] = profile.name;

    data['uni'] = profile.uni;
    data['profilepic'] =profile.profilepic;

    return data;
  }

  // Named constructor
  Profile.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['name'];
    this.uni = mapData['uni'];
    this.profilepic = mapData['profilepic'];
  }
}
