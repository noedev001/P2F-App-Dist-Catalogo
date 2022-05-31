import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  final double imgHeight;
  HeroImage({required this.imgHeight});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset('assets/lauch.png'),
      width: MediaQuery.of(context).size.width,
      height: imgHeight,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onBtnPressed;
  CustomButton({required this.btnText, required this.onBtnPressed});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onBtnPressed,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              btnText,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
      color: Theme.of(context).primaryColor,
    );
  }
}

class CustomButtonShoping extends StatelessWidget {
  final String btnText;
  final VoidCallback onBtnPressed;
  CustomButtonShoping({required this.btnText, required this.onBtnPressed});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 68),
            Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            Text(
              btnText,
              //style: Theme.of(context).textTheme.bodyText1,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            SizedBox(width: 68),
          ],
        ),
      ),
      onPressed: onBtnPressed,
      color: Theme.of(context).primaryColor,
    );
  }
}

class SocialIcon extends StatelessWidget {
  final String iconanme;
  SocialIcon({required this.iconanme});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(iconanme),
      width: 40,
      height: 40,
    );
  }
}
