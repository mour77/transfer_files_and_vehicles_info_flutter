

enum HistoryTypes {


  none(id: 0, name: "None"),
  refuel(id: 1, name: "Refuel"),
  repair(id: 2, name: "Repair");

  const HistoryTypes( { required this.id,  required this.name });
  final int id;
  final String name;


  List<HistoryTypes> getList (){
    return HistoryTypes.values;
  }
}