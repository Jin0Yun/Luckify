import 'package:flutter/material.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/fortune_type.dart';
import 'package:luckify/presentation/widget/luckify_button.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FortuneEntity? selectedFortune;

  final List<FortuneEntity> fortunes = [
    const FortuneEntity(
      id: 1,
      name: '오늘의 운세',
      imageType: FortuneType.fortuneToday,
    ),
    const FortuneEntity(
      id: 2,
      name: '별자리 운세',
      imageType: FortuneType.zodiacFortune,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenSize.height * 0.1),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '특별한 운세가 필요하신가요?',
                      style: LuckifyTextStyles.fortuneTitle,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '원하는 운세를 선택해보세요.',
                      style: LuckifyTextStyles.fortuneHint,
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenSize.height * 0.05),

              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: fortunes.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final fortune = fortunes[index];
                    return LuckifyButton(
                      buttonText: fortune.name,
                      isActive: selectedFortune?.id == fortune.id,
                      imageName: fortune.imageType,
                      onPressed: () {
                        setState(() {
                          selectedFortune = fortune;
                        });
                      },
                    );
                  },
                ),
              ),

              if (selectedFortune != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: LuckifyButton(
                    buttonText: '선택하기',
                    isActive: true,
                    onPressed: () {},
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}