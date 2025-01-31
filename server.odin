package wayland
import "core:c"
import "core:log"
import "core:testing"
foreign import wayland "system:libwayland-server.so"
EventSource :: struct {}
EventLoop :: struct {}
Listener :: struct {
	link:   List,
	notify: proc(_: ^Listener, _: rawptr),
}
Signal :: struct {
	listener_list: List,
}
Resource :: struct {}
Client :: struct {}
Global :: struct {}
IteratorResult :: enum c.int {
	Stop,
	Continue,
}
foreign wayland {
	event_loop_create :: proc() -> ^EventLoop ---

	event_loop_destroy :: proc(_: ^EventLoop) ---

	event_loop_add_fd :: proc(_: ^EventLoop, _: c.int, _: c.uint32_t, _: proc(_: c.int, _: c.uint32_t, _: rawptr) -> c.int, _: rawptr) -> ^EventSource ---

	event_source_fd_update :: proc(_: ^EventSource, _: c.uint32_t) -> c.int ---

	event_loop_add_timer :: proc(_: ^EventLoop, _: proc(_: rawptr), _: rawptr) -> ^EventSource ---

	event_loop_add_signal :: proc(_: ^EventLoop, _: c.int, _: proc(_: c.int, _: rawptr) -> c.int, _: rawptr) -> ^EventSource ---

	event_source_timer_update :: proc(_: ^EventSource, _: c.int) -> c.int ---

	event_source_remove :: proc(_: ^EventSource) -> c.int ---

	event_source_check :: proc(_: ^EventSource) ---

	event_loop_dispatch :: proc(_: ^EventLoop, _: c.int) -> c.int ---

	event_loop_dispatch_idle :: proc(_: ^EventLoop) -> c.int ---

	event_loop_add_idle :: proc(_: ^EventLoop, _: proc(_: rawptr), _: rawptr) -> ^EventSource ---

	event_loop_get_fd :: proc(_: ^EventLoop) -> c.int ---

	event_loop_add_destroy_listener :: proc(_: ^EventLoop, _: ^Listener) ---

	event_loop_get_destroy_listener :: proc(_: ^EventLoop, _: proc(_: ^Listener, _: rawptr)) -> ^Listener ---

	display_create :: proc() -> ^Display ---

	display_destroy :: proc(_: ^Display) ---

	display_get_event_loop :: proc(_: ^Display) -> ^EventLoop ---

	display_add_socket :: proc(_: ^Display, _: cstring) -> c.int ---

	display_add_socket_auto :: proc(_: ^Display) -> cstring ---

	display_terminate :: proc(_: ^Display) ---

	display_run :: proc(_: ^Display) ---

	display_flush_clients :: proc(_: ^Display) ---

	display_destroy_clients :: proc(_: ^Display) ---

	display_set_default_max_buffer_size :: proc(_: ^Display, _: c.size_t) ---

	display_get_serial :: proc(_: ^Display) -> c.uint32_t ---

	display_next_serial :: proc(_: ^Display) -> c.uint32_t ---

	display_add_destroy_listener :: proc(_: ^Display, _: ^Listener) ---

	display_add_client_created_listener :: proc(_: ^Display, _: ^Listener) ---

	display_get_destroy_listener :: proc(_: ^Display, _: proc(_: ^Listener, _: rawptr)) -> ^Listener ---

	global_create :: proc(_: ^Display, _: ^Interface, _: c.int, _: rawptr, _: proc(_: ^Client, _: rawptr, _: c.uint32_t, _: c.uint32_t)) -> ^Global ---

	global_remove :: proc(_: ^Global) ---

	global_destroy :: proc(_: ^Global) ---

	display_set_global_filter :: proc(_: ^Display, _: proc(_: ^Client, _: ^Global, _: rawptr), _: rawptr) ---

	global_get_interface :: proc(_: ^Global) -> ^Interface ---

	global_get_name :: proc(_: ^Global, _: ^Client) -> c.uint32_t ---

	global_get_version :: proc(_: ^Global) -> c.uint32_t ---

	global_get_display :: proc(_: ^Global) -> ^Display ---

	global_get_user_data :: proc(_: ^Global) -> rawptr ---

	global_set_user_data :: proc(_: ^Global, _: rawptr) ---

	client_create :: proc(_: ^Display, _: c.int) -> ^Client ---

	display_get_client_list :: proc(_: ^Display) -> ^List ---

	client_get_link :: proc(_: ^Client) -> ^List ---

	client_from_link :: proc(_: ^List) -> ^Client ---

	client_destroy :: proc(_: ^Client) ---

	client_flush :: proc(_: ^Client) ---

	client_get_credentials :: proc(_: ^Client, _: c.int, _: c.int, _: c.int) ---

	client_get_fd :: proc(_: ^Client) -> c.int ---

	client_add_destroy_listener :: proc(_: ^Client, _: ^Listener) ---

	client_get_destroy_listener :: proc(_: ^Client, _: proc(_: ^Listener, _: rawptr)) -> ^Listener ---

	client_add_destroy_late_listener :: proc(_: ^Client, _: ^Listener) ---

	client_get_destroy_late_listener :: proc(_: ^Client, _: proc(_: ^Listener, _: rawptr)) -> ^Listener ---

	client_get_object :: proc(_: ^Client, _: c.uint32_t) -> ^Resource ---

	client_post_no_memory :: proc(_: ^Client) ---

	client_post_implementation_error :: proc(_: ^Client, _: cstring, #c_vararg _: ..any) ---

	client_add_resource_created_listener :: proc(_: ^Client, _: ^Listener) ---

	client_for_each_resource :: proc(_: ^Client, _: proc(_: ^Resource, _: rawptr) -> IteratorResult, _: rawptr) ---

	client_set_user_data :: proc(_: ^Client, _: rawptr, _: proc(_: rawptr)) ---

	client_set_max_buffer_size :: proc(_: ^Client, _: c.size_t) ---

	signal_emit_mutable :: proc(_: ^Signal, _: rawptr) ---

	resource_post_event :: proc(_: ^Resource, _: c.uint32_t, #c_vararg _: ..any) ---

	resource_post_event_array :: proc(_: ^Resource, _: c.uint32_t, _: ^Argument) ---

	resource_queue_event :: proc(_: ^Resource, _: c.uint32_t, #c_vararg _: ..any) ---

	resource_queue_event_array :: proc(_: ^Resource, _: c.uint32_t, _: ^Argument) ---


}

signal_init :: proc(signal: ^Signal) {
	list_init(&signal.listener_list)
}

signal_add :: proc(signal: ^Signal, listener: ^Listener) {
	list_insert(signal.listener_list.prev, &listener.link)
}

signal_get :: proc(signal: ^Signal, notify: proc(listener: ^Listener, data: rawptr)) -> ^Listener {
	l: ^Listener
	for x in list_for_each(&l, &signal.listener_list, "link", .Forward) {
		if x.notify == notify do return x
	}
	return nil
}

signal_emit :: proc(signal: ^Signal, data: rawptr) {
	l, next: ^Listener
	for x in list_for_each_safe(&l, &next, &signal.listener_list, "link", .Forward) {
		x.notify(x, data)
	}
}

@(test)
EmitSignalToOneListenerTest :: proc(t: ^testing.T) {
	NotifySignal :: proc(listener: ^Listener, data: rawptr) {
		//cast data to int pointer, dereference and increment
		(^int)(data)^ += 1
	}
	count := 0
	counter: int
	signal: Signal
	l1: Listener
	l1.notify = NotifySignal
	signal_init(&signal)
	signal_add(&signal, &l1)
	for x in 0 ..< 100 {
		counter += 1
		signal_emit(&signal, &count)
	}
	testing.expect(t, counter == count)
}
