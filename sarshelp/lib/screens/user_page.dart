import 'package:flutter/material.dart';

Widget showProfile() {
    return Stack(
	    alignment: Alignment.center,
	    children: <Widget>[
			PopupMenuButton<String>(
				// onSelected: home_page._select,
				itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
					const PopupMenuItem<String>(
					value: 'Cerrar Sesion',
					child: Text('Cerrar Sesion')
					),
					const PopupMenuItem<String>(
					value: 'Right here',
					child: Text('Ayuda')
					),
					const PopupMenuItem<String>(
					value: 'Hooray!',
					child: Text('Donar!')
					),],
			),
		    // background image and bottom contents
		    Column(
			    children: <Widget>[
					Expanded(
						child: Container(
							color: Colors.white,
								child:  Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: <Widget>[
										Container(
											margin: EdgeInsets.only(left: 20.0,right: 40.0, top:100.0),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: <Widget>[
													Text(
														"Gaudic",
														textAlign:TextAlign.left,
														textScaleFactor: 1.3,
														style: new TextStyle(fontWeight: FontWeight.bold)),
													Text(
														"Benjamín Gautier Ortiz",
														textAlign:TextAlign.left,
														textScaleFactor: 1.3,),
														Divider(height: 10.0, color:Colors.blueGrey),
												],	
											) ,
										),
										new  Card(
											color:  Colors.grey.shade200,
											margin: EdgeInsets.only(left:20.0, top:40.0, right:20.0, bottom:10.0),
											child: new SizedBox(
												height: 300.0,
												width: 440.0,
													child: Column(
														children:<Widget>[
															Container(
																child:Text('Empresas',textScaleFactor: 1.5,textAlign: TextAlign.right,),
																),	
															Row(
																children: <Widget>[
																	new DropdownButton<String>(
																		hint: new DropdownMenuItem<String>(value:"",child:Text("Elija un empresa")),
																		items: <String>['Gaudic', 'Prodeco', 'Cedimed', 'Dima'].map((String value) {
																		return new DropdownMenuItem<String>(
																			value: value,
																			child: new Text(value),
																		);
																		}).toList(),
																		onChanged: (_) {},
																		)
																],
															),
															Divider(height: 20.0, color:Colors.blueAccent),
															Row(
																children: <Widget>[
																	Text('Deuda Total ',textScaleFactor: 1.2,textAlign: TextAlign.right,),
																],
															),
															Divider(height: 20.0, color:Colors.blueAccent),
														],
													)
												)
										),
									],
								),
						),
					),
				]
			),
			// Profile image
			Positioned(
				top: 20.0,
				left: 20.0,
				child: Container(
					height: 70.0,
					width: 70.0,
					decoration: BoxDecoration(
						shape: BoxShape.circle,
						color: Colors.green,
						image:DecorationImage( image:  new ExactAssetImage('assets/benja.jpg'),
						fit: BoxFit.cover)
					),
				),
			)
	      ],
    );
}
