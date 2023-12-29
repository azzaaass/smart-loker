import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_iot/data/data.dart';
import 'package:tubes_iot/style/color.dart';

class CategoryIcon extends StatefulWidget {
  final void Function(int) onTap;
  const CategoryIcon({
    super.key,
    required this.onTap,
  });

  @override
  State<CategoryIcon> createState() => _CategoryIconState();
}

class _CategoryIconState extends State<CategoryIcon> {
  int _categorySelected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: 
         
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: kategori.length,
              itemBuilder: (context, index) {
                bool isSelected = index == _categorySelected;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _categorySelected = index;
                      widget.onTap(index);
                    });
                  },
                  child: AnimatedContainer(
                    margin: EdgeInsets.only(
                      top: isSelected ? 10 : 25,
                      bottom: isSelected ? 10 : 25,
                      right: 10,
                    ),
                    width: isSelected ? 60 : 50,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastEaseInToSlowEaseOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          isSelected ? lightBrown : whiteBone,
                          isSelected ? brown : whiteBone,
                        ],
                      ),
                      boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.2), // Warna bayangan
                                spreadRadius: 0, // Lebar bayangan yang menyebar
                                blurRadius: 5,
                                offset: const Offset(3, 3),
                              ),
                            ],
                    ),
                    child: Center(
                        child: FaIcon(
                      kategori[index].icon,
                      size: isSelected ? 27 : 22,
                      color: isSelected ? Colors.white : textH1,
                    )),
                  ),
                );
              },
            ),
          )
        
    );
  }
}
