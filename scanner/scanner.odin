package scanner
import "core:encoding/xml"
import "core:fmt"
import "core:os"
import "core:strings"
Side :: enum {
	Client,
	Server,
}
ProtocolData :: struct {
	protocol_name: string,
}
LineBreak :: "\r\n"
protocol_data: ProtocolData
Buffer: strings.Builder
main :: proc() {
	args := os.args
	//parse args
	if len(args) == 2 && args[1] == "-h" {
		fmt.println(
			"Wayland Scanner implementation in Odin. Format : scanner <server|client> <input_xml> <output_location>",
		)
		return
	}
	if len(args) < 4 do Die("Not enough arguments")
	if args[1] != "client" && args[1] != "server" do Die("Argument one must be either 'client' or 'server'")

	//arg2 must be protocol file
	protocol_file := args[2]
	doc, err := xml.load_from_file(protocol_file)
	if err != .None do Die("Could not load protocol. Aborting...")

	//start writing to Buffer
	strings.write_string(&Buffer, "//GENERATED BY ODIN WAYLAND SCANNER\r\n")
	//Scan
	Scan(doc)
	fmt.println(strings.to_string(Buffer))
}

Scan :: proc(doc: ^xml.Document) {
	using strings
	//get protocol
	for el in doc.elements {
		if (el.ident == "protocol") {
			el := el
			ScanProtocol(&el)
		}
		if (el.ident == "copyright") {
			if len(el.value) == 1 {
				//try to use union as string
				copyright_as_string := el.value[0].(string)
				if copyright_as_string == "" || len(copyright_as_string) == 0 do continue //could not parse union 
				//append copyright notice
				write_string(&Buffer, "/*")
				write_string(&Buffer, LineBreak)
				write_string(&Buffer, copyright_as_string)
				write_string(&Buffer, LineBreak)
				write_string(&Buffer, "*/")
			}
		}
	}
}
ScanProtocol :: proc(el: ^xml.Element) {
	//protocol name
	for attr in el.attribs {
		if attr.key == "name" do protocol_data.protocol_name = attr.val
		break
	}
}

Die :: proc(msg: string) {
	fmt.println(msg)
	os.exit(0)

