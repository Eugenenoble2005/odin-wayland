package wayland
import "core:c"
import "core:fmt"
import "core:testing"
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
	pp := pos^
	pos^ = tmp^
	tmp^ = container_of(link.next if direction == .Forward else link.prev, Y, member)
	return pp, true
}

IterationDirection :: enum {
	Forward,
	Backward,
}

ForEachInArray :: proc(pos: ^^$T, array: ^Array) -> (^T, bool) {
	if pos^ == nil {
		pos^ = auto_cast array.data
	}
	if (array.size == 0) do return nil, false
	if uintptr(pos^) > (uintptr(array.data) + uintptr(array.size)) do return nil, false
	pp := pos^
	pos^ = auto_cast (uintptr(pos^) + uintptr(size_of(T)))
	return pp, true

}

element :: struct {}

@(test)
ArrayIterationTest :: proc(t: ^testing.T) {
	array: Array
	string_array := [?]string{"pizza", "ice cream", "cake", "pie"}
	InitArray(&array)
	defer ReleaseArray(&array)
	for i in string_array {
		p := AddToArray(&array, size_of(string))
		(^string)(p)^ = i
	}
	p: ^string
	count := 0
	for x in ForEachInArray(&p, &array) {
		count += 1
		if count == 4 do testing.expect(t, x^ == "pie")
	}
}

@(test)
ListIterationTest :: proc(t: ^testing.T) {
	using testing
	element :: struct {
		i:    string,
		link: List,
	}
	list: List
	e: ^element
	e1, e2, e3, e4: element
	e1.i = "pizza"
	e2.i = "ice cream"
	e3.i = "cake"
	e4.i = "pie"

	InitList(&list)
	InsertIntoList(list.prev, &e1.link)
	InsertIntoList(list.prev, &e2.link)
	InsertIntoList(list.prev, &e3.link)
	InsertIntoList(list.prev, &e4.link)
	count := 0
	for y in ForEachInList(&e, &list, "link", .Forward) {
		count += 1
		if count == 4 do expect(t, y.i == "pie")

	}
	//reset pointer
	e = nil
	count = 0
	//reverse 
	for x in ForEachInList(&e, &list, "link", .Backward) {
		count += 1
		if count == 4 do expect(t, x.i == "pizza")
	}

}
