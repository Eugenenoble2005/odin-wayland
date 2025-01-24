package wayland
import "core:c"
foreign import wayland "system:libwayland-client.so"
Fixed :: c.int32_t

Interface :: struct {
	name:         cstring,
	version:      c.int,
	method_count: c.int,
	methods:      ^Message,
	event_count:  c.int,
	events:       ^Message,
}

List :: struct {
	prev: ^List,
	next: ^List,
}

Message :: struct {
	name:      cstring,
	signature: cstring,
	types:     ^^Interface,
}

Array :: struct {
	size:  c.size_t,
	alloc: c.size_t,
	data:  rawptr,
}

Argument :: struct #raw_union {
	i: c.int32_t,
	u: c.uint32_t,
	f: Fixed,
	s: cstring,
	o: ^Object,
	n: c.uint32_t,
	a: ^Array,
	h: c.int32_t,
}
foreign wayland {
	@(link_name = "wl_list_init")
	InitList :: proc(_: ^List) ---

	@(link_name = "wl_list_insert")
	InsertIntoList :: proc(_: ^List, _: ^List) ---

	@(link_name = "wl_list_remove")
	RemoveFromList :: proc(_: ^List) ---

	@(link_name = "wl_list_length")
	LengthOfList :: proc(_: ^List) -> c.int ---

	@(private, link_name = "wl_list_empty")
	wl_list_empty :: proc(_: ^List) -> c.int ---

	@(link_name = "wl_list_insert_list")
	InsertListIntoList :: proc(_: ^List, _: ^List) ---

	@(link_name = "wl_array_init")
	InitArray :: proc(_: ^Array) ---

	@(link_name = "wl_array_release")
	ReleaseArray :: proc(_: ^Array) ---

	@(link_name = "wl_array_add")
	AddToArray :: proc(_: ^Array, _: c.size_t) -> rawptr ---

	@(link_name = "wl_array_copy")
	CopyArrayToArray :: proc(_: ^Array, _: ^Array) -> c.int ---


}

IsListEmpty :: proc(list: ^List) -> bool {return wl_list_empty(list) == 1}
