package wayland
import "core:c"
foreign import wayland "system:libwayland-client.so"

Proxy :: struct {}

Display :: struct {}

EventQueue :: struct {}

Object :: struct {}

MARSHAL_FLAG_DESTROY :: (1 << 0)

@(link_prefix = "wl_")
foreign wayland {
	@(link_name = "event_queue_destroy")
	event_queue_destroy :: proc(_: ^EventQueue) ---

	proxy_marshal_flags :: proc(_: ^Proxy, _: c.uint32_t, _: Interface, _: c.uint32_t, _: c.uint32_t, #c_vararg _: ..any) -> ^Proxy ---

	proxy_marshal_array_flags :: proc(_: ^Proxy, _: c.uint32_t, _: ^Interface, _: c.uint32_t, _: c.uint32_t, _: ^Argument) -> ^Proxy ---

	proxy_marshal :: proc(_: ^Proxy, _: c.uint32_t, #c_vararg _: ..any) ---

	proxy_marshal_array :: proc(_: ^Proxy, _: c.uint32_t, _: ^Argument) ---

	proxy_create :: proc(_: ^Proxy, _: ^Interface) -> ^Proxy ---

	proxy_create_wrapper :: proc(_: ^rawptr) -> rawptr ---

	proxy_wrapper_destroy :: proc(_: ^rawptr) ---

	proxy_marshal_constructor :: proc(_: ^Proxy, _: c.uint32_t, _: ^Interface, #c_vararg _: ..any) -> ^Proxy ---

	proxy_marshal_constructor_versioned :: proc(_: ^Proxy, _: c.uint32_t, _: ^Argument, _: ^Interface, _: c.uint32_t, _: ..any) -> ^Proxy ---

	proxy_marshal_array_constructor :: proc(_: ^Proxy, _: c.uint32_t, _: ^Argument, _: ^Interface, _: c.uint32_t) -> ^Proxy ---

	proxy_marshal_array_constructor_versioned :: proc(_: ^Proxy, _: c.uint32_t, _: ^Argument, _: ^Interface, _: c.uint32_t) -> ^Proxy ---

	proxy_destroy :: proc(_: ^Proxy) ---

	proxy_get_listener :: proc(_: ^Proxy) -> rawptr ---

	proxy_add_dispatcher :: proc(_: ^Proxy, _: proc(_: rawptr, _: rawptr, _: c.uint32_t, _: Message, _: Argument) -> c.int, _: rawptr, _: rawptr) -> c.int ---

	proxy_set_user_data :: proc(_: ^Proxy, _: rawptr) ---

	proxy_get_user_data :: proc(_: ^Proxy) -> rawptr ---

	proxy_get_version :: proc(_: ^Proxy) -> c.uint32_t ---

	proxy_get_id :: proc(_: ^Proxy) -> c.uint32_t ---

	proxy_get_class :: proc(_: ^Proxy) -> cstring ---

	proxy_get_display :: proc(_: ^Proxy) -> ^Display ---

	proxy_set_queue :: proc(_: ^Proxy, _: ^EventQueue) ---

	proxy_get_queue :: proc(_: ^Proxy) -> ^EventQueue ---

	event_queue_get_name :: proc(_: ^EventQueue) -> cstring ---

	display_connect :: proc(_: cstring) -> ^Display ---

	display_disconnect :: proc(_: ^Display) ---

	display_get_fd :: proc(_: ^Display) -> c.int ---

	display_dispatch :: proc(_: ^Display) -> c.int ---

	display_dispatch_queue :: proc(_: ^Display, _: ^EventQueue) -> c.int ---

	display_dispatch_queue_pending :: proc(_: ^Display, _: ^EventQueue) -> c.int ---

	display_dispatch_pending :: proc(_: ^Display) -> c.int ---

	display_get_error :: proc(_: ^Display) -> c.int ---

	display_get_protocol_error :: proc(_: ^Display, _: ^^Interface, _: c.uint32_t) -> c.uint32_t ---

	display_flush :: proc(_: ^Display) -> c.int ---

	display_roundtrip_queue :: proc(_: ^Display, _: ^EventQueue) -> c.int ---

	display_roundtrip :: proc(_: ^Display) -> c.int ---

	display_create_queue :: proc(_: ^Display) -> ^EventQueue ---

	display_create_queue_with_name :: proc(_: ^Display, _: ^EventQueue) -> c.int ---

	display_prepare_read_queue :: proc(_: ^Display, _: ^EventQueue) -> c.int ---

	display_prepare_read :: proc(_: ^Display) -> c.int ---

	display_cancel_read :: proc(_: ^Display) ---

	display_read_events :: proc(_: ^Display) -> c.int ---
}
