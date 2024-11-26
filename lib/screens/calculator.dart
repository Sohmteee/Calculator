import 'package:app/res/res.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final inputController = TextEditingController();
  final scrollController = ScrollController();
  bool isSign = false;
  bool isEqualPressed = false;

  String result = '0';

  @override
  void initState() {
    super.initState();
    inputController.addListener(_scrollToEnd);
  }

  @override
  void dispose() {
    inputController.removeListener(_scrollToEnd);
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  String formatNumber(String number) {
    if (number.isEmpty) return '0';
    try {
      double value = double.parse(number.replaceAll(',', ''));
      return NumberFormat().format(value);
    } catch (e) {
      return number;
    }
  }

  void evaluateExpression() {
    String input = inputController.text.replaceAll(',', '');
    input = input.replaceAll('÷', '/').replaceAll('×', '*');

    try {
      Parser parser = Parser();
      Expression exp = parser.parse(input);
      ContextModel cm = ContextModel();

      double evaluationResult = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        result = (evaluationResult % 1 == 0)
            ? NumberFormat().format(evaluationResult.toInt())
            : NumberFormat()
                .format(double.parse(evaluationResult.toStringAsFixed(3)));
      });
    } catch (e) {
      setState(() {
        result = 'Error';
      });
    }
  }

  void evaluateAndSetInput() {
    String input = inputController.text.replaceAll(',', '');
    if (input.isNotEmpty &&
        ['÷', '×', '-', '+'].contains(input[input.length - 1])) {
      String sign = input[input.length - 1];
      input = input.substring(0, input.length - 1);
      inputController.text = formatNumber(input);
      evaluateExpression();
      inputController.text = result + sign;
    } else {
      evaluateExpression();
      inputController.text = result;
    }
    isEqualPressed = true;
  }

  @override
  Widget build(BuildContext context) {
    List<String> keys = [
      'AC',
      '⌫',
      '%',
      '÷',
      '7',
      '8',
      '9',
      '×',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '±',
      '0',
      '.',
      '=',
    ];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: inputController,
                    readOnly: true,
                    textAlign: TextAlign.right,
                    scrollPhysics: BouncingScrollPhysics(),
                    scrollController: scrollController,
                    style: TextStyle(
                      color: AppColors.grey(context),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: AppColors.grey(context),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  10.sH,
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      result,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  20.sH,
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.r),
              ),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(20.sp),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.sp,
                mainAxisSpacing: 10.sp,
              ),
              itemCount: keys.length,
              itemBuilder: (context, index) {
                String key = keys[index];
                Color? buttonColor;
                if (index < 3) {
                  buttonColor = Colors.red;
                } else if (index % 4 == 3) {
                  buttonColor = Colors.green;
                }

                return AnimatedButton(
                  onTap: () {
                    if (key == 'AC') {
                      setState(() {
                        inputController.text = '';
                        result = '0';
                        isEqualPressed = false;
                      });
                    } else if (key == '⌫') {
                      if (inputController.text.isNotEmpty) {
                        inputController.text = inputController.text
                            .substring(0, inputController.text.length - 1);
                        setState(() {
                          isSign = inputController.text.isNotEmpty &&
                              ['÷', '×', '-', '+'].contains(inputController
                                  .text[inputController.text.length - 1]);
                          inputController.text =
                              formatNumber(inputController.text);
                        });
                      }
                    } else if (key == '%') {
                      evaluateExpression();
                      try {
                        double value = double.parse(result.replaceAll(',', ''));
                        double percentageResult = value / 100;

                        setState(() {
                          result = (percentageResult % 1 == 0)
                              ? NumberFormat().format(percentageResult.toInt())
                              : NumberFormat().format(double.parse(
                                  percentageResult.toStringAsFixed(3)));
                          inputController.text = result;
                        });
                      } catch (e) {
                        setState(() {
                          result = 'Error';
                        });
                      }
                    } else if (key == '.') {
                      // Handle the decimal button
                      if (inputController.text.isEmpty || isEqualPressed) {
                        // Start with "0." if input is empty or result was just calculated
                        inputController.text = '0.';
                        result = '0';
                        isEqualPressed = false;
                      } else {
                        String lastNumber =
                            inputController.text.split(RegExp(r'[÷×\-+]')).last;
                        if (!lastNumber.contains('.')) {
                          inputController.text += '.';
                        }
                      }
                      setState(() {
                        isSign = false;
                        // inputController.text =
                        //     formatNumber(inputController.text);
                      });
                    } else if (key == '=') {
                      evaluateAndSetInput();
                    } else if (['÷', '×', '-', '+'].contains(key)) {
                      if (isEqualPressed) {
                        inputController.text = result + key;
                        isEqualPressed = false;
                      } else {
                        if (inputController.text.isNotEmpty && isSign) {
                          inputController.text = inputController.text
                              .substring(0, inputController.text.length - 1);
                        }
                        if (inputController.text.isNotEmpty) {
                          inputController.text += key;
                          setState(() {
                            isSign = true;
                          });
                        }
                      }
                    } else {
                      if (isEqualPressed) {
                        inputController.text = key;
                        result = '0';
                        isEqualPressed = false;
                      } else {
                        inputController.text += key;
                      }
                      setState(() {
                        isSign = false;
                        inputController.text =
                            formatNumber(inputController.text);
                      });
                      evaluateExpression();
                    }
                  },
                  color: buttonColor,
                  child: key,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
