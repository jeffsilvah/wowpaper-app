import 'package:flutter/material.dart';

void navigate({context, route}){
  Navigator.push(context, MaterialPageRoute(builder: (context) => route));
}