package wayland
import "core:c"
foreign import wayland "system:libwayland-client.so"
import "core:fmt"
import "core:testing"
Fixed :: c.int32_t

Interface :: struct {
	name:         cstring,
	version:      c.int,
	method_count: c.int,
	methods:      ^Message,
	event_count:  c.int,
	events:       ^Message,
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

	@(link_name = "wl_array_init")
	InitArray :: proc(_: ^Array) ---

	@(link_name = "wl_array_release")
	ReleaseArray :: proc(_: ^Array) ---

	@(link_name = "wl_array_add")
	AddToArray :: proc(_: ^Array, _: c.size_t) -> rawptr ---

	@(link_name = "wl_array_copy")
	CopyArrayToArray :: proc(_: ^Array, _: ^Array) -> c.int ---
}

FixedToDouble :: proc(f: Fixed) -> f64 {
	return f64(f) / 256.0
}

FixedFromDouble :: proc(d: f64) -> Fixed {
	return Fixed(d * 256.0)
}

FixedToInt :: proc(f: Fixed) -> int {
	return int(f / 256) //to 64bit?? 
}

FixedFromInt :: proc(i: int) -> Fixed {
	return Fixed(i * 256)
}

@(test)
FixedDoubleConversionTest :: proc(t: ^testing.T) {
	f: Fixed
	d: f64 = 62.125
	f = FixedFromDouble(d)
	testing.expect(t, f == 0x3e20)

	d = -1200.625
	f = FixedFromDouble(d)
	testing.expect(t, f == -0x4b0a0)
}
