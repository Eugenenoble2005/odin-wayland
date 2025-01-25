package wayland
foreign import wayland "system:libwayland-egl.so"
import "core:c"

EglWindow :: struct {}
Surface :: struct {}

foreign wayland {
	@(link_name = "wl_egl_window_create")
	CreateEglWindow :: proc(_: ^Surface, _: c.int, _: c.int) -> ^EglWindow ---

	@(link_name = "wl_egl_window_destroy")
	DestroyEglWindow :: proc(_: ^EglWindow) ---

	@(link_name = "wl_egl_window_resize")
	ResizeEglWindow :: proc(_: ^EglWindow, _: c.int, _: c.int, _: c.int, _: c.int) ---

	@(link_name = "wl_egl_window_get_attached_size")
	GetEglWindowAttachedSize :: proc(_: ^EglWindow, _: ^c.int, _: ^c.int) ---

}
