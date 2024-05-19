class Messages {
  Messages._();

  static String get fetchError => 'Ocorreu um erro ao recuperar os dados.';
  static String get saveError => 'Ocorreu um erro ao salvar os dados.';
  static String get updateError => 'Ocorreu um erro ao atualizar os dados.';
  static String get deleteError => 'Ocorreu um erro ao excluir os dados.';
  static String get missingId => 'O parâmetro id está ausente na URL.';
  static String get missingParentId => 'O parâmetro id do pai está ausente na URL.';
  static String get missingStartDate => 'O parâmetro startdate está ausente na URL.';
  static String get missingEndDate => 'O parâmetro enddate está ausente na URL.';
  static String get badDate => 'Formato de data inválido na URL.';
  static String get recordNotFound => 'Dados não encontrados.';
  static String get saveSuccess => 'Dados criados com sucesso.';
  static String get updateSuccess => 'Dados atualizados com sucesso.';
  static String get deleteSuccess => 'Dados excluídos com sucesso.';
  static String get dataNotFound => 'Dados não encontrados.';
}
