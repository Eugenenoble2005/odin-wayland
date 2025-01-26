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
	@(link_name = "wl_event_loop_create")
	CreateEventLoop :: proc() -> ^EventLoop ---

	@(link_name = "wl_event_loop_destroy")
	DestroyEventLoop :: proc(_: ^EventLoop) ---

	@(link_name = "wl_event_loop_add_fd")
	AddEventLoopFd :: proc(_: ^EventLoop, _: c.int, _: c.uint32_t, _: proc(_: c.int, _: c.uint32_t, _: rawptr) -> c.int, _: rawptr) -> ^EventSource ---

	@(link_name = "wl_event_source_fd_update")
	UpdateEventSourceFd :: proc(_: ^EventSource, _: c.uint32_t) -> c.int ---

	@(link_name = "wl_event_loop_add_timer")
	AddTimerToEventLoop :: proc(_: ^EventLoop, _: proc(_: rawptr), _: rawptr) -> ^EventSource ---

	@(link_name = "wl_event_loop_add_signal")
	AddSignalToEventLoop :: proc(_: ^EventLoop, _: c.int, _: proc(_: c.int, _: rawptr) -> c.int, _: rawptr) -> ^EventSource ---

	@(link_name = "wl_event_source_timer_update")
	UpdateEventSourceTimer :: proc(_: ^EventSource, _: c.int) -> c.int ---

	@(link_name = "wl_event_source_remove")
	RemoveEventSource :: proc(_: ^EventSource) -> c.int ---

	@(link_name = "wl_event_source_check")
	CheckEventSource :: proc(_: ^EventSource) ---

	@(link_name = "wl_event_loop_dispatch")
	DispatchEventLoop :: proc(_: ^EventLoop, _: c.int) -> c.int ---

	@(link_name = "wl_event_loop_dispatch_idle")
	DispatchIdleEventLoop :: proc(_: ^EventLoop) -> c.int ---

	@(link_name = "wl_event_loop_add_idle")
	AddIdleToEventLoop :: proc(_: ^EventLoop, _: proc(_: rawptr), _: rawptr) -> ^EventSource ---

	@(link_name = "wl_event_loop_get_fd")
	GetEventLoopFd :: proc(_: ^EventLoop) -> c.int ---

	@(link_name = "wl_event_loop_add_destroy_listener")
	AddDestroyListenerToEventLoop :: proc(_: ^EventLoop, _: ^Listener) ---

	@(link_name = "wl_event_loop_get_destroy_listener")
	GetDestroyListenerFromEventLoop :: proc(_: ^EventLoop, _: proc(_: ^Listener, _: rawptr)) -> ^Listener ---

	@(link_name = "wl_display_create")
	CreateDisplay :: proc() -> ^Display ---

	@(link_name = "wl_display_destroy")
	DestroyDisplay :: proc(_: ^Display) ---

	@(link_name = "wl_display_get_event_loop")
	GetEventLoopFromDisplay :: proc(_: ^Display) -> ^EventLoop ---

	@(link_name = "wl_display_add_socket")
	AddSocketToDisplay :: proc(_: ^Display, _: cstring) -> c.int ---

	@(link_name = "wl_display_add_socket_auto")
	AddSocketToDisplayAuto :: proc(_: ^Display) -> cstring ---

	@(link_name = "wl_display_terminate")
	TerminateDisplay :: proc(_: ^Display) ---

	@(link_name = "wl_display_run")
	RunDisplay :: proc(_: ^Display) ---

	@(link_name = "wl_display_flush_clients")
	FlushDisplayClients :: proc(_: ^Display) ---

	@(link_name = "wl_display_destroy_clients")
	DestroyDisplayClients :: proc(_: ^Display) ---

	@(link_name = "wl_display_set_default_max_buffer_size")
	SetDisplayDefaultMaxBufferSize :: proc(_: ^Display, _: c.size_t) ---

	@(link_name = "wl_display_get_serial")
	GetDisplaySerial :: proc(_: ^Display) -> c.uint32_t ---

	@(link_name = "wl_display_next_serial")
	NextDisplaySerial :: proc(_: ^Display) -> c.uint32_t ---

	@(link_name = "wl_display_add_destroy_listener")
	AddDestroyListenerToDisplay :: proc(_: ^Display, _: ^Listener) ---

	@(link_name = "wl_display_add_client_created_listener")
	AddClientCreatedListenerToDisplay :: proc(_: ^Display, _: ^Listener) ---

	@(link_name = "wl_display_get_destroy_listener")
	GetDisplayDestroyListener :: proc(_: ^Display, _: proc(_: ^Listener, _: rawptr)) -> ^Listener ---

	@(link_name = "wl_global_create")
	CreateGlobal :: proc(_: ^Display, _: ^Interface, _: c.int, _: rawptr, _: proc(_: ^Client, _: rawptr, _: c.uint32_t, _: c.uint32_t)) -> ^Global ---

	@(link_name = "wl_global_remove")
	RemoveGlobal :: proc(_: ^Global) ---

	@(link_name = "wl_global_destroy")
	DestroyGlobal :: proc(_: ^Global) ---

	@(link_name = "wl_display_set_global_filter")
	SetDisplayGlobalFilter :: proc(_: ^Display, _: proc(_: ^Client, _: ^Global, _: rawptr), _: rawptr) ---

	@(link_name = "wl_global_get_interface")
	GetGlobalInterface :: proc(_: ^Global) -> ^Interface ---

	@(link_name = "wl_global_get_name")
	GetGlobalName :: proc(_: ^Global, _: ^Client) -> c.uint32_t ---

	@(link_name = "wl_global_get_version")
	GetGlobalVersion :: proc(_: ^Global) -> c.uint32_t ---

	@(link_name = "wl_global_get_display")
	GetGlobalDisplay :: proc(_: ^Global) -> ^Display ---

	@(link_name = "wl_global_get_user_data")
	GetGlobalUserData :: proc(_: ^Global) -> rawptr ---

	@(link_name = "wl_global_set_user_data")
	SetGlobalUserData :: proc(_: ^Global, _: rawptr) ---

	@(link_name = "wl_client_create")
	CreateClient :: proc(_: ^Display, _: c.int) -> ^Client ---

	@(link_name = "wl_display_get_client_list")
	GetDisplayClientList :: proc(_: ^Display) -> ^List ---

	@(link_name = "wl_client_get_link")
	GetClientLink :: proc(_: ^Client) -> ^List ---

	@(link_name = "wl_client_from_link")
	ClientFromLink :: proc(_: ^List) -> ^Client ---

	@(link_name = "wl_client_destroy")
	DestroyClient :: proc(_: ^Client) ---

	@(link_name = "wl_client_flush")
	FlushClient :: proc(_: ^Client) ---

	@(link_name = "wl_client_get_credentials")
	GetClientCredentials :: proc(_: ^Client, _: c.int, _: c.int, _: c.int) ---

	@(link_name = "wl_client_get_fd")
	GetClientFd :: proc(_: ^Client) -> c.int ---

	@(link_name = "wl_client_add_destroy_listener")
	AddDestroyListenerToClient :: proc(_: ^Client, _: ^Listener) ---

	@(link_name = "wl_client_get_destroy_listener")
	GetDestroyListenerFromClient :: proc(_: ^Client, _: proc(_: ^Listener, _: rawptr)) -> ^Listener ---

	@(link_name = "wl_client_add_destroy_late_listener")
	AddLateDestroyListenerToClient :: proc(_: ^Client, _: ^Listener) ---

	@(link_name = "wl_client_get_destroy_late_listener")
	GetLateDestroyListenerFromClient :: proc(_: ^Client, _: proc(_: ^Listener, _: rawptr)) -> ^Listener ---

	@(link_name = "wl_client_get_object")
	GetObjectFromClient :: proc(_: ^Client, _: c.uint32_t) -> ^Resource ---

	@(link_name = "wl_client_post_no_memory")
	PostNoMemoryFromClient :: proc(_: ^Client) ---

	@(link_name = "wl_client_post_implementation_error")
	PostImplementationErrorFromClient :: proc(_: ^Client, _: cstring, #c_vararg _: ..any) ---

	@(link_name = "wl_client_add_resource_created_listener")
	AddResourceCreatedListenerToClient :: proc(_: ^Client, _: ^Listener) ---

	@(link_name = "wl_client_for_each_resource")
	ForEachResourceInClient :: proc(_: ^Client, _: proc(_: ^Resource, _: rawptr) -> IteratorResult, _: rawptr) ---

	@(link_name = "wl_client_set_user_data")
	SetClientUserData :: proc(_: ^Client, _: rawptr, _: proc(_: rawptr)) ---

	@(link_name = "wl_client_set_max_buffer_size")
	SetClientMaxBufferSize :: proc(_: ^Client, _: c.size_t) ---

	@(link_name = "wl_signal_emit_mutable")
	EmitMutableSignal :: proc(_: ^Signal, _: rawptr) ---

	@(link_name = "wl_resource_post_event")
	PostResourceEvent :: proc(_: ^Resource, _: c.uint32_t, #c_vararg _: ..any) ---

	@(link_name = "wl_resource_post_event_array")
	PostResourceEventArray :: proc(_: ^Resource, _: c.uint32_t, _: ^Argument) ---

	@(link_name = "wl_resource_queue_event")
	QueueResourceEvent :: proc(_: ^Resource, _: c.uint32_t, #c_vararg _: ..any) ---

	@(link_name = "wl_resource_queue_event_array")
	QueueResourceEventArray :: proc(_: ^Resource, _: c.uint32_t, _: ^Argument) ---


}

InitSignal :: proc(signal: ^Signal) {
	InitList(&signal.listener_list)
}

AddSignal :: proc(signal: ^Signal, listener: ^Listener) {
	InsertIntoList(signal.listener_list.prev, &listener.link)
}

GetSignal :: proc(signal: ^Signal, notify: proc(listener: ^Listener, data: rawptr)) -> ^Listener {
	l: ^Listener
	for x in ForEachInList(&l, &signal.listener_list, "link", .Forward) {
		if x.notify == notify do return x
	}
	return nil
}

EmitSignal :: proc(signal: ^Signal, data: rawptr) {
	l, next: ^Listener
	for x in SafeForEachInList(&l, &next, &signal.listener_list, "link", .Forward) {
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
	InitSignal(&signal)
	AddSignal(&signal, &l1)
	for x in 0 ..< 100 {
		counter += 1
		EmitSignal(&signal, &count)
	}
	testing.expect(t, counter == 100)
}
