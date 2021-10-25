import 'package:flutter/material.dart';
import 'package:tectoyexemplo/Utils/constants.dart';

class ItemMenu extends StatelessWidget {
  final String text_menu;
  final double text_menu_size;
  final Color text_menu_cor;
  final String text_opcao;
  final double text_opcao_size;
  final Color text_opcao_cor;
  final IconData icon;
  final double icon_size;
  final Color icon_cor;
  final VoidCallback onTap;

  const ItemMenu({
    Key? key,
    required this.text_menu,
    required this.text_menu_size,
    required this.text_menu_cor,
    required this.text_opcao,
    required this.text_opcao_size,
    required this.text_opcao_cor,
    required this.icon,
    required this.icon_size,
    required this.icon_cor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: this.onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Constants.white),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this.text_menu,
                  style: TextStyle(
                      color: this.text_menu_cor, fontSize: this.text_menu_size),
                ),
                Row(
                  children: [
                    Text(
                      this.text_opcao,
                      style: TextStyle(
                          color: text_opcao_cor, fontSize: text_opcao_size),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Icon(
                      this.icon,
                      color: this.icon_cor,
                      size: this.icon_size,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
