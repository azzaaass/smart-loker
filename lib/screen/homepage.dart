import 'package:flutter/material.dart';
import 'package:tubes_iot/screen/component/category_icon.dart';
import 'package:tubes_iot/data/data.dart';
import 'package:tubes_iot/screen/component/header.dart';
import 'package:tubes_iot/style/color.dart';
import 'package:tubes_iot/style/text.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _categorySelected = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(
          children: [
            const Header(),
            const SizedBox(
              height: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Public Acess", style: text_22_700),
                Text("Product Comunity", style: text_22_700),
                const SizedBox(
                  height: 5,
                ),
                Text("Beralih ke fasilitas publik sekarang !",
                    style: text_12_300),
                const SizedBox(
                  height: 10,
                ),
                CategoryIcon(
                  onTap: (int categorySelected) {
                    setState(() {
                      _categorySelected = categorySelected;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kategori[_categorySelected].kategori,
                    style: text_18_700,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: kategori[_categorySelected].content.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          decoration: BoxDecoration(
                            color: whiteBone,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.1), // Warna bayangan
                                spreadRadius: 0, // Lebar bayangan yang menyebar
                                blurRadius: 5,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3.8,
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset(
                                        kategori[_categorySelected]
                                            .content[index]
                                            .image)),
                              ),
                              SizedBox(
                                // color: Colors.red,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      kategori[_categorySelected]
                                          .content[index]
                                          .title,
                                      softWrap: true,
                                      style: text_14_700,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      kategori[_categorySelected]
                                          .content[index]
                                          .description,
                                      softWrap: true,
                                      style: text_12_300,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
