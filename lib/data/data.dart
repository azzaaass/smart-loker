import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Product {
  final String image;
  final String title;
  final String description;
  const Product(
      {required this.image, required this.title, required this.description});
}

class Kategori {
  final IconData icon;
  final String kategori;
  final List<Product> content;
  const Kategori(
      {required this.icon, required this.kategori, required this.content});
}

const List<Kategori> kategori = [
  Kategori(icon: FontAwesomeIcons.lightbulb, kategori: "Smart Bulb", content: [
    Product(
        image: "assets/images/lamp1.png",
        title: "Lamp automation",
        description:
            "Bebaskan diri anda dari menekan saklar dengan lamp automation")
  ]),
  Kategori(icon: FontAwesomeIcons.lock, kategori: "Smart Loker", content: [
    Product(
        image: "assets/images/loker1.png",
        title: "Locker automation",
        description: "Amankan barang anda dengan sistem yang serba otomatis"),
    Product(
        image: "assets/images/loker2.png",
        title: "Locker Timer",
        description: "Gunakan loker sesuai dengan kebutuhan anda"),
    Product(
        image: "assets/images/loker3.png",
        title: "Locker Scalabel",
        description: "Butuh banyak penyimpanan? Cobalah locker scalabel"),
  ]),
  Kategori(
      icon: FontAwesomeIcons.personBiking,
      kategori: "Smart Cycle",
      content: [
        Product(
            image: "assets/images/cycle1.png",
            title: "Electric Cycle",
            description: "Jelajahi kota dengan menaiki sepeda listrik"),
        Product(
            image: "assets/images/cycle2.png",
            title: "Manual Cycle",
            description: "Ingin yang lebih sehat? kami juga menyediakan sepeda manual"),
      ]),
];
