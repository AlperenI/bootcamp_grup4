import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  bool selected=false;
  @override
  Widget build(BuildContext context) {
    return Card(
                elevation: 8,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side:BorderSide(width: 2,color: Colors.blueGrey)
                ),
                color: Colors.white,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight:200,
                    minHeight: 120,
                  ),
                  child:ListTile(
                    
                    
                    onTap: () {
                      print("basıldı");
                    },
                    contentPadding: EdgeInsets.only(left:25,right: 35,top:5),
                    leading:ClipOval(child: 
                    Image.network(
                      'https://foto.sondakika.com/haber/2017/06/24/besiktas-carsiya-birlesik-magaza-9763360_amp.jpg',
                      height:50,width:50,fit: BoxFit.cover,
                      )
                    ), 
                    title: Text("Beşiktaş Çarşı Meydanı",style:TextStyle(fontSize:15,fontWeight: FontWeight.bold,color: Colors.red) ,),
                    subtitle: Text(maxLines:4,"Beşiktaş Çarşı Meydanı, İstanbul'un Beşiktaş ilçesinde yer alan ve semtin sosyal hayatının önemli bir parçasını oluşturan tarihi ve kültürel bir merkezdir. Çarşı Meydanı, Beşiktaş'ın canlı atmosferi ve çeşitli etkinlikleriyle bilinir."),
                    trailing: IconButton(
                      selectedIcon: Icon(Icons.favorite,color: Colors.red,),
                      isSelected: selected,
                      onPressed: () {
                      setState(() {
                       selected=!selected;
                      });
                    },
                    color: Colors.black,
                    padding: EdgeInsets.all(0),
                    iconSize: 25,
                    splashRadius: 1,
                    icon:Icon(Icons.favorite_outline,color: Colors.red,),
                    ),
                    dense: true,
                  )
                  ),
              );
  }
}