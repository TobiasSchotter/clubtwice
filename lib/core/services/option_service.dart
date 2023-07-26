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
    'Adults': ['S', 'M', 'L', 'XL', 'XXL', '3XL'],
    'Kids': ['128', '134', '140', '146', '152', '158', '164', '170', '176'],
    'Universal': ['Einheitsgröße'],
  };

  static List<String> popularBrandOptions = ['Adidas', 'Puma', 'Nike'];
  static List<String> lessPopularBrandOptions = [
    'Asics',
    'Capelli',
    'Castore',
    'Craft',
    'Fila',
    'Hummel',
    'Jako',
    'Joma',
    'Kappa',
    'Macron',
    'Mizuno',
    'Reebok',
    'Saller',
    'Umbro',
    'Uhlsport'
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
    'Keine Auswahl'
  ];
}

List<String> conditions = DropdownOptions.conditionOptions;
List<String> types = DropdownOptions.typeOptions;
Map<String, List<String>> sizes = DropdownOptions.sizeOptions;
List<String> popularBrands = DropdownOptions.popularBrandOptions;
List<String> lesspopularBrands = DropdownOptions.lessPopularBrandOptions;
List<String> club = DropdownOptions.clubOptions;
List<String> sport = DropdownOptions.sportOptions;
