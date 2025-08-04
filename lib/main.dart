import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '计算器',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<CalculatorViewModel>(
              create: (_) => CalculatorViewModel(),
            ),
          ],
          child: child,
        );
      },
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatelessWidget {
  const CalculatorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('计算器')),
      body: const CalculatorScreen(),
    );
  }
}

enum HeaderStyle { calculator }

final class Header extends StatefulWidget {
  const Header({
    super.key,
    required this.style,
    this.showCalculator = false,
    this.displayText,
    this.outputText,
  });

  final HeaderStyle style;
  final bool showCalculator;
  final String? displayText;
  final String? outputText;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    // 释放滚动控制器
    _scrollController.dispose();
  }

  int get getCount {
    final bool isCalculator = widget.style == HeaderStyle.calculator;
    final bool showCalculator = widget.showCalculator;
    if (!isCalculator) {
      return 0;
    } else {
      if (showCalculator) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: <Widget>[
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.calculate,
                    size: 38,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    'Calculator',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.displayText ?? '',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 12),
                      Text(
                        widget.outputText ?? '',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ][getCount],
      ),
    );
  }
}

final class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 加载历史记录
    Provider.of<CalculatorViewModel>(context, listen: false).loadHistory();
  }

  @override
  void dispose() {
    // 销毁滚动控制器
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Consumer<CalculatorViewModel>(
              builder: (context, cvm, _) {
                return Header(
                  style: HeaderStyle.calculator,
                  showCalculator: cvm.isShowCalculator,
                  displayText: cvm.getDisplayText,
                  outputText: cvm.getOutput,
                );
              },
            ),
            Card.filled(
              margin: const EdgeInsets.only(
                left: 16,
                top: 8,
                right: 16,
                bottom: 16,
              ),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Consumer<CalculatorViewModel>(
                builder: (context, cvm, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CalculatorButton(
                            content: CalculatorButtonContent.clear,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.normal,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.backspace,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.normal,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.percent,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.normal,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.divide,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.normal,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CalculatorButton(
                            content: CalculatorButtonContent.seven,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.number,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.eight,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.number,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.nine,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.number,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.multiply,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.normal,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CalculatorButton(
                            content: CalculatorButtonContent.four,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.number,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.five,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.number,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.six,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.number,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.subtract,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.normal,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CalculatorButton(
                            content: CalculatorButtonContent.one,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.number,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.two,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.number,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.three,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.number,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.add,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.normal,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CalculatorButton(
                            content: CalculatorButtonContent.history,
                            onExec: (_) {
                              showBottomSheet(
                                context: context,
                                showDragHandle: true,
                                enableDrag: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                builder: (context) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '历史记录',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('清除历史记录'),
                                                      content: Text(
                                                        '是否清除计算器历史记录?',
                                                      ),
                                                      actions: [
                                                        Tooltip(
                                                          message: '取消',
                                                          child: TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                  context,
                                                                ).pop(),
                                                            child: Text('取消'),
                                                          ),
                                                        ),
                                                        Tooltip(
                                                          message: '确定',
                                                          child: Consumer<CalculatorViewModel>(
                                                            builder: (context, cvm, _) {
                                                              return TextButton(
                                                                onPressed: () {
                                                                  cvm.clearHistory(); // 清除历史记录
                                                                  for (
                                                                    int i = 0;
                                                                    i < 2;
                                                                    i++
                                                                  ) {
                                                                    // 执行两次,一次关对话框,一次关底部弹出菜单
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop();
                                                                  }
                                                                },
                                                                child: Text(
                                                                  '确定',
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(Icons.delete),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(Icons.close),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(height: 1),
                                      Expanded(
                                        child: Consumer<CalculatorViewModel>(
                                          builder: (context, cvm, _) {
                                            return ListView.builder(
                                              itemCount: cvm.getHistory.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  onLongPress: () {},
                                                  title: Text(
                                                    cvm.getHistory.reversed
                                                        .toList()[index],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: CalculatorButtonStyle.normal,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.zero,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.number,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.point,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.normal,
                          ),
                          CalculatorButton(
                            content: CalculatorButtonContent.equal,
                            onExec: (content) {
                              setState(() => cvm.computing(content));
                            },
                            style: CalculatorButtonStyle.normal,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 计算器按钮样式
enum CalculatorButtonStyle {
  number, //数字键
  normal, //运算符号键
}

/// 计算器按钮类型
enum CalculatorButtonType {
  text, // 文本按钮
  icon, // 图标按钮
}

/// 计算器按钮内容
enum CalculatorButtonContent {
  /// 数字0
  zero(type: CalculatorButtonType.text, text: '0'),

  /// 数字1
  one(type: CalculatorButtonType.text, text: '1'),

  /// 数字2
  two(type: CalculatorButtonType.text, text: '2'),

  /// 数字3
  three(type: CalculatorButtonType.text, text: '3'),

  /// 数字4
  four(type: CalculatorButtonType.text, text: '4'),

  /// 数字5
  five(type: CalculatorButtonType.text, text: '5'),

  /// 数字6
  six(type: CalculatorButtonType.text, text: '6'),

  /// 数字7
  seven(type: CalculatorButtonType.text, text: '7'),

  /// 数字8
  eight(type: CalculatorButtonType.text, text: '8'),

  /// 数字9
  nine(type: CalculatorButtonType.text, text: '9'),

  /// 加法
  add(type: CalculatorButtonType.text, text: '+'),

  /// 减法
  subtract(type: CalculatorButtonType.text, text: '-'),

  /// 乘法
  multiply(type: CalculatorButtonType.text, text: 'x'),

  /// 除法
  divide(type: CalculatorButtonType.text, text: '÷'),

  /// 等于
  equal(type: CalculatorButtonType.text, text: '='),

  /// 清除
  clear(type: CalculatorButtonType.text, text: 'C'),

  /// 删除
  backspace(type: CalculatorButtonType.icon, icon: Icons.backspace_outlined),

  /// 百分号
  percent(type: CalculatorButtonType.icon, icon: Icons.percent),

  /// 小数点
  point(type: CalculatorButtonType.text, text: '.'),

  /// 历史记录
  history(type: CalculatorButtonType.icon, icon: Icons.history);

  final CalculatorButtonType type;

  /// 按钮文本
  final String? text;

  /// 按钮图标
  final IconData? icon;

  /// 计算器按钮内容
  const CalculatorButtonContent({required this.type, this.text, this.icon});
}

/// 计算器执行计算回调
typedef CalculatorExecCallback = void Function(CalculatorButtonContent content);

/// 计算器按钮
class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    super.key,
    required this.content,
    required this.onExec,
    required this.style,
  });

  final CalculatorButtonStyle style;
  final CalculatorButtonContent content;
  final CalculatorExecCallback onExec;

  Color getForegroundColor(BuildContext context) {
    switch (style) {
      case CalculatorButtonStyle.number:
        return Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white;
      case CalculatorButtonStyle.normal:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Widget getContent(BuildContext context) {
    switch (content.type) {
      case CalculatorButtonType.text:
        return Text(
          content.text!,
          style: TextStyle(fontSize: 25, color: getForegroundColor(context)),
        );
      case CalculatorButtonType.icon:
        return Icon(content.icon, size: 25, color: getForegroundColor(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(5),
        child: TextButton(
          onPressed: () => onExec(content),
          style: TextButton.styleFrom(padding: EdgeInsets.all(25)),
          child: getContent(context),
        ),
      ),
    );
  }
}

abstract interface class ICalculatorViewModel {
  /// 计算器执行计算
  void computing(CalculatorButtonContent content);

  /// 计算器清理历史记录
  Future<void> clearHistory();

  /// 计算器加载历史记录
  Future<void> loadHistory();

  /// 计算器获取历史记录
  List<String> get getHistory;

  /// 计算器获取当前输入的数字
  String get getDisplayText;

  /// 计算器获取计算结果
  String get getOutput;

  bool get isShowCalculator;
}

enum OperatorType {
  /// 加法
  add,

  /// 减法
  subtract,

  /// 乘法
  multiply,

  /// 除法
  divide,

  /// 空的，啥也不是
  nothing,
}

final class CalculatorViewModel
    with ChangeNotifier
    implements ICalculatorViewModel {
  /// 计算结果
  String _output = "0";

  /// 数字1
  double _num1 = 0;

  /// 数字2
  double _num2 = 0;

  /// 运算符
  OperatorType _operator = OperatorType.nothing;

  /// 第一行的显示文本
  String _displayText = '';

  /// 计算器历史记录
  List<String> _history = [];

  bool showCalculator = false;

  @override
  void computing(CalculatorButtonContent content) {
    switch (content) {
      case CalculatorButtonContent.clear:
        showCalculator = false;
        _output = 0.toString();
        _num1 = 0;
        _num2 = 0;
        _operator = OperatorType.nothing;
        _displayText = '';
        break;
      case CalculatorButtonContent.add:
      case CalculatorButtonContent.subtract:
      case CalculatorButtonContent.multiply:
      case CalculatorButtonContent.divide:
        showCalculator = true;
        _num1 = double.parse(_output);
        switch (content) {
          case CalculatorButtonContent.add:
            _operator = OperatorType.add;
            break;
          case CalculatorButtonContent.subtract:
            _operator = OperatorType.subtract;
            break;
          case CalculatorButtonContent.multiply:
            _operator = OperatorType.multiply;
            break;
          case CalculatorButtonContent.divide:
            _operator = OperatorType.divide;
            break;
          default:
            _operator = OperatorType.nothing;
        }
        _displayText = '$_output ${content.text}';
        _output = 0.toString();
        break;
      case CalculatorButtonContent.equal:
        showCalculator = true;
        _num2 = double.parse(_output);
        double result = 0;
        String operatorStr = '';
        switch (_operator) {
          case OperatorType.add:
            result = _num1 + _num2;
            operatorStr = CalculatorButtonContent.add.text ?? '';
            break;
          case OperatorType.subtract:
            result = _num1 - _num2;
            operatorStr = CalculatorButtonContent.subtract.text ?? '';
            break;
          case OperatorType.multiply:
            result = _num1 * _num2;
            operatorStr = CalculatorButtonContent.multiply.text ?? '';
            break;
          case OperatorType.divide:
            if (_num2 != 0) {
              result = _num1 / _num2;
            } else {
              result = double.nan; // 除数为0，返回NaN
            }
            operatorStr = CalculatorButtonContent.divide.text ?? '';
            break;
          case OperatorType.nothing:
            break;
        }
        _output = result.toString();
        // 添加历史记录
        String historyItem = "$_num1 $operatorStr $_num2 = $_output";
        _history.add(historyItem);
        _saveHistory(); // 保存历史记录
        break;
      case CalculatorButtonContent.percent:
        showCalculator = true;
        double num = double.parse(_output);
        double percentage = num / 100;
        _output = percentage.toString();
        break;
      case CalculatorButtonContent.point:
        showCalculator = true;
        if (!_output.contains(".")) {
          _output += ".";
        }
        break;
      case CalculatorButtonContent.backspace:
        showCalculator = true;
        // 处理删除逻辑
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = 0.toString();
        }
        break;
      default:
        showCalculator = true;
        if (content.type == CalculatorButtonType.text) {
          if (_output == 0.toString()) {
            _output = content.text ?? '';
          } else {
            _output = _output + (content.text ?? '');
          }
        }
        break;
    }
  }

  Future<void> _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('history', _history);
    debugPrint('已保存历史记录!');
  }

  @override
  Future<void> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('history');
    if (history != null) _history = history;
  }

  @override
  Future<void> clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
    _history = [];
    debugPrint('已清理历史记录!');
  }

  @override
  List<String> get getHistory => _history;

  @override
  String get getDisplayText => _displayText;

  @override
  String get getOutput => _output;

  @override
  bool get isShowCalculator => showCalculator;
}
