

enum OrderByTypes {


  date(id: 1, name: "date"),
  odometer(id: 2, name: "odometer"),
  money(id: 3, name: "money");

  const OrderByTypes( { required this.id,  required this.name });
  final int id;
  final String name;


  List<OrderByTypes> getList (){
    return OrderByTypes.values;
  }
}