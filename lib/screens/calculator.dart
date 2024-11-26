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

  void evaluateExpression() {
    String input = inputController.text;

    if (input.trim().isEmpty) {
      setState(() {
        result = '0';
      });
      return;
    }

    input = input.replaceAll('÷', '/').replaceAll('×', '*');

    isSign = inputController.text.isNotEmpty &&
        ['÷', '×', '-', '+']
            .contains(inputController.text[inputController.text.length - 1]);

    if (isSign) {
      input = input.substring(0, input.length - 1);
    }

    try {
      Parser parser = Parser();
      Expression exp = parser.parse(input);
      ContextModel cm = ContextModel();

      double evaluationResult = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        result = (evaluationResult % 1 == 0)
            ? NumberFormat().format(evaluationResult.toInt())
            : NumberFormat('0.#######').format(evaluationResult);
      });
    } catch (e) {
      setState(() {
        result = 'Error';
      });
    }
  }

  void evaluateAndSetInput() {
    String input = inputController.text.replaceAll(',', '');
    setState(() {
      if (input.isNotEmpty &&
          ['÷', '×', '-', '+'].contains(input[input.length - 1])) {
        String sign = input[input.length - 1];
        input = input.substring(0, input.length - 1);

        isSign = true;

        evaluateExpression();
        inputController.text = result + sign;
      } else {
        evaluateExpression();
        inputController.text = result;
      }
      isEqualPressed = true;
    });
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      children: inputController.text.split('').map((char) {
                        Color color = ['÷', '×', '-', '+'].contains(char)
                            ? Colors.amber
                            : AppColors.grey(context);
                        return TextSpan(
                          text: ['÷', '×', '-', '+'].contains(char)
                              ? ' $char '
                              : char,
                          style: TextStyle(
                            color: color,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  10.sH,
                  Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      child: Text(
                        result,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
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
                if (index < 2) {
                  buttonColor = AppColors.red(context);
                } else if (index % 4 == 3 || index == 2) {
                  buttonColor = Colors.amber;
                }
                if (index == keys.length - 1) {
                  buttonColor = AppColors.green(context);
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
                        });

                        evaluateExpression();
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
                                  percentageResult.toStringAsFixed(7)));
                          inputController.text = result;
                        });
                      } catch (e) {
                        setState(() {
                          result = 'Error';
                        });
                      }
                    } else if (key == '.') {
                      if (inputController.text.isEmpty || isEqualPressed) {
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
                      });
                    } else if (key == '±') {
                      evaluateExpression();
                      try {
                        double value = double.parse(result);
                        double toggledResult = -value;

                        setState(() {
                          result = (toggledResult % 1 == 0)
                              ? toggledResult.toInt().toString()
                              : toggledResult.toString();
                          inputController.text = result;
                        });
                      } catch (e) {
                        setState(() {
                          result = 'Error';
                        });
                      }
                    } else if (key == '=') {
                      evaluateAndSetInput();
                    } else if (['÷', '×', '-', '+'].contains(key)) {
                      if (isEqualPressed) {
                        setState(() {
                          inputController.text = result + key;
                          isEqualPressed = false;
                          isSign = true;
                        });
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
                        if (isSign) {
                          inputController.text += key;
                        } else {
                          inputController.text = key;
                        }
                        result = '0';
                        isEqualPressed = false;
                      } else {
                        inputController.text += key;
                      }
                      setState(() {
                        isSign = false;
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
