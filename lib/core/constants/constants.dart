import 'package:flutter/material.dart';

enum MapView { STATES, DISTRICTS }

class Constants {
  static const int MINIGRAPH_LOOKBACK_DAYS = 20;

  static const int CACHE_TIMEOUT_IN_MINUTES = 15;

  static const List<String> PRIMARY_STATISTICS = [
    'confirmed',
    'active',
    'recovered',
    'deceased',
  ];

  static const Map<String, Color> STATS_COLOR = {
    'confirmed': Colors.red,
    'active': Colors.blue,
    'recovered': Colors.green,
    'deceased': Colors.grey,
    'tested': Colors.purple,
  };

  static const Map<String, List<Color>> STATS_GRADIENT_COLOR = {
    'confirmed': <Color>[Color(0xFFEF9A9A), Color(0xFFB71C1C)],
    'active': <Color>[Color(0xFF90CAF9), Color(0xFF0D47A1)],
    'recovered': <Color>[Color(0xFFA5D6A7), Color(0xFF1B5E20)],
    'deceased': <Color>[Color(0xFFEEEEEE), Color(0xFF212121)],
    'tested': <Color>[Color(0xFFCE93D8), Color(0xFF4A148C)],
  };

  static const STATE_CODES = [
    'AP',
    'AR',
    'AS',
    'BR',
    'CT',
    'GA',
    'GJ',
    'HR',
    'HP',
    'JH',
    'KA',
    'KL',
    'MP',
    'MH',
    'MN',
    'ML',
    'MZ',
    'NL',
    'OR',
    'PB',
    'RJ',
    'SK',
    'TN',
    'TG',
    'TR',
    'UT',
    'UP',
    'WB',
    'AN',
    'CH',
    'DN',
    'DL',
    'JK',
    'LA',
    'LD',
    'PY'
  ];

  static const STATE_CODE_MAP = {
    'AP': 'Andhra Pradesh',
    'AR': 'Arunachal Pradesh',
    'AS': 'Assam',
    'BR': 'Bihar',
    'CT': 'Chhattisgarh',
    'GA': 'Goa',
    'GJ': 'Gujarat',
    'HR': 'Haryana',
    'HP': 'Himachal Pradesh',
    'JH': 'Jharkhand',
    'KA': 'Karnataka',
    'KL': 'Kerala',
    'MP': 'Madhya Pradesh',
    'MH': 'Maharashtra',
    'MN': 'Manipur',
    'ML': 'Meghalaya',
    'MZ': 'Mizoram',
    'NL': 'Nagaland',
    'OR': 'Odisha',
    'PB': 'Punjab',
    'RJ': 'Rajasthan',
    'SK': 'Sikkim',
    'TN': 'Tamil Nadu',
    'TG': 'Telangana',
    'TR': 'Tripura',
    'UT': 'Uttarakhand',
    'UP': 'Uttar Pradesh',
    'WB': 'West Bengal',
    'AN': 'Andaman and Nicobar Islands',
    'CH': 'Chandigarh',
    'DN': 'Dadra and Nagar Haveli and Daman and Diu',
    'DL': 'Delhi',
    'JK': 'Jammu and Kashmir',
    'LA': 'Ladakh',
    'LD': 'Lakshadweep',
    'PY': 'Puducherry',
    'TT': 'India',
    'UN': 'Unassigned'
  };
}
