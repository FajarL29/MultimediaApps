import 'package:flutter/material.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:go_router/go_router.dart';

class PhoneComponent extends StatefulWidget {
  const PhoneComponent({super.key});

  @override
  State<PhoneComponent> createState() => _PhoneComponentState();
}

class _PhoneComponentState extends State<PhoneComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: SafeArea(
            child: Stack(
          children: [
            DialPad(
                enableDtmf: true,
                outputMask: "000000000000",
                hideSubtitle: true,
                backspaceButtonIconColor: Colors.red,
                buttonTextColor: Colors.white,
                dialOutputTextColor: Colors.white,
                keyPressed: (value) {
                  print('$value was pressed');
                },
                makeCall: (number) {
                  print(number);
                }),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        )));
  }
}
