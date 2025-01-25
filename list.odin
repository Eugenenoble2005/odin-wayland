package wayland
import "base:intrinsics"
import "core:c"
List :: struct {
	prev: ^List,
	next: ^List,
}

InitList :: proc(list: ^List) {
	list.prev = list
	list.next = list
}

InsertIntoList :: proc(list: ^List, elm: ^List) {
	elm.prev = list
	elm.next = list.next
	list.next = elm
	elm.next.prev = elm
}

RemoveFromList :: proc(elm: ^List) {
	elm.prev.next = elm.next
	elm.next.prev = elm.prev
	elm.next = nil
	elm.prev = nil
}

LengthOfList :: proc(list: ^List) -> int {
	e: ^List
	count: int = 0
	e = list.next
	for e != list {
		e = e.next
		count += 1
	}
	return count
}

IsListEmpty :: proc(list: ^List) -> bool {
	return list.next == list
}

InsertListIntoList :: proc(list: ^List, other: ^List) {
	if IsListEmpty(other) do return
	other.next.prev = list
	other.prev.next = list.next
	list.next.prev = other.prev
	list.next = other.next
}

ForEachInList :: proc(
	pos: ^^$T,
	head: ^List,
	$member: string,
	direction: IterationDirection,
) -> (
	^T,
	bool,
) {
	if pos^ == nil {
		pos^ = container_of(head.next if direction == .Forward else head.prev, T, member)
	}
	list := (^List)(uintptr(pos^) + offset_of_by_string(T, member))
	if list^ == head^ do return nil, false
	pp := pos^
	pos^ = container_of(list.next if direction == .Forward else list.prev, T, member)
	return pp, true
}

SafeForEachInList :: proc(
	pos: ^^$T,
	tmp: ^^$Y,
	head: ^List,
	$member: string,
	direction: IterationDirection,
) -> (
	^T,
	bool,
) {
	if pos^ == nil {
		pos^ = container_of(head.next if direction == .Forward else head.prev, T, member)
	}
	link := (^List)(uintptr(pos^) + offset_of_by_string(T, member))
	tmp^ = container_of(link.next if direction == .Forward else link.prev, Y, member)
	if link^ == head^ do return nil, false
	pos^ = tmp^
	pp := tmp^
	tmp^ = container_of(link.next if direction == .Forward else link.prev, Y, member)
	return pp, true
}

IterationDirection :: enum {
	Forward,
	Backward,
}
