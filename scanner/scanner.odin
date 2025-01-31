package scanner
import "core:encoding/xml"
import "core:fmt"
import "core:log"
import "core:os"
import "core:strings"

Side :: enum {
	Client,
	Server,
}
ProtocolData :: struct {
	name:                string,
	interfaces:          [dynamic]Interface,
	events:              [dynamic]Event,
	enums:               [dynamic]Enumeration,
	description:         string,
	description_summary: string,
}
LineBreak :: "\r\n"
protocol_data: ProtocolData
Buffer: strings.Builder
Tab_Size :: 4
Element_Id :: xml.Element_ID
Interface :: struct {
	name:        string,
	description: string,
	requests:    [dynamic]Request,
	events:      [dynamic]Event,
	version:     string,
}

Enumeration :: struct {
	name:        string,
	description: string,
	values:      [dynamic]map[string]string, //should probably be an int as the map value
}
Request :: struct {
	name:          string,
	description:   string,
	since:         string,
	args:          [dynamic]Arg,
	is_destructor: bool,
}
Event :: Request //??

Arg :: struct {
	name:        string,
	type:        string,
	summary:     string,
	interface:   string,
	enumeration: string,
	allow_null:  bool,
	new_type:    bool,
}
type_map := map[string]string {
	"int"    = "c.int32_t",
	"fd"     = "c.int32_t",
	"new_id" = "c.uint32_t",
	"uint"   = "c.uint32_t",
	"fixed"  = "wl.Fixed",
	"string" = "cstring",
	"object" = "rawptr",
	"array"  = "^wl.Array",
}

parse_protocol :: proc(doc: ^xml.Document) {
	element_count := doc.element_count
	for x in 0 ..< element_count {
		element := doc.elements[x]
		//get protocol name as defined in the xml 
		if element.ident == "protocol" {
			for attrib in element.attribs {
				if attrib.key == "name" do protocol_data.name = attrib.val
				break
			}
			for el in element.value {
				node := doc.elements[el.(xml.Element_ID)] //potentially problematic
				//copyright
				if node.ident == "copyright" {
					if len(node.value) != 1 do continue //invalid
					copyright_text, ok := node.value[0].(string)
					if ok {
						write_to_buffer("/*")
						write_to_buffer(copyright_text)
						write_to_buffer("*/")
					}
				}
				//description
				if node.ident == "description" {
					//try get summary if it exists
					for attrib in node.attribs {
						if attrib.key == "summary" do protocol_data.description_summary = attrib.val
						break
					}
					if len(node.value) != 1 do continue //invalid
					desc_text, ok := node.value[0].(string)
					if ok do protocol_data.description = desc_text
				}
				//interface
				if node.ident == "interface" {
					append(&protocol_data.interfaces, parse_interface(doc, &node))
				}
			}
		}
		//enums which can be defined anywhere
	}
}
parse_interface :: proc(doc: ^xml.Document, el: ^xml.Element) -> Interface {
	interface: Interface
	//try get name and version if they exist
	for attrib in el.attribs {
		if attrib.key == "name" do interface.name = attrib.val
		if attrib.key == "version" do interface.version = attrib.val
	}
	for val in el.value {
		node := doc.elements[val.(Element_Id)]
		//requst 
		if node.ident == "request" {
			append(&interface.requests, parse_requests_or_events(doc, &node))
		}
		//event
		if node.ident == "event" {
			append(&interface.events, parse_requests_or_events(doc, &node))
		}
		//enum
		if node.ident == "enum" {
			append(&protocol_data.enums, parse_enum(doc, &node, interface.name))
		}
	}
	return interface
}
parse_requests_or_events :: proc(doc: ^xml.Document, el: ^xml.Element) -> Request {
	request: Request
	//initially set to not a destructor, will be updated in below loop if necessary
	request.is_destructor = false
	for attrib in el.attribs {
		if attrib.key == "name" do request.name = attrib.val
		if attrib.key == "type" {
			if attrib.val == "destructor" {
				request.is_destructor = true
			}
		}
		if attrib.key == "since" do request.since = attrib.val
	}
	//check for args
	for val in el.value {
		node := doc.elements[val.(Element_Id)]
		if node.ident == "arg" {
			arg: Arg
			for attrib in node.attribs {
				if attrib.key == "type" do arg.type = attrib.val
				if attrib.key == "name" do arg.name = attrib.val
				if attrib.key == "interface" do arg.interface = attrib.val
				if attrib.key == "enum" do arg.enumeration = attrib.val
				if attrib.key == "allow-null" do arg.allow_null = attrib.val == "true"
				if attrib.key == "summary" do arg.summary = attrib.val
			}
			append(&request.args, arg)
		}
	}
	return request
}
parse_enum :: proc(doc: ^xml.Document, el: ^xml.Element, interface_name: string) -> Enumeration {
	enum_: Enumeration
	for attrib in el.attribs {
		if attrib.key == "name" {
			enum_.name = strings.concatenate({interface_name, "_", attrib.val})
		}
	}
	for val in el.value {
		node := doc.elements[val.(Element_Id)]
		if node.ident == "description" {
			enum_.description = el.value[0].(string)
		}
		if node.ident == "entry" {
			entry_id := val.(Element_Id)
			entry_data := make(map[string]string)
			defer delete(entry_data)
			entry_name, _ := xml.find_attribute_val_by_key(doc, entry_id, "name")
			entry_value, _ := xml.find_attribute_val_by_key(doc, entry_id, "value")
			entry_data[entry_name] = entry_value
			append(&enum_.values, entry_data)
			entry_data = nil
		}
	}
	return enum_
}
parse_args :: proc(args: []string) {
	if len(args) == 2 && args[1] == "-h" {
		fmt.println(
			"Wayland Scanner implementation in Odin. Format : scanner <server|client> <input_xml> <output_location>",
		)
		return
	}
	if len(args) < 4 do die("Not enough arguments")
	if args[1] != "client" && args[1] != "server" do die("Argument one must be either 'client' or 'server'")
}

die :: proc(msg: string) {
	fmt.println(msg)
	os.exit(0)
}

emit_enums :: proc() {
	using strings
	fmt.println(protocol_data.enums)
	for enumeration in protocol_data.enums {
		h_ := concatenate({enumeration.name, " ", ":: ", "enum c.int32_t", "{\r\n"})
		for value in enumeration.values {
			for key, val in value {
				h_ = concatenate({h_, repeat(" ", Tab_Size), key, " = ", val, ",", "\r\n"})
			}
		}
		h_ = concatenate({h_, "}", "\r\n"})
		write_to_buffer(h_)
	}
}

main :: proc() {
	args := os.args
	parse_args(args)
	protocol_file := args[2]
	doc, err := xml.load_from_file(protocol_file)
	if err != .None do die("Could not load protocol. Aborting...")
	write_to_buffer("/* GENERATED BY ODIN WAYLAND SCANNER*/")
	//scanner currently assumes wayland bindings are in the shared collection, write import of binds to buffer
	write_to_buffer("import wl \"shared:wayland\"")
	write_to_buffer("import \"core:c\"")
	parse_protocol(doc)

	//emissions
	emit_enums()
	fmt.println(strings.to_string(Buffer))
}

write_to_buffer :: proc(text: string) {
	strings.write_string(&Buffer, text)
	strings.write_string(&Buffer, LineBreak)
}
