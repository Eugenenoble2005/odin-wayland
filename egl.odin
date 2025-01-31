package wayland
foreign import wayland "system:libwayland-egl.so"
import "core:c"

EglWindow :: struct {}
Surface :: struct {}

@(link_prefix = "wl_")
foreign wayland {
	egl_window_create :: proc(_: ^Surface, _: c.int, _: c.int) -> ^EglWindow ---

	egl_window_destroy :: proc(_: ^EglWindow) ---

	egl_window_resize :: proc(_: ^EglWindow, _: c.int, _: c.int, _: c.int, _: c.int) ---

	egl_window_get_attached_size :: proc(_: ^EglWindow, _: ^c.int, _: ^c.int) ---
}
