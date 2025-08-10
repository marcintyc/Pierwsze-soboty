import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informacje')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Nabożeństwo pierwszych sobót miesiąca (Fatima 1917, objawienie z 1925 r. siostrze Łucji) polega na czterech warunkach: '
            'spowiedź święta, komunia święta, odmówienie jednej części Różańca oraz 15-minutowe rozmyślanie nad tajemnicami różańcowymi.\n',
          ),
          SizedBox(height: 12),
          Text('Obietnica Maryi:'),
          Text(
            '„Tym, którzy przez pięć miesięcy w pierwsze soboty odprawią nabożeństwa, w stanie łaski i w intencji wynagradzającej jej Niepokalanemu Sercu, wyjednam łaski potrzebne do zbawienia.”',
          ),
          SizedBox(height: 12),
          Text('Pięć zniewag wobec Niepokalanego Serca Maryi:'),
          SizedBox(height: 6),
          Text('1) Przeciw Niepokalanemu Poczęciu'),
          Text('2) Przeciw Dziewictwu Maryi'),
          Text('3) Przeciw Bożemu Macierzyństwu'),
          Text('4) Obojętność i wrogość wobec dzieci względem Matki Bożej'),
          Text('5) Znieważanie świętych wizerunków Maryi'),
          SizedBox(height: 12),
          Text('Modlitwy:'),
          Text('Po każdej tajemnicy: "O mój Jezu, przebacz nam nasze grzechy, zachowaj nas od ognia piekielnego, zaprowadź wszystkie dusze do nieba i dopomóż szczególnie tym, którzy najbardziej potrzebują Twojego miłosierdzia."'),
          SizedBox(height: 12),
          Text('FAQ:'),
          Text('Czy można odprawić w niedzielę? — Za zgodą kapłana można przenieść niektóre praktyki, gdy zachodzi poważna przeszkoda.'),
        ],
      ),
    );
  }
}