import 'dart:async';
import 'package:appium_driver/async_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'logger.dart';

delay(int v) async {
  await Future.delayed(Duration(seconds: v));
}

var months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June ",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> process = [];
  late TerminalBloc _terminalBloc;

  @override
  void initState() {
    super.initState();
    _terminalBloc = TerminalBloc();

    // Listen to the Process stream and update the Process value when it changes
    _terminalBloc.processStream.listen((v) {
      setState(() {
        process = v;
      });
    });
  }

  @override
  void dispose() {
    _terminalBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("reg facebook"),
            onTap: () {
              registerFb();
            },
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text("logger", textAlign: TextAlign.start),
                Spacer(),
                TextButton(
                    onPressed: () {
                      _terminalBloc
                          .addProcess({"connected": "start"}.toString());
                    },
                    child: Text("add text")),
                InkWell(
                  onTap: () {
                    _terminalBloc.clearProcess();
                  },
                  child: Icon(Icons.clear),
                )
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.black),
            constraints: const BoxConstraints(maxHeight: 400, minHeight: 0),
            child: ListView.builder(
                primary: true,
                itemCount: process.length,
                itemBuilder: (_, i) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      process[i],
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  registerFb() async {
    var d = DateTime.now();
    _terminalBloc.clearProcess();

    _terminalBloc.addProcess("appium start");
    AppiumWebDriver driver = await createDriver(
      uri: Uri.parse('http://127.0.0.1:4723'),
      desired: {
        'platformName': 'Android',
        'automationName': 'Uiautomator2',
        'autoGrantPermissions': true,
        'skipDeviceInitialization': true,
        'skipServerInstallation': true,
        'ignoreUnimportantViews': true,
        'noReset': true,
        'fullReset': false,
        'elementTimeout': 5000, // 5 seconds
        'fullContextList': true,
        'relaxedSecurity': true,
      },
      spec: WebDriverSpec.Auto,
    );
    _terminalBloc.addProcess("appium successfully");

    try {
      _terminalBloc.addProcess("open com.facebook.katana");
      await driver.device.startActivity(
          appPackage: 'com.facebook.katana',
          appActivity: 'com.facebook.katana.LoginActivity');

      // bool isLoaded =
      //     (await driver.device.getCurrentPackage()) == 'com.facebook.katana';
      // do {
      //   await delay(10);
      //   isLoaded =
      //       (await driver.device.getCurrentPackage()) == 'com.facebook.katana';
      // } while (!isLoaded);
      await delay(5);
      _terminalBloc.addProcess("find Create new account");
      var createNewAccountBtn = await driver.findElement(AppiumBy.xpath(
          '//android.widget.Button[@content-desc="Create new account"]'));
      if ((await createNewAccountBtn.enabled)) {
        _terminalBloc.addProcess("click Create new account");
        await createNewAccountBtn.click();
      }

      await delay(5);
      _terminalBloc.addProcess("find Get started");
      var getStartedBtn = await driver.findElement(AppiumBy.xpath(
          '//android.widget.Button[@content-desc="Get started"]'));
      if ((await getStartedBtn.enabled)) {
        _terminalBloc.addProcess("click Get started");
        await getStartedBtn.click();
      }

      await delay(5);
      _terminalBloc.addProcess("find First name and Last name");
      var flInputs = await (driver
              .findElements(AppiumBy.className('android.widget.EditText')))
          .toList();

      if (flInputs.isNotEmpty) {
        var firstNameInput = flInputs.first;
        var lastNameInput = flInputs.last;
        if ((await firstNameInput.enabled)) {
          _terminalBloc.addProcess("send key First name");
          await firstNameInput.click();
          driver.keyboard.sendChord("Ke".split(""));
        }
        if ((await lastNameInput.enabled)) {
          _terminalBloc.addProcess("send key Last name");
          await lastNameInput.click();
          driver.keyboard.sendChord("Chankrisna".split(""));
        }
      }

      await delay(5);
      _terminalBloc.addProcess("find Next");
      var nextBtn = await driver.findElement(
          AppiumBy.xpath('//android.widget.Button[@content-desc="Next"]'));
      if ((await nextBtn.enabled)) {
        _terminalBloc.addProcess("click Next");
        await nextBtn.click();
      }

      await delay(5);
      _terminalBloc.addProcess("find dob input");
      var dobInputs = await (driver.findElements(AppiumBy.xpath(
              '//android.widget.EditText[@resource-id="android:id/numberpicker_input"]')))
          .toList();

      if (dobInputs.isNotEmpty) {
        var monthInput = dobInputs[0];
        var dayInput = dobInputs[1];
        var yearInput = dobInputs[2];
        if ((await monthInput.enabled)) {
          _terminalBloc.addProcess("send key month");
          await monthInput.click();
          dayInput.setImmediateValue("Jul");
        }
        if ((await dayInput.enabled)) {
          _terminalBloc.addProcess("send key day");
          await dayInput.click();
          
          
        }
        if ((await yearInput.enabled)) {
          _terminalBloc.addProcess("send key year");
          await yearInput.click();
          dayInput.setImmediateValue("1990");
        }
      }

      await delay(5);
      _terminalBloc.addProcess("find SET");
      var setBtn = await driver
          .findElement(AppiumBy.xpath('//android.widget.Button[@text="SET"]'));
      if ((await setBtn.enabled)) {
        _terminalBloc.addProcess("click SET");
        await setBtn.click();
      }

      await delay(5);
      _terminalBloc.addProcess("click next");
      nextBtn.click();

      await delay(5);
       _terminalBloc.addProcess("find Female");
      var femaleOption = await driver.findElement(
          AppiumBy.xpath('//android.widget.Button[@content-desc="Female"]'));
      var maleOption = await driver.findElement(
          AppiumBy.xpath('//android.widget.Button[@content-desc="Male"]'));
      femaleOption.click();

      await delay(5);
      _terminalBloc.addProcess("click next");
      nextBtn.click();

      await delay(5);
      _terminalBloc.addProcess("find Sign up with email");
      var signUpWidthEmailBtn = await driver.findElement(AppiumBy.xpath(
          '//android.widget.Button[@content-desc="Sign up with email"]'));
      if ((await signUpWidthEmailBtn.enabled)) {
        _terminalBloc.addProcess("click Sign up with email");
        await signUpWidthEmailBtn.click();
      }

      await delay(5);
      _terminalBloc.addProcess("find Email");
      var emailInput = await driver.findElement(AppiumBy.xpath(
          '//android.view.View[@content-desc="Email"]'));
      if ((await emailInput.enabled)) {
        _terminalBloc.addProcess("click Email");
        await emailInput.click();
        await emailInput.sendKeys("xnxhhs_${d.millisecond}@rando.com");
      }

      await delay(5);
      _terminalBloc.addProcess("click next");
      nextBtn.click();

      await delay(5);
      _terminalBloc.addProcess("find Password");
      var passwordInput = await driver.findElement(AppiumBy.xpath(
          '//android.view.View[@content-desc="Password"]'));
      if ((await passwordInput.enabled)) {
        _terminalBloc.addProcess("click Password");
        await passwordInput.click();
        await passwordInput.sendKeys("Random@8888#");
      }

      await delay(5);
      _terminalBloc.addProcess("click next");
      nextBtn.click();

      await delay(5);
      _terminalBloc.addProcess("find Save");
      var saveBtn = await driver
          .findElement(AppiumBy.xpath('//android.widget.Button[@content-desc="Save"]'));
      if ((await saveBtn.enabled)) {
        _terminalBloc.addProcess("click Save");
        await saveBtn.click();
      }

      await delay(5);
      _terminalBloc.addProcess("find I agree");
      var iAgreeeBtn = await driver
          .findElement(AppiumBy.xpath('//android.widget.Button[@content-desc="I agree"]'));
      if ((await iAgreeeBtn.enabled)) {
        _terminalBloc.addProcess("click I agree");
        await iAgreeeBtn.click();
      }

      await delay(30);

      // Close all applications
      await driver.execute('mobile: shell', [
        {
          'command': 'am force-stop',
          'args': ['--user', 'current', 'com.facebook.katana'],
        }
      ]);
      await driver.quit();
      _terminalBloc.addProcess("appium quit");
    } catch (e) {
      // Close all applications
      await driver.execute('mobile: shell', [
        {
          'command': 'am force-stop',
          'args': ['--user', 'current', 'com.facebook.katana'],
        }
      ]);

      driver.quit();
      _terminalBloc.addProcess("appium fail" + e.toString());
      // L.e(e);
    }
  }
}

class TerminalBloc {
  final _processStreamController = StreamController<List<String>>();
  Stream<List<String>> get processStream => _processStreamController.stream;

  List<String> _processValue = [];
  List<String> get processValue => _processValue;

  void addProcess(String value) {
    var d = DateFormat.MEd().add_jms().format(DateTime.now());
    _processValue = [...processValue, "[$d]: ${value}"];
    _processStreamController.sink.add(_processValue);
  }

  void removeProcess(String value) {
    _processValue.remove(value);
    _processStreamController.sink.add(_processValue);
  }

  void clearProcess() {
    _processValue.clear();
    _processStreamController.sink.add(_processValue);
  }

  void dispose() {
    _processStreamController.close();
  }
}
