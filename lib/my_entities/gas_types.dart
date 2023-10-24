

enum GasTypes {

  oil(id: 1, text: "Oil"),
  diesel(id: 2, text: "Diesel");

  const GasTypes( { required this.id,  required this.text });
  final int id;
  final String text;


  List<GasTypes> getList (){
    return GasTypes.values;
  }
}