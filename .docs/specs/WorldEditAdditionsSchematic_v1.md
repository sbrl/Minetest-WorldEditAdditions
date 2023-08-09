# WorldEditAdditions Schematic File Format

DRAFT SPEC DRAFT SPEC DRAFT SPEC DRAFT SPEC DRAFT SPEC DRAFT SPEC DRAFT SPEC

- **Current version:** v1-DRAFT

This file format specification describes the format of WorldEditAdditions schematic files. The words `MUST`, `MAY`, `SHALL`, `MUST NOT`, etc that are used in this document are defined as in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

Explanations and descriptions have both a technical description and a formal BNF description. Where the two differ, the formal BNF will always take precedence.

## Purpose
The WorldEditAdditions Schematic file format is designed to store schematics of structures in the Minetest world in an efficient text-based format. It is also designed to store just the changes from one copy of the world to another (deltas).

The rationale behind this format are as follows:

1. No other Minetest schematic format is capable of optionally storing changesets.
2. The WorldEdit format (alternative A) is space-inefficient.
3. No simple text-based format exists for storing Minetest schematics at this time, so the best of the authors' knowledge.


## File extension
The file extension for WorldEditAdditions Schematic files MUST be `.weaschem`. Implementers SHOULD NOT choose to also parse files without this file extension.

### Compression
WorldEditAdditions Schematics MAY be gzip-compressed. In such cases, the file extension MUST be `.weaschem.gz`. Implementers MUST transparently decompress them and parse them as normal.

## Terms
> Minetest

The voxel-based sandbox building game [Minetest](https://minetest.net/).

> Deltas

The differences between a given region of the world at a given time and the same region some time later.

> BNF

[Backus-Naur form](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form). Used to formally describe the file format.

> JSON Schema

The description of the format of a JSON object. See also: <https://json-schema.org/>. 

> `\n`

Stands for the ASCII character new line U+0A. Wherever this symbol appears, substitute with this character.

## Overview
The format can be divided into 4 sequential parts:

1. **Magic bytes:** The string `WEASCHEM\n` is always the beginning of the file.
2. **Header:** Contains metadata about the schematic.
3. **ID map:** The map of node ids to their respective node names.
4. **Data tables:** The actual data itself.

As an example:

```
WEASCHEM
<json_header_here>
<id_map_here>
<data_table_data>
<data_table_param1>
```

....where text in the form `<abc>` are placeholders. More formally:

```bnf
<weaschem> ::= <magic_bytes> <header> <nl> <id_map> <nl> <data_table_list>

<nl> ::= "\n"

<magic_bytes> ::= WEASCHEM <nl>

<data_table_list> ::= <data_table>
	| <data_table> <nl> <data_table_list>
```

The non-terminal tokens `<header>`, `<id_map>`, and `<data_table>` are defined below.

## Header
The header of the file contains all the metadata about the schematic required to restore it into the world. The header is defined as a JSON object on a single line, followed by a new line (`\n`):

```
{"foo":"bar"}\n
```

This JSON object follows the following JSON schema:

```json
{
	"$schema": "https://json-schema.org/draft/2020-12/schema",
	"$id": "TODO: FILL THIS OUT",
	"title": "Header",
	"description": "The header that contains the schematic's metadata.",
	"type": "object",
	"properties": {
		"name": {
			"description": "The human-readable display name of the schematic.",
			"type": "string"
		},
		"description": {
			"description": "A short description of the schematic.",
			"type": "string"
		},
		"pos1": {
			"description": "Position 1 of the defined region that this schematic takes up. MAY be in object space, or MAY be in world space.",
			"type": "object"
		},
		"pos2": {
			"description": "Position 2 of the defined region that this schematic takes up. MAY be in object space, or MAY be in world space, but whatever space its in it MUST match pos1.",
			"type": "object"
		},
		"type": {
			"description": "The type of schematic this is. Valid values: full, delta.",
			"type": "string"
		},
		"generator": {
			"description": "The name and version of the software that generated this schematic.",
			"type": "string"
		}
	},
	"required": [ "name", "pos1", "pos2", "type", "generator" ],
}
```

A specific example of a header JSON object is noted below. This example is pretty-printed for convenience, but in the real file format it is stored compacted - i.e. all on one line with no pretty-printed whitespace.

```json
{
	"name": "A castle",
	"description": "A grand fairy tale-style castle with multiple towers.",
	"pos1": { "x": 450, "y": 11, "z": 2301 },
	"pos2": { "x": 1026, "y": 11, "z": 3017 },
	"type": "full",
	"generator": "WorldEditAdditions v1.14"
}
```


### Positioning
TODO: Describe schematic pos1/pos2 positioning here.