String asCsv<T extends Enum>(List<T> fields) {
  List<String> output = [];
  fields.map((field) => field.name).forEach(output.add);
  return output.join(',');
}
