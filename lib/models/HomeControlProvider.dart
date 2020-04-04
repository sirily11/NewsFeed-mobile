import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSelections {
  String name;
  TextTheme font;

  FontSelections({@required this.name, this.font});
}

class HomeControlProvider with ChangeNotifier {
  bool _enableDarkmode = true;
  bool _enableImage = true;
  int _currentIndex = 1;
  Color _primaryColor;
  Color _tagColor;
  FontSelections _fontSelections;
  final List<FontSelections> avaliableFonts = [
    FontSelections(
      name: "Roboto",
      font: GoogleFonts.robotoTextTheme(),
    ),
    FontSelections(
      name: "Poppins",
      font: GoogleFonts.poppinsTextTheme(),
    ),
    FontSelections(
      name: "Noto Sans SC",
      font: GoogleFonts.notoSansTextTheme(),
    ),
    FontSelections(
      name: "ZCool XiaoWei",
      font: GoogleFonts.zCOOLXiaoWeiTextTheme(),
    ),
    FontSelections(
      name: "Ma Shan Zheng",
      font: GoogleFonts.maShanZhengTextTheme(),
    ),
    FontSelections(
      name: "ZCool QingKe HuangYou",
      font: GoogleFonts.zCOOLQingKeHuangYouTextTheme(),
    ),
    FontSelections(
      name: "ZCool XiaoWei",
      font: GoogleFonts.zCOOLKuaiLeTextTheme(),
    )
  ];

  HomeControlProvider() {
    SharedPreferences.getInstance().then((prefs) {
      String selectionFontStr = prefs.getString("font");
      _enableDarkmode = prefs.getBool("enable_darkmode") ?? true;
      _enableImage = prefs.getBool("enable_image") ?? true;
      _primaryColor = Color(prefs.getInt("primary_color")).withAlpha(255);
      _tagColor = Color(prefs.getInt("tag_color")).withAlpha(255);
      _fontSelections = avaliableFonts
          .firstWhere((e) => e.name == selectionFontStr, orElse: () => null);
      notifyListeners();
    });
  }

  FontSelections get fontSelections => this._fontSelections;

  set fontSelections(FontSelections selections) {
    this._fontSelections = selections;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("font", selections.name);
    });
    notifyListeners();
  }

  int get currentIndex => this._currentIndex;

  set currentIndex(int index) {
    this._currentIndex = index;
    notifyListeners();
  }

  bool get enableDarkmode => _enableDarkmode;

  set enableDarkmode(bool val) {
    _enableDarkmode = val;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("enable_darkmode", val);
    });
    notifyListeners();
  }

  bool get enableImage => _enableImage;

  set enableImage(bool val) {
    _enableImage = val;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("enable_image", val);
    });
    notifyListeners();
  }

  Color get primaryColor => _primaryColor;

  set primaryColor(Color color) {
    this._primaryColor = color.withAlpha(255);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("primary_color", color.value);
    });
    notifyListeners();
  }

  Color get tagColor => _tagColor;

  set tagColor(Color color) {
    this._tagColor = color.withAlpha(255);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("tag_color", color.value);
    });
    notifyListeners();
  }
}
