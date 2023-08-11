# WorldEditAdditions Schematic File Format

DRAFT SPEC DRAFT SPEC DRAFT SPEC DRAFT SPEC DRAFT SPEC DRAFT SPEC DRAFT SPEC

- **Current version:** v1-DRAFT

This file format specification describes the format of WorldEditAdditions schematic files. The words `MUST`, `MAY`, `SHALL`, `MUST NOT`, etc that are used in this document are defined as in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

Implementers MUST clearly specify which version(s) of this specific they support.

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

> Schematic origin

The origin of the schematic itself. This is always (0, 0, 0). Any schematic generated from the main Minetest world MUST be translated such that the negative X, Y, and Z corner of the defined region to be converted to a schematic is (0, 0, 0) in the generated schematic file.

> Offset

An offset, expressed as a `Vector3`, that MUST be applied to a schematic upon loading it back into the world, though implementers MAY offer an option to disable this (but applying the offset MUST be enabled by default).

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
<json_header>
<id_map>
<data_table_data>
<data_table_param1>
```

....where text in the form `<abc>` are placeholders. More formally:

```bnf
<weaschem> ::= <magic_bytes> <header> <id_map> <data_table_list>

<nl> ::= "\n"

<magic_bytes> ::= WEASCHEM <nl>

<data_table_list> ::= <data_table>
	| <data_table> <nl> <data_table_list>
```

The non-terminal tokens `<header>`, `<id_map>`, and `<data_table>` are defined below.

A full (trivial) example file is given below:

```
WEASCHEM
{"name":"Test schematic","description": "Some description","size":{"x":5,"y":3,"z":4},"offset":{"x":1,"y":0,"z":2},"type":"full","generator": "WorldEditAdditions v1.14"}
{"0":"default:air","5":"default:stone","14":"default:dirt"}
TODO: Add the data tables
```

## Header
The header of the file contains all the metadata about the schematic required to restore it into the world. The header is defined as a JSON object on a single line, followed by a new line (`\n` U+0A):

```bnf
<header> ::= <the_actual_header_json_obj> <nl>
```

```
{"foo":"bar"}\n
```

This JSON object follows the following JSON schema:

```json
{
	"$schema": "https://json-schema.org/draft/2020-12/schema",
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
		"offset": {
			"description": "The offset to place the schematic at in the world, relative to the schematic origin, which is always (0, 0, 0).",
			"$ref": "#/$defs/Vector3"
		},
		"size": {
			"description": "The size of the schematic, INDEXED from 0.",
			"$ref": "#/$defs/Vector3"
		},
		"type": {
			"description": "The type of schematic this is. Valid values: full, delta.",
			"type": "string",
			"pattern": "^(?:full|delta)$"
		},
		"generator": {
			"description": "The name and version of the software that generated this schematic.",
			"type": "string"
		}
	},
	"required": [ "name", "size", "offset", "type", "generator" ],
	"$defs": {
		"Vector3": {
			"properties": {
				"x": {
					"description": "The x co-ordinate of the Vector3.",
					"type": "integer",
				},
				"y": {
					"description": "The y co-ordinate of the Vector3.",
					"type": "integer",
				},
				"z": {
					"description": "The z co-ordinate of the Vector3.",
					"type": "integer",
				}
			}
		}
	}
}
```

A specific example of a header JSON object is noted below. This example is pretty-printed for convenience, but in the real file format it is stored compacted - i.e. all on one line with no pretty-printed whitespace.

```json
{
	"name": "A castle",
	"description": "A grand fairy tale-style castle with multiple towers.",
	"size": { "x": 50, "y": 25, "z": 75 },
	"offset": { "x": 3, "y": 0, "z": 5 },
	"type": "full",
	"generator": "WorldEditAdditions v1.14"
}
```

**Note:** Implementers MUST ignore any additional unexpected properties in the header JSON object.


### Size and positioning
Schematic size and positioning are controlled by 2 properties in the header JSON object:

1. **`size`:** The size of the schematic stored in the schematic
2. **`offset`:** The offset to apply to the schematic when placing it back in the world.

Sizing is measured from the negative (-x, -y, -z) corner of the region.

**Writing:** In Minetest `VoxelManipulator`s do not always load the exact area you ask them for, and load additional area around them. Therefore, it is necessary to first extract the exact area you want to save before encoding the data array in a WorldEditAdditions Schematic file.

**Reading:** When reading a schematic file from disk, is mentioned above the (-x, -y, -z) corner of the schematic SHOULD be translated to match the (-x, -y, -z) corner, or position 1 if position 2 is defined. Then, the offset in the `offset` field of the header MUST be applied to translate the schematic into the final position it will be written to the target Minetest world.

Implementers MAY choose to add a disabled-by-default option to disable the application of `offset`.


### Types of schematic
WorldEditAdditions Schematic files support two types of schematic:

1. **`full`:** Full schematics that contain a static snapshot of the world.
2. **`delta`:** A schematic that contains only the changes between some previous state of the world and the current state of the world.

TODO: Explain the differences more fully.


## ID map
Like the [header](#header), the ID map is also defined as a JSON object on a single line, followed by a new line character (`\n` U+0A):

```bnf
<id_map> ::= <the_actual_id_map_json_obj> <nl>
```

```
{"5": "foo"}\n
```

The ID map's purpose is to map node IDs in the schematic file to canonical node names, since Minetest does not guarantee that node names will remain the same across different worlds.

Node names in a schematic file MUST be the full canonical node name, and not an abbreviation. For example, `default:stone` is valid, but `stone` is invalid (does not specify the mod).

Implementers MAY perform arbitrary transformations on node names when reading or writing a WorldEditAdditions schematic file, but any such transformations are beyond the scope of this specification.

When loading a schematic, it is RECOMMENDED that implementers use a cache when translating schematic node ids (from this ID map) to node ids from the target world.

Formally, the ID map can be described by the following JSON schema:

```json
{
	"$schema": "https://json-schema.org/draft/2020-12/schema",
	"type": "object",
	"title": "ID Map",
	"description": "The JSON schema for the ID Map of a WorldEditAdditions Schematic file.",
	
	"patternProperties": {
		"^[0-9]+$": {
			"type": "string",
			"pattern": "^[^\s]+:[^\s]+$"
		}
	},
	"additionalProperties": false
}
```

In other words, an example ID map might look like this (pretty-printed for convenience, but in an actual file this would compacted and all on one line):

```json
{
	"0": "default:air",
	"5": "default:stone",
	"14": "default:dirt"
}
```

It is not required that Node IDs in the schematic file be sequential.


##