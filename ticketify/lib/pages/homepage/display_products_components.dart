
import 'package:ticketify/constants/constant_variables.dart';
import 'package:flutter/material.dart';

class FilterContainer extends StatefulWidget {
  const FilterContainer(
      {super.key, required this.children, required this.title});
  final List<Widget> children;
  final String title;
  @override
  State<FilterContainer> createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double size;
    if ( screenSize.width>kMobileWidthThreshold){
      size= 170;
    }else {
      size = screenSize.width;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
      child: Container(
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey, // Siyah renkli border
              width: 0.5, // Border kalınlığı
            ),
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1), // Gölge rengi ve opaklık seviyesi
                spreadRadius: 2, // Yayılma (spread) yarıçapı
                blurRadius: 4, // Bulanıklık (blur) yarıçapı
                offset: Offset(0, 9), // Gölge konumu (x, y)
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1 , color: Colors.grey)
                    )
                ),
                child: Center(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}

class ClickableText extends StatefulWidget {
  const ClickableText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  State<ClickableText> createState() => _ClickableTextState();
}

class _ClickableTextState extends State<ClickableText> {
  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
          onEnter: (event) {
            setState(() {
              color = Colors.black;
            });
          },
          onExit: (event) {
            setState(() {
              color = Colors.black;
            });
          },
          child:
          Center(child: Text(widget.text, style: TextStyle(color: color)))),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final String hint_text;
  const CustomSearchBar(this.hint_text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hint_text,
      hintStyle: MaterialStateProperty.all<TextStyle?>(AppFonts.allertaStencil),
      leading: const Icon(Icons.search),
      backgroundColor: MaterialStateProperty.all<Color?>(AppColors.blue),
      constraints: const BoxConstraints(
        minHeight: 40,
      ),
    );
  }
}
