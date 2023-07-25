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
    'SG Quelle'
  ];

  static List<String> sportOptions = [
    'Keine Auswahl',
    'Fußball',
    'Basketball',
    'Leichtahtletik',
    'Tennis'
  ];
}

List<String> conditions = DropdownOptions.conditionOptions;
List<String> types = DropdownOptions.typeOptions;
Map<String, List<String>> sizes = DropdownOptions.sizeOptions;
List<String> popularBrands = DropdownOptions.popularBrandOptions;
List<String> lesspopularBrands = DropdownOptions.lessPopularBrandOptions;
List<String> club = DropdownOptions.clubOptions;
List<String> sport = DropdownOptions.sportOptions;
