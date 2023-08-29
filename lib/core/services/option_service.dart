class DropdownOptions {
  static List<String> conditionOptions = [
    'Neu, mit Etikett',
    'Neu',
    'Sehr gut',
    'Gut',
    'Zufriedenstellend'
  ];

  static List<String> typeOptions = ['Kids', 'Adults', 'Universal'];

  static Map<String, List<String>> sizeOptions = {
    'Adults': ['S', 'M', 'L', 'XL', 'XXL', '3XL', 'Einheitsgröße'],
    'Kids': [
      '128',
      '134',
      '140',
      '146',
      '152',
      '158',
      '164',
      '170',
      '176',
      'Einheitsgröße'
    ],
    'Universal': ['Einheitsgröße'],
  };

  static List<String> popularBrandOptions = ['Adidas', 'Puma', 'Nike'];
  static List<String> lessPopularBrandOptions = [
    'Keine Auswahl',
    'Asics',
    'Brooks',
    'Capelli',
    'Castore',
    'Columbia',
    'Converse',
    'Craft',
    'Diadora',
    'Fila',
    'Hummel',
    'Jako',
    'Joma',
    'Kappa',
    'K-Swiss',
    'Macron',
    'Merrell',
    'Mizuno',
    'New Balance',
    'Oakley',
    'Reebok',
    'Saller',
    'Salomon',
    'Skechers',
    'The North Face',
    'Uhlsport',
    'Umbro',
    'Under Armour',
    'Wilson'
  ];

  static List<String> clubOptions = [
    'Keine Auswahl',
    'SGV Nürnberg Fürth',
    'SG Quelle',
    'SC 04 Schwabach',
    'Post SV Nürnberg',
    'ATSV Erlangen',
    'SpVgg Mögeldorf 2000',
    'ATV 1873 Frankonia',
    'FSV Erlangen Bruck',
    'SpVgg Ansbach',
    'TSV Weißenburg',
    'DJK Don Bosco Bamberg',
    'FC Eintracht Bamberg'
  ];

  static List<String> sportOptions = [
    'Keine Auswahl',
    'Fußball',
    'Tennis',
    'Leichtathletik',
    'Handball',
    'Basketball',
    'Volleyball',
    'Eishockey',
    'Tischtennis',
    'Badminton',
    'Reitsport',
    'Schwimmen',
    'Radsport',
    'Golf',
    'Rugby',
    'Boxen',
    'Wassersport',
    'Fechten',
    'Turnen',
    'Rudern',
    'Judo',
    'Ski',
    'Klettern',
    'Billard',
    'Bowling',
  ];
}

List<String> conditions = DropdownOptions.conditionOptions;
List<String> types = DropdownOptions.typeOptions;
Map<String, List<String>> sizes = DropdownOptions.sizeOptions;
List<String> popularBrands = DropdownOptions.popularBrandOptions;
List<String> lesspopularBrands = DropdownOptions.lessPopularBrandOptions;
List<String> club = DropdownOptions.clubOptions;
List<String> sport = DropdownOptions.sportOptions;
