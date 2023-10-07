class DropdownOptions {
  static List<String> conditionOptions = [
    'Neu, mit Etikett',
    'Neu',
    'Sehr gut',
    'Gut',
    'Zufriedenstellend'
  ];

  static List<String> typeOptions = ['Kids', 'Adults', 'Universal'];

  static Map<String, List<String>> sizeOptionsCloth = {
    'Adults': ['XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', 'Einheitsgröße'],
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

  static Map<String, List<String>> sizeOptionsShoe = {
    'Adults': [
      'EU 36',
      'EU 36 2/3',
      'EU 37 1/3',
      'EU 38',
      'EU 38 2/3',
      'EU 39 1/3',
      'EU 40',
      'EU 40 2/3',
      'EU 41 1/3',
      'EU 42',
      'EU 42 2/3',
      'EU 43 1/3',
      'EU 44',
      'EU 44 2/3',
      'EU 45 1/3',
      'EU 46',
      'EU 46 2/3',
      'EU 47 1/3',
      'EU 48',
      'EU 48 2/3',
      'Einheitsgröße'
    ],
    'Kids': [
      'EU 28',
      'EU 28 1/2',
      'EU 29',
      'EU 30',
      'EU 30 1/2',
      'EU 31',
      'EU 31 1/2',
      'EU 32',
      'EU 33',
      'EU 33 1/2',
      'EU 34',
      'EU 35',
      'EU 35 1/2',
      'EU 36',
      'EU 36 2/3',
      'EU 37 1/3',
      'EU 38',
      'EU 38 2/3',
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
Map<String, List<String>> sizesCloth = DropdownOptions.sizeOptionsCloth;
Map<String, List<String>> sizesShoe = DropdownOptions.sizeOptionsShoe;
List<String> popularBrands = DropdownOptions.popularBrandOptions;
List<String> lesspopularBrands = DropdownOptions.lessPopularBrandOptions;
List<String> club = DropdownOptions.clubOptions;
List<String> sport = DropdownOptions.sportOptions;
