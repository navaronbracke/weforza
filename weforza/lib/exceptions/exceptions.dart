
class CsvHeaderMissingError extends ArgumentError {
  CsvHeaderMissingError(): super.value("A csv file requires a header line.");
}

class NoFileChosenError extends ArgumentError {
  NoFileChosenError(): super.notNull("No file was chosen.");
}

class InvalidFileExtensionError extends ArgumentError {
  InvalidFileExtensionError(): super("Invalid file extension.");
}

class JsonFormatIncompatibleException extends ArgumentError {
  JsonFormatIncompatibleException(): super("The given json is incompatible.");
}