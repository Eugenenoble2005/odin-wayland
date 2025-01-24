package wayland
import "core:c"
foreign import wayland "system:libwayland-client.so"

Proxy :: struct {}

Display :: struct {}

EventQueue :: struct {}

Object :: struct {}

foreign wayland {
	@(link_name = "wl_event_queue_destroy")
	DestroyEventQueue :: proc(_: ^EventQueue) ---

	@(link_name = "wl_proxy_marshal_flags")
	ProxyMarshalFlags :: proc(_: ^Proxy, _: c.uint32_t, _: Interface, _: c.uint32_t, _: c.uint32_t, #c_vararg _: ..any) -> ^Proxy ---

	@(link_name = "wl_proxy_marshal_array_flags")
	ProxyMarshalArrayFlags :: proc(_: ^Proxy, _: c.uint32_t, _: ^Interface, _: c.uint32_t, _: c.uint32_t, _: ^Argument) -> ^Proxy ---

	@(link_name = "wl_proxy_marshal")
	ProxyMarshal :: proc(_: ^Proxy, _: c.uint32_t, #c_vararg _: ..any) ---

	@(link_name = "wl_proxy_marshal_array")
	ProxyMarshalArray :: proc(_: ^Proxy, _: c.uint32_t, _: ^Argument) ---

	@(link_name = "wl_proxy_create")
	CreateProxy :: proc(_: ^Proxy, _: ^Interface) -> ^Proxy ---

	@(link_name = "wl_proxy_create_wrapper")
	CreateProxyWrapper :: proc(_: ^rawptr) -> rawptr ---

	@(link_name = "wl_proxy_wrapper_destroy")
	DestroyProxyWrapper :: proc(_: ^rawptr) ---

	@(link_name = "wl_proxy_marshal_constructor")
	ProxyMarshalConstructor :: proc(_: ^Proxy, _: c.uint32_t, _: ^Interface, #c_vararg _: ..any) -> ^Proxy ---

	@(link_name = "wl_proxy_marshal_constructor_versioned")
	ProxyMarshalConstructorVersioned :: proc(_: ^Proxy, _: c.uint32_t, _: ^Argument, _: ^Interface, _: c.uint32_t, _: ..any) -> ^Proxy ---

	@(link_name = "wl_proxy_marshal_array_constructor")
	ProxyMarshalArrayConstructor :: proc(_: ^Proxy, _: c.uint32_t, _: ^Argument, _: ^Interface, _: c.uint32_t) -> ^Proxy ---

	@(link_name = "wl_proxy_marshal_array_constructor_versioned")
	ProxyMarshalArrayConstructorVersioned :: proc(_: ^Proxy, _: c.uint32_t, _: ^Argument, _: ^Interface, _: c.uint32_t) -> ^Proxy ---

	@(link_name = "wl_proxy_destroy")
	DestroyProxy :: proc(_: ^Proxy) ---

	// @(link_name="wl_proxy_add_listener")
	// AddProxyListener :: proc(_:^Proxy , )
	//
	@(link_name = "wl_proxy_get_listener")
	GetProxyListener :: proc(_: ^Proxy) -> rawptr ---

	@(link_name = "wl_proxy_add_dispatcher")
	AddProxyDispatcher :: proc(_: ^Proxy, _: proc(_: rawptr, _: rawptr, _: c.uint32_t, _: Message, _: Argument) -> c.int, _: rawptr, _: rawptr) -> c.int ---

	@(link_name = "wl_proxy_set_user_data")
	SetProxyUserData :: proc(_: ^Proxy, _: rawptr) ---

	@(link_name = "wl_proxy_get_user_data")
	GetProxyUserData :: proc(_: ^Proxy) -> rawptr ---

	@(link_name = "wl_proxy_get_version")
	GetProxyVersion :: proc(_: ^Proxy) -> c.uint32_t ---

	@(link_name = "wl_proxy_get_id")
	GetProxyId :: proc(_: ^Proxy) -> c.uint32_t ---

	// @(link_name="wl_proxy_set_tag")
	// SetProxyTag :: proc(_:^Proxy, )
	//
	@(link_name = "wl_proxy_get_class")
	GetProxyClass :: proc(_: ^Proxy) -> cstring ---

	@(link_name = "wl_proxy_get_display")
	GetProxyDisplay :: proc(_: ^Proxy) -> ^Display ---

	@(link_name = "wl_proxy_set_queue")
	SetProxyQueue :: proc(_: ^Proxy, _: ^EventQueue) ---

	@(link_name = "wl_proxy_get_queue")
	GetProxyQueue :: proc(_: ^Proxy) -> ^EventQueue ---

	@(link_name = "wl_event_queue_get_name")
	GetEventQueueName :: proc(_: ^EventQueue) -> cstring ---

	@(link_name = "wl_display_connect")
	ConnectToDisplay :: proc(_: cstring) -> ^Display ---

	@(link_name = "wl_display_disconnect")
	DisconnectFromDisplay :: proc(_: ^Display) ---

	@(link_name = "wl_display_get_fd")
	GetDisplayFd :: proc(_: ^Display) -> c.int ---

	@(link_name = "wl_display_dispatch")
	DispatchDisplay :: proc(_: ^Display) -> c.int ---

	@(link_name = "wl_display_dispatch_queue")
	DispatchDisplayQueue :: proc(_: ^Display, _: ^EventQueue) -> c.int ---

	@(link_name = "wl_display_dispatch_queue_pending")
	DispatchPendingDisplayQueue :: proc(_: ^Display, _: ^EventQueue) -> c.int ---

	@(link_name = "wl_display_dispatch_pending")
	DispatchPendingDisplay :: proc(_: ^Display) -> c.int ---

	@(link_name = "wl_display_get_error")
	GetDisplayError :: proc(_: ^Display) -> c.int ---

	@(link_name = "wl_display_get_protocol_error")
	GetDisplayProtocolError :: proc(_: ^Display, _: ^^Interface, _: c.uint32_t) -> c.uint32_t ---

	@(link_name = "wl_display_flush")
	FlushDisplay :: proc(_: ^Display) -> c.int ---

	@(link_name = "wl_display_roundtrip_queue")
	RoundtripDisplayQueue :: proc(_: ^Display, _: ^EventQueue) -> c.int ---

	@(link_name = "wl_display_roundtrip")
	RoundtripDisplay :: proc(_: ^Display) -> c.int ---

	@(link_name = "wl_display_create_queue")
	CreateDisplayQueue :: proc(_: ^Display) -> ^EventQueue ---

	@(link_name = "wl_display_create_queue_with_name")
	CreateDisplayQueueWithName :: proc(_: ^Display, _: ^EventQueue) -> c.int ---

	@(link_name = "wl_display_prepare_read_queue")
	DisplayPrepareReadQueue :: proc(_: ^Display, _: ^EventQueue) -> c.int ---

	@(link_name = "wl_display_prepare_read")
	DisplayPrepareRead :: proc(_: ^Display) -> c.int ---

	@(link_name = "wl_display_cancel_read")
	CancelDisplayRead :: proc(_: ^Display) ---

	@(link_name = "wl_display_read_events")
	DisplayReadEvents :: proc(_: ^Display) -> c.int ---

}
