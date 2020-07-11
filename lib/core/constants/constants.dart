import 'package:flutter/material.dart';

enum MAP_VIZS {
  CHOROPLETH,
  BUBBLES,
}

enum MAP_VIEWS {
  STATES,
  DISTRICTS,
}

enum MAP_TYPES {
  COUNTRY,
  STATE,
}

const List<String> PRIMARY_STATISTICS = <String>[
  'confirmed',
  'active',
  'recovered',
  'deceased',
];

const List<String> TABLE_STATISTICS = [...PRIMARY_STATISTICS, 'tested'];

const List<String> MAP_STATISTICS = [...PRIMARY_STATISTICS, 'tested'];

const List<String> TIME_SERIES_STATISTICS = [...PRIMARY_STATISTICS, 'tested'];

const int MINIGRAPH_LOOKBACK_DAYS = 20;

const int CACHE_TIMEOUT_IN_MINUTES = 15;

const int DISTRICT_TABLE_COUNT = 30;

const Map<String, Color> STATS_COLOR = {
  'confirmed': Colors.red,
  'active': Colors.blue,
  'recovered': Colors.green,
  'deceased': Colors.grey,
  'tested': Colors.purple,
  'migrated': Colors.yellow,
};

const Map<String, List<Color>> STATS_GRADIENT_COLOR = {
  'confirmed': <Color>[Color(0xFFEF9A9A), Color(0xFFB71C1C)],
  'active': <Color>[Color(0xFF90CAF9), Color(0xFF0D47A1)],
  'recovered': <Color>[Color(0xFFA5D6A7), Color(0xFF1B5E20)],
  'deceased': <Color>[Color(0xFFEEEEEE), Color(0xFF212121)],
  'tested': <Color>[Color(0xFFCE93D8), Color(0xFF4A148C)],
  'migrated': <Color>[Color(0xFFFFF59D), Color(0xFFF57F17)],
};

const Map<String, Color> STATS_HIGHLIGHT_COLOR = {
  'confirmed': Colors.redAccent,
  'active': Colors.blueAccent,
  'recovered': Colors.greenAccent,
  'deceased': Colors.blueGrey,
  'tested': Colors.purpleAccent,
  'migrated': Colors.orangeAccent,
};

const Map<String, String> TIME_SERIES_CHART_TYPES = {
  'total': 'Cumulative',
  'delta': 'Daily',
};

const Map<String, String> TIME_SERIES_OPTIONS = {
  'BEGINNING': 'Beginning',
  'MONTH': '1 Month',
  'TWO_WEEKS': '2 Weeks',
};

const UNASSIGNED_STATE_CODE = 'UN';

const UNKNOWN_DISTRICT_KEY = 'Unknown';

const Map<String, dynamic> MAP_META = {
  'AP': {
    'name': 'Andhra Pradesh',
    'map_type': MAP_TYPES.STATE,
  },
  'AR': {
    'name': 'Arunachal Pradesh',
    'map_type': MAP_TYPES.STATE,
  },
  'AS': {
    'name': 'Assam',
    'map_type': MAP_TYPES.STATE,
  },
  'BR': {
    'name': 'Bihar',
    'map_type': MAP_TYPES.STATE,
  },
  'CT': {
    'name': 'Chhattisgarh',
    'map_type': MAP_TYPES.STATE,
  },
  'GA': {
    'name': 'Goa',
    'map_type': MAP_TYPES.STATE,
  },
  'GJ': {
    'name': 'Gujarat',
    'map_type': MAP_TYPES.STATE,
  },
  'HR': {
    'name': 'Haryana',
    'map_type': MAP_TYPES.STATE,
  },
  'HP': {
    'name': 'Himachal Pradesh',
    'map_type': MAP_TYPES.STATE,
  },
  'JK': {
    'name': 'Jammu and Kashmir',
    'map_type': MAP_TYPES.STATE,
  },
  'JH': {
    'name': 'Jharkhand',
    'map_type': MAP_TYPES.STATE,
  },
  'KA': {
    'name': 'Karnataka',
    'map_type': MAP_TYPES.STATE,
  },
  'KL': {
    'name': 'Kerala',
    'map_type': MAP_TYPES.STATE,
  },
  'MP': {
    'name': 'Madhya Pradesh',
    'map_type': MAP_TYPES.STATE,
  },
  'MH': {
    'name': 'Maharashtra',
    'map_type': MAP_TYPES.STATE,
  },
  'MN': {
    'name': 'Manipur',
    'map_type': MAP_TYPES.STATE,
  },
  'ML': {
    'name': 'Meghalaya',
    'map_type': MAP_TYPES.STATE,
  },
  'MZ': {
    'name': 'Mizoram',
    'map_type': MAP_TYPES.STATE,
  },
  'NL': {
    'name': 'Nagaland',
    'map_type': MAP_TYPES.STATE,
  },
  'OR': {
    'name': 'Odisha',
    'map_type': MAP_TYPES.STATE,
  },
  'PB': {
    'name': 'Punjab',
    'map_type': MAP_TYPES.STATE,
  },
  'RJ': {
    'name': 'Rajasthan',
    'map_type': MAP_TYPES.STATE,
  },
  'SK': {
    'name': 'Sikkim',
    'map_type': MAP_TYPES.STATE,
  },
  'TN': {
    'name': 'Tamil Nadu',
    'map_type': MAP_TYPES.STATE,
  },
  'TG': {
    'name': 'Telangana',
    'map_type': MAP_TYPES.STATE,
  },
  'TR': {
    'name': 'Tripura',
    'map_type': MAP_TYPES.STATE,
  },
  'UT': {
    'name': 'Uttarakhand',
    'map_type': MAP_TYPES.STATE,
  },
  'UP': {
    'name': 'Uttar Pradesh',
    'map_type': MAP_TYPES.STATE,
  },
  'WB': {
    'name': 'West Bengal',
    'map_type': MAP_TYPES.STATE,
  },
  'AN': {
    'name': 'Andaman and Nicobar Islands',
    'map_type': MAP_TYPES.STATE,
  },
  'CH': {
    'name': 'Chandigarh',
    'map_type': MAP_TYPES.STATE,
  },
  'DN': {
    'name': 'Dadra and Nagar Haveli and Daman and Diu',
    'map_type': MAP_TYPES.STATE,
  },
  'DL': {
    'name': 'Delhi',
    'map_type': MAP_TYPES.STATE,
  },
  'LA': {
    'name': 'Ladakh',
    'map_type': MAP_TYPES.STATE,
  },
  'LD': {
    'name': 'Lakshadweep',
    'map_type': MAP_TYPES.STATE,
  },
  'PY': {
    'name': 'Puducherry',
    'map_type': MAP_TYPES.STATE,
  },
  'TT': {
    'name': 'India',
    'map_type': MAP_TYPES.COUNTRY,
  },
};

const List<String> STATE_CODES = [
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

const Map<String, String> STATE_CODE_MAP = {
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

const Map<String, List<String>> STATE_DISTRICT_MAP = {
  'DN': ['Dadra and Nagar Haveli', 'Daman', 'Diu'],
  'DL': [
    'North Delhi',
    'New Delhi',
    'East Delhi',
    'North West Delhi',
    'West Delhi',
    'South Delhi',
    'Central Delhi',
    'Shahdara',
    'South West Delhi',
    'South East Delhi',
    'North East Delhi'
  ],
  'WB': [
    'Hooghly',
    'Purba Medinipur',
    'South 24 Parganas',
    'Nadia',
    'Kolkata',
    'Dakshin Dinajpur',
    'Purulia',
    'Howrah',
    'Alipurduar',
    'Paschim Medinipur',
    'Paschim Bardhaman',
    'Jalpaiguri',
    'Uttar Dinajpur',
    'Jhargram',
    'Kalimpong',
    'Bankura',
    'Purba Bardhaman',
    'Birbhum',
    'North 24 Parganas',
    'Darjeeling',
    'Cooch Behar',
    'Malda',
    'Murshidabad'
  ],
  'HR': [
    'Jind',
    'Jhajjar',
    'Rohtak',
    'Mahendragarh',
    'Ambala',
    'Kaithal',
    'Faridabad',
    'Karnal',
    'Kurukshetra',
    'Palwal',
    'Hisar',
    'Panchkula',
    'Gurugram',
    'Charkhi Dadri',
    'Panipat',
    'Fatehabad',
    'Rewari',
    'Bhiwani',
    'Nuh',
    'Sirsa',
    'Yamunanagar',
    'Sonipat'
  ],
  'HP': [
    'Hamirpur',
    'Kullu',
    'Lahaul and Spiti',
    'Shimla',
    'Solan',
    'Chamba',
    'Una',
    'Bilaspur',
    'Kangra',
    'Kinnaur',
    'Mandi',
    'Sirmaur'
  ],
  'MH': [
    'Satara',
    'Mumbai Suburban',
    'Beed',
    'Solapur',
    'Washim',
    'Thane',
    'Sindhudurg',
    'Wardha',
    'Dhule',
    'Buldhana',
    'Mumbai',
    'Chandrapur',
    'Amravati',
    'Aurangabad',
    'Raigad',
    'Hingoli',
    'Ratnagiri',
    'Jalgaon',
    'Pune',
    'Nandurbar',
    'Gadchiroli',
    'Nagpur',
    'Ahmednagar',
    'Sangli',
    'Nanded',
    'Kolhapur',
    'Bhandara',
    'Akola',
    'Osmanabad',
    'Gondia',
    'Parbhani',
    'Palghar',
    'Jalna',
    'Nashik',
    'Yavatmal',
    'Latur'
  ],
  'JH': [
    'Pakur',
    'Ranchi',
    'Godda',
    'Chatra',
    'Simdega',
    'Khunti',
    'Bokaro',
    'Deoghar',
    'West Singhbhum',
    'Jamtara',
    'East Singhbhum',
    'Ramgarh',
    'Sahibganj',
    'Gumla',
    'Saraikela-Kharsawan',
    'Dumka',
    'Garhwa',
    'Latehar',
    'Giridih',
    'Hazaribagh',
    'Lohardaga',
    'Koderma',
    'Palamu',
    'Dhanbad'
  ],
  'BR': [
    'Saran',
    'Samastipur',
    'Munger',
    'Lakhisarai',
    'Gopalganj',
    'Patna',
    'Rohtas',
    'Madhepura',
    'Jehanabad',
    'Muzaffarpur',
    'Sheohar',
    'Araria',
    'Aurangabad',
    'Buxar',
    'West Champaran',
    'East Champaran',
    'Katihar',
    'Sheikhpura',
    'Gaya',
    'Nawada',
    'Purnia',
    'Madhubani',
    'Saharsa',
    'Begusarai',
    'Supaul',
    'Banka',
    'Arwal',
    'Sitamarhi',
    'Kaimur',
    'Darbhanga',
    'Nalanda',
    'Vaishali',
    'Khagaria',
    'Jamui',
    'Bhojpur',
    'Bhagalpur',
    'Kishanganj',
    'Siwan'
  ],
  'JK': [
    'Samba',
    'Kulgam',
    'Kupwara',
    'Anantnag',
    'Reasi',
    'Muzaffarabad',
    'Mirpur',
    'Jammu',
    'Punch',
    'Shopiyan',
    'Srinagar',
    'Ganderbal',
    'Doda',
    'Bandipora',
    'Baramulla',
    'Rajouri',
    'Udhampur',
    'Budgam',
    'Kathua',
    'Ramban',
    'Pulwama',
    'Kishtwar'
  ],
  'PB': [
    'Sangrur',
    'Sri Muktsar Sahib',
    'Amritsar',
    'Jalandhar',
    'Moga',
    'Bathinda',
    'Ludhiana',
    'Ferozepur',
    'Gurdaspur',
    'Barnala',
    'Rupnagar',
    'Faridkot',
    'Fatehgarh Sahib',
    'Hoshiarpur',
    'Pathankot',
    'Patiala',
    'Fazilka',
    'Mansa',
    'Shahid Bhagat Singh Nagar',
    'Kapurthala',
    'Tarn Taran',
    'S.A.S. Nagar'
  ],
  'LD': ['Lakshadweep'],
  'NL': [
    'Wokha',
    'Kohima',
    'Phek',
    'Kiphire',
    'Longleng',
    'Peren',
    'Tuensang',
    'Mon',
    'Zunheboto',
    'Dimapur',
    'Mokokchung'
  ],
  'LA': ['Leh', 'Kargil'],
  'PY': ['Karaikal', 'Puducherry', 'Yanam', 'Mahe'],
  'TR': [
    'West Tripura',
    'South Tripura',
    'Unokoti',
    'Gomati',
    'North Tripura',
    'Khowai',
    'Sipahijala',
    'Dhalai'
  ],
  'TN': [
    'Tiruppur',
    'Ranipet',
    'Ramanathapuram',
    'Krishnagiri',
    'Karur',
    'Coimbatore',
    'Chennai',
    'Erode',
    'Nilgiris',
    'Chengalpattu',
    'Viluppuram',
    'Tiruvannamalai',
    'Nagapattinam',
    'Tenkasi',
    'Namakkal',
    'Theni',
    'Kanyakumari',
    'Dharmapuri',
    'Thoothukkudi',
    'Perambalur',
    'Tirupathur',
    'Cuddalore',
    'Vellore',
    'Kancheepuram',
    'Thiruvallur',
    'Ariyalur',
    'Dindigul',
    'Madurai',
    'Tirunelveli',
    'Sivaganga',
    'Pudukkottai',
    'Thiruvarur',
    'Tiruchirappalli',
    'Virudhunagar',
    'Salem',
    'Thanjavur',
    'Kallakurichi'
  ],
  'TG': [
    'Sangareddy',
    'Khammam',
    'Nalgonda',
    'Nagarkurnool',
    'Yadadri Bhuvanagiri',
    'Warangal Urban',
    'Jayashankar Bhupalapally',
    'Komaram Bheem',
    'Siddipet',
    'Mahabubnagar',
    'Medchal Malkajgiri',
    'Mulugu',
    'Adilabad',
    'Jangaon',
    'Nirmal',
    'Jagtial',
    'Bhadradri Kothagudem',
    'Narayanpet',
    'Medak',
    'Peddapalli',
    'Kamareddy',
    'Rajanna Sircilla',
    'Wanaparthy',
    'Jogulamba Gadwal',
    'Karimnagar',
    'Suryapet',
    'Vikarabad',
    'Hyderabad',
    'Mahabubabad',
    'Nizamabad',
    'Warangal Rural',
    'Ranga Reddy',
    'Mancherial'
  ],
  'RJ': [
    'Jaipur',
    'Dausa',
    'Dholpur',
    'Jalore',
    'Bhilwara',
    'Barmer',
    'Jaisalmer',
    'Sirohi',
    'Dungarpur',
    'Udaipur',
    'Alwar',
    'Rajsamand',
    'Pali',
    'Jodhpur',
    'Sikar',
    'Pratapgarh',
    'Ganganagar',
    'Bundi',
    'Nagaur',
    'Jhunjhunu',
    'Baran',
    'Karauli',
    'Chittorgarh',
    'Kota',
    'Ajmer',
    'Bikaner',
    'Jhalawar',
    'Banswara',
    'Churu',
    'Tonk',
    'Hanumangarh',
    'Bharatpur',
    'Sawai Madhopur'
  ],
  'CH': ['Chandigarh'],
  'AN': ['North and Middle Andaman', 'South Andaman', 'Nicobars'],
  'AP': [
    'Krishna',
    'Y.S.R. Kadapa',
    'West Godavari',
    'Kurnool',
    'S.P.S. Nellore',
    'Chittoor',
    'East Godavari',
    'Prakasam',
    'Vizianagaram',
    'Visakhapatnam',
    'Guntur',
    'Srikakulam',
    'Anantapur'
  ],
  'AS': [
    'Nalbari',
    'Dhemaji',
    'Morigaon',
    'Nagaon',
    'Sonitpur',
    'Majuli',
    'Baksa',
    'Kokrajhar',
    'Dibrugarh',
    'Kamrup Metropolitan',
    'Kamrup',
    'Jorhat',
    'Darrang',
    'Tinsukia',
    'Dhubri',
    'Charaideo',
    'Biswanath',
    'Hojai',
    'Golaghat',
    'Chirang',
    'Sivasagar',
    'Barpeta',
    'Karbi Anglong',
    'Karimganj',
    'West Karbi Anglong',
    'Hailakandi',
    'Udalguri',
    'Goalpara',
    'Cachar',
    'Bongaigaon',
    'Dima Hasao',
    'South Salmara Mankachar',
    'Lakhimpur'
  ],
  'AR': [
    'Namsai',
    'Changlang',
    'Kra Daadi',
    'Longding',
    'Kamle',
    'Upper Dibang Valley',
    'Kurung Kumey',
    'Anjaw',
    'East Siang',
    'Pakke Kessang',
    'Lower Subansiri',
    'Upper Subansiri',
    'Upper Siang',
    'Lower Dibang Valley',
    'Lepa Rada',
    'Lower Siang',
    'West Kameng',
    'Papum Pare',
    'Tawang',
    'Tirap',
    'East Kameng',
    'Lohit',
    'Shi Yomi',
    'Siang',
    'West Siang'
  ],
  'GA': ['South Goa', 'North Goa'],
  'GJ': [
    'Devbhumi Dwarka',
    'Botad',
    'Bhavnagar',
    'Vadodara',
    'Dang',
    'Jamnagar',
    'Junagadh',
    'Tapi',
    'Navsari',
    'Rajkot',
    'Dahod',
    'Gir Somnath',
    'Porbandar',
    'Panchmahal',
    'Morbi',
    'Ahmedabad',
    'Kheda',
    'Banaskantha',
    'Aravalli',
    'Mahisagar',
    'Amreli',
    'Surat',
    'Bharuch',
    'Sabarkantha',
    'Kutch',
    'Valsad',
    'Surendranagar',
    'Chhota Udaipur',
    'Anand',
    'Mehsana',
    'Patan',
    'Gandhinagar',
    'Narmada'
  ],
  'CT': [
    'Mahasamund',
    'Dakshin Bastar Dantewada',
    'Bastar',
    'Narayanpur',
    'Raigarh',
    'Rajnandgaon',
    'Korba',
    'Gariaband',
    'Bametara',
    'Baloda Bazar',
    'Dhamtari',
    'Jashpur',
    'Janjgir Champa',
    'Kabeerdham',
    'Bijapur',
    'Surguja',
    'Balod',
    'Balrampur',
    'Bilaspur',
    'Raipur',
    'Surajpur',
    'Sukma',
    'Kondagaon',
    'Durg',
    'Koriya',
    'Mungeli',
    'Uttar Bastar Kanker'
  ],
  'KA': [
    'Haveri',
    'Yadgir',
    'Kalaburagi',
    'Raichur',
    'Kodagu',
    'Bengaluru Urban',
    'Chitradurga',
    'Dakshina Kannada',
    'Uttara Kannada',
    'Udupi',
    'Chikkamagaluru',
    'Mandya',
    'Ballari',
    'Dharwad',
    'Ramanagara',
    'Chikkaballapura',
    'Bengaluru Rural',
    'Bagalkote',
    'Hassan',
    'Tumakuru',
    'Shivamogga',
    'Bidar',
    'Koppal',
    'Vijayapura',
    'Davanagere',
    'Belagavi',
    'Kolar',
    'Chamarajanagara',
    'Gadag',
    'Mysuru'
  ],
  'ML': [
    'South West Garo Hills',
    'West Garo Hills',
    'South West Khasi Hills',
    'East Khasi Hills',
    'North Garo Hills',
    'South Garo Hills',
    'West Khasi Hills',
    'East Garo Hills',
    'West Jaintia Hills',
    'East Jaintia Hills',
    'Ribhoi'
  ],
  'MN': [
    'Imphal West',
    'Kamjong',
    'Senapati',
    'Tamenglong',
    'Noney',
    'Imphal East',
    'Kangpokpi',
    'Thoubal',
    'Jiribam',
    'Ukhrul',
    'Chandel',
    'Kakching',
    'Bishnupur',
    'Pherzawl',
    'Churachandpur',
    'Tengnoupal'
  ],
  'UP': [
    'Chitrakoot',
    'Banda',
    'Firozabad',
    'Farrukhabad',
    'Sitapur',
    'Varanasi',
    'Sant Kabir Nagar',
    'Kaushambi',
    'Budaun',
    'Prayagraj',
    'Kasganj',
    'Shrawasti',
    'Pratapgarh',
    'Baghpat',
    'Chandauli',
    'Pilibhit',
    'Bareilly',
    'Kannauj',
    'Etah',
    'Lakhimpur Kheri',
    'Bahraich',
    'Shahjahanpur',
    'Barabanki',
    'Kanpur Dehat',
    'Mau',
    'Maharajganj',
    'Amethi',
    'Lalitpur',
    'Rampur',
    'Mathura',
    'Unnao',
    'Sonbhadra',
    'Basti',
    'Azamgarh',
    'Lucknow',
    'Sultanpur',
    'Auraiya',
    'Hathras',
    'Gonda',
    'Hardoi',
    'Mahoba',
    'Fatehpur',
    'Muzaffarnagar',
    'Bijnor',
    'Mainpuri',
    'Amroha',
    'Balrampur',
    'Moradabad',
    'Meerut',
    'Bhadohi',
    'Rae Bareli',
    'Shamli',
    'Mirzapur',
    'Hapur',
    'Hamirpur',
    'Jalaun',
    'Siddharthnagar',
    'Kushinagar',
    'Saharanpur',
    'Gorakhpur',
    'Jaunpur',
    'Ghaziabad',
    'Ayodhya',
    'Gautam Buddha Nagar',
    'Deoria',
    'Sambhal',
    'Etawah',
    'Ballia',
    'Aligarh',
    'Ambedkar Nagar',
    'Bulandshahr',
    'Kanpur Nagar',
    'Jhansi',
    'Ghazipur',
    'Agra'
  ],
  'KL': [
    'Ernakulam',
    'Palakkad',
    'Malappuram',
    'Kozhikode',
    'Alappuzha',
    'Wayanad',
    'Kottayam',
    'Pathanamthitta',
    'Idukki',
    'Kollam',
    'Thrissur',
    'Thiruvananthapuram',
    'Kasaragod',
    'Kannur'
  ],
  'SK': ['South Sikkim', 'East Sikkim', 'West Sikkim', 'North Sikkim'],
  'MP': [
    'Dindori',
    'Umaria',
    'Sheopur',
    'Vidisha',
    'Khargone',
    'Sehore',
    'Datia',
    'Guna',
    'Sidhi',
    'Dhar',
    'Agar Malwa',
    'Bhopal',
    'Mandsaur',
    'Damoh',
    'Rajgarh',
    'Indore',
    'Satna',
    'Hoshangabad',
    'Jabalpur',
    'Shivpuri',
    'Seoni',
    'Sagar',
    'Bhind',
    'Tikamgarh',
    'Panna',
    'Khandwa',
    'Neemuch',
    'Burhanpur',
    'Katni',
    'Jhabua',
    'Niwari',
    'Gwalior',
    'Rewa',
    'Shajapur',
    'Singrauli',
    'Shahdol',
    'Mandla',
    'Dewas',
    'Morena',
    'Betul',
    'Barwani',
    'Chhatarpur',
    'Chhindwara',
    'Balaghat',
    'Raisen',
    'Harda',
    'Ashoknagar',
    'Anuppur',
    'Ujjain',
    'Narsinghpur',
    'Alirajpur',
    'Ratlam'
  ],
  'UT': [
    'Bageshwar',
    'Rudraprayag',
    'Pithoragarh',
    'Uttarkashi',
    'Haridwar',
    'Dehradun',
    'Udham Singh Nagar',
    'Nainital',
    'Almora',
    'Champawat',
    'Chamoli',
    'Pauri Garhwal',
    'Tehri Garhwal'
  ],
  'OR': [
    'Khordha',
    'Subarnapur',
    'Deogarh',
    'Bhadrak',
    'Koraput',
    'Ganjam',
    'Puri',
    'Dhenkanal',
    'Nabarangapur',
    'Gajapati',
    'Kendrapara',
    'Kendujhar',
    'Rayagada',
    'Mayurbhanj',
    'Malkangiri',
    'Boudh',
    'Jajpur',
    'Cuttack',
    'Balasore',
    'Angul',
    'Nuapada',
    'Nayagarh',
    'Bargarh',
    'Jharsuguda',
    'Balangir',
    'Kalahandi',
    'Jagatsinghpur',
    'Sambalpur',
    'Kandhamal',
    'Sundargarh'
  ],
  'MZ': [
    'Kolasib',
    'Hnahthial',
    'Saiha',
    'Khawzawl',
    'Mamit',
    'Champhai',
    'Lawngtlai',
    'Aizawl',
    'Lunglei',
    'Serchhip'
  ]
};

const List<String> DISTRICT_SUGGESTIONS = [
  'Madurai',
  'Ganjam',
  'Alappuzha',
  'Mumbai',
  'Chennai',
];

const List<String> STATE_SUGGESTIONS = [
  'Andhra Pradesh',
  'Karnataka',
  'Gujarat',
  'West Bengal',
  'Ladakh',
];
