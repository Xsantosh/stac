# STAC DSL CLI Example

This example demonstrates how to use the STAC DSL library from the command line to generate STAC JSON files.

## Installation

First, get the dependencies:

```bash
cd example
flutter pub get
```

## Usage

Run the CLI tool with various options to generate different types of STAC widgets:

```bash
dart bin/stac_dsl_cli.dart [options]
```

### Options

- `-t, --type`: Type of widget to create (text, container, button, complex)
- `-o, --output`: Output file path
- `--text`: Text content for text widgets
- `--color`: Color for containers or text (hex format)
- `--font-size`: Font size for text
- `-p, --pretty`: Pretty print the JSON output (default: true)
- `-h, --help`: Show help message

### Examples

#### Generate a text widget:

```bash
dart bin/stac_dsl_cli.dart -t text --text "Hello World" -o text.json
```

#### Generate a container with custom color:

```bash
dart bin/stac_dsl_cli.dart -t container --color "#FF0000" -o container.json
```

#### Generate a button:

```bash
dart bin/stac_dsl_cli.dart -t button --text "Click Me" -o button.json
```

#### Generate a complex nested widget:

```bash
dart bin/stac_dsl_cli.dart -t complex -o complex.json
```

## Generated Output

The tool will create a JSON file at the specified output location and also print the JSON content to the console.

Example output for a text widget:

```json
{
  "type": "text",
  "data": "Hello STAC",
  "style": {
    "fontSize": 18.0,
    "fontWeight": 500,
    "color": "#3B82F6"
  }
}
```
