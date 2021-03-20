import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/flex_space.dart';
import '../providers/auth.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      child: Container(
        color: Color.fromRGBO(0, 0, 0, 0.8),
        child: Column(
          
          children: <Widget>[
            AppBar(title:Text('categories'),automaticallyImplyLeading: false,flexibleSpace: FlexSpace(),),
           
            ListTile(
              leading: Icon(Icons.shop,color: Colors.white,),
              title: Text('shop',style:TextStyle(color: Colors.white,fontSize: 18),),
              onTap: (){
                Navigator.of(context).pushReplacementNamed('/products-overview');
              },
            ),
            Divider(color: Colors.white38,),
            ListTile(
              leading: Icon(Icons.payment,color: Colors.white,),
              title: Text('Orders',style:TextStyle(color: Colors.white,fontSize: 18),),
              onTap: (){
                Navigator.of(context).pushReplacementNamed('/orders-screen');
              },
            ),
            Divider(color: Colors.white38,),
            ListTile(
              leading: Icon(Icons.edit,color: Colors.white,),
              title: Text('Your Products',style:TextStyle(color: Colors.white,fontSize: 18),),
              onTap: (){
                Navigator.of(context).pushReplacementNamed('/user-products');
              },
            ),

             Divider(color: Colors.white38,),
            ListTile(
              leading: Icon(Icons.exit_to_app,color: Colors.white,),
              title: Text('logout ',style:TextStyle(color: Colors.white,fontSize: 18),),
              onTap: (){
                 
                Provider.of<Auth>(context,listen: false).logOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            
          ],
        ),
      ),
    );
  }  
}