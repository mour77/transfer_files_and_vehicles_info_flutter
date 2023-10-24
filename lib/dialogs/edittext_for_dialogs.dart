

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/gas_types.dart';

Widget getEdittext(String title, TextEditingController controller ,
    {TextInputType textInputType = TextInputType.text} ){

  return
     Padding(
       padding: const EdgeInsets.all(8.0),
       child: TextField(
         maxLines: null, // Set to null or 0 to allow text to wrap to the next line
         controller: controller,
         keyboardType: textInputType,


         decoration: InputDecoration(
             labelText: title,
             focusedBorder: const OutlineInputBorder(
               borderSide: BorderSide(color: Colors.black, width: 0.5),
             ),
             enabledBorder: const OutlineInputBorder(
               borderSide: BorderSide(color: Colors.black, width: 0.5),
             ),
             border: const OutlineInputBorder(),
             counterText: '',
             hintStyle: const TextStyle(color: Colors.black, fontSize: 14.0)),
       ),
     );
}












Widget getEdittextDatePicker(String title, TextEditingController controller , BuildContext context){




  return
    Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      TextField(
        //enableInteractiveSelection: false, // Disable text selection
        readOnly: true,
        controller: controller,
        onTap: () async {
          print('eleos');
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );

          if (picked != null ) {
            controller.text = '${'${picked.day}/${picked.month}'}/${picked.year}';
          }
       }
       ,

        decoration: InputDecoration(
            labelText: title,


            suffixIcon: IconButton(

              icon: const Icon(Icons.calendar_today), onPressed: () {  },
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.5),
            ),
            border: const OutlineInputBorder(),
            counterText: '',
            hintStyle: const TextStyle(color: Colors.black, fontSize: 14.0)),
      ),
    );



}





