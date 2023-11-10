

enum TargetsOrderBy {

  title( colName: "title"),
  totalCost( colName: "total_cost"),
  remainingCost( colName: "remaining_cost"),
  date( colName: "date");

  const TargetsOrderBy( {   required this.colName });

  final String colName;


  List<TargetsOrderBy> getList (){
    return TargetsOrderBy.values;
  }




}
