---
title: "Don't embed pointers"
date: 2023-08-06
draft: false
tags: [golang]
---
In Go, it's important to be aware of potential bugs when embedding pointers within structs. This article explores such a scenario and provides alternative solutions to avoid confusion and errors.
<!--more-->
## Can you spot the bug in the following code?
```go
package main

import "fmt"

type BookMetaInfo struct {
	IsBestseller bool
	Rating      float64
}

type Book struct {
	*BookMetaInfo
	Title  string
	Author string
}

func main() {
	book := GetBook()

	if book.Rating > 4.5 { // line 19
		book.IsBestseller = true
	}

	fmt.Printf("Book %+v:", book)
}

func GetBook() Book {
	return Book{
		Title:  "The Great Gatsby",
		Author: "F. Scott Fitzgerald",
	}
}
```

When you run this program, it crashes with a nil pointer dereference error on line 19. 
```panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x8 pc=0x482c99]

goroutine 1 [running]:
main.main()
	/tmp/sandbox717552125/prog.go:19 +0x59
```
[Playground](https://go.dev/play/p/u7mekOcO7r8)

But how is that possible? Both `Book` and `Raiting` are not pointers. I think you already guessed what's causing the issue by the name of this article. This occurs because ﻿`BookMetaInfo` is embedded as a pointer within the ﻿Book struct.

## Identifying the Issue
So does it mean that all fields inside `BookMetaInfo` are pointers? To address the issue, you might consider adding a ﻿nil check:

```go
package main

import "fmt"

type BookMetaInfo struct {
	IsBestseller bool
	Rating      float64
}

type Book struct {
	*BookMetaInfo
	Title  string
	Author string
}

func main() {
	book := GetBook()

	if book.Rating != nil && book.Rating > 4.5 { // <-- add nil check
		book.IsBestseller = true
	}

	fmt.Printf("Book: %+v", book)
}

func GetBook() Book {
	return Book{
		Title:  "The Great Gatsby",
		Author: "F. Scott Fitzgerald",
	}
}
```
[Playground](https://go.dev/play/p/NhgnC92u00i)

But now if you run this program it will lead to another error:
`./prog.go:19:21: invalid operation: book.Rating != nil (mismatched types float64 and untyped nil)`

What the hell? We can't reference `Rating` field because it's nil and we can't check it for `nil` because it's not a pointer. What should we do?

## Possible Solution
To correctly determine if ﻿`Rating` exist, it is necessary to check whether ﻿`BookMetaInfo` itself is ﻿not `nil`:
```go
package main

import "fmt"

type BookMetaInfo struct {
	IsBestseller bool
	Rating      float64
}

type Book struct {
	*BookMetaInfo
	Title  string
	Author string
}

func main() {
	book := GetBook()

	if book.BookMetaInfo != nil && book.Rating > 4.5 { // <-- add check BookMetaInfo is not nil
		book.IsBestseller = true
	}

	fmt.Printf("Book: %+v", book) // Book: {BookMetaInfo:<nil> Title:The Great Gatsby Author:F. Scott Fitzgerald}
}

func GetBook() Book {
	return Book{
		Title:  "The Great Gatsby",
		Author: "F. Scott Fitzgerald",
	}
}

```

It fixes the problem, but I hope that you agree with me that this check is not obvious. If you encounter this code for the first time and are not familiar with the Book struct type yet, you may think that checking a field that we don't use is redundant, and removing it will not cause any compile issues. Linters also won't help here. At least, I'm not aware of such a linter.

## Propper Solution
All above issues can be simply avoided. Just don't embed pointer.

To prevent confusion and errors caused by embedding pointers, two alternative approaches can be adopted.

1. Embed ﻿BookMetaInfo as a value:
```go
type BookMetaInfo struct {
	IsBestseller bool
	Rating      float64
}

type Book struct {
	BookMetaInfo
	Title  string
	Author string
}

func main() {
	book := GetBook()

	if book.Rating > 4.5 { // <-- all good
		book.IsBestseller = true
	}
	
	// ...

}
```

2. Or, as in our case, since `BookMetaInfo` is optional I would leave it as a pointer but explicitly set it as a separate field. This would remove all confusion.
```go
type BookMetaInfo struct {
	IsBestseller bool
	Ratings      float64
}

type Book struct {
	MetaInfo *BookMetaInfo // <-- Metainfo is optional field
	Title  string
	Author string
}

func main() {
	book := GetBook()

	if book.MetaInfo != nil && book.MetaInfo.Rating > 4.5 { // <-- now check is more obvious
		book.MetaInfo.IsBestseller = true
	}
	
	// ...

}
```

I hope that you learned something new, and this article will save you from confusing errors in production.

Have you encountered this problem? In what cases is an embedded struct pointer necessary? Leave a comment, let's discuss.