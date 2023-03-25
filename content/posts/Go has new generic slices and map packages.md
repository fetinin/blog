---
title: "Go has new generic slices and map packages"
date: 2023-03-05
draft: false
tags: [golang]
---
Since the introduction of generics in Go 1.18, there have been discussions about adding new helper functions to the standard library to cover most frequent operations. After more than a year, two new libraries with generics will be added[^1][^2] into the Go standard library starting from Go 1.21.
<!--more-->
You can already find them here:
https://pkg.go.dev/golang.org/x/exp/slices
https://pkg.go.dev/golang.org/x/exp/maps

Or install via:
```bash
go get golang.org/x/exp
```

## Examples
Here are some examples of how you can improve your codebase with the new slices library.
### Copy a slice
```go
// Before
a := []int{1, 2, 3}  
b := make([]int, len(a))  
copy(b, a)

// after
a := []int{1, 2, 3}  
b := slices.Clone(a)
```

### Check slice contains value 
```go
// Before
a := []int{1, 2, 3}  
toFind := 2  
for _, v := range a {  
   if v == toFind {  
      fmt.Printf("slice 'a' contains %v", toFind), 2)  
      break
   }
}

// After
a := []int{1, 2, 3}  
toFind := 2  
if slices.Contains(a, toFind) {  
   fmt.Printf("slice 'a' contains %v", toFind), 2)  
}
```

### Insert into slice
```go
// Before
a := []int{1, 2, 3}  
val, insertIdx := 4, 1  
// disclaimer: not the best way to insert into a slice  
b := append(a[:insertIdx], append([]int{val}, a[insertIdx:]...)...) // [1 4 2 3]

// After
a := []int{1, 2, 3}  
val, insertIdx := 4, 1  
b := slices.Insert(a, insertIdx, val)
```

### Check slices are equal
```go
// Before
a := []int{1, 2, 3}  
b := []int{1, 2, 3}  
  
areEqual := true  
for i, _ := range a {  
   if a[i] != b[i] {  
      areEqual = false  
      break   }  
}
fmt.Print(areEqual) // true

// After
a := []int{1, 2, 3}  
b := []int{1, 2, 3}  
areEqual := slices.Equal(a, b)
fmt.Print(areEqual) // true
```

### Grow slice
```go
// Before
a := []int{1}  
n := 5  
a = append(a[:cap(a)], make([]int, n)...)[:len(a)]
fmt.Printf("slice cap: %v", cap(a)) // 6
fmt.Printf("slice len: %v", len(a) //  1

// After
a := slices.Grow([]int{1}, 5)  
fmt.Printf("slice cap: %v", cap(a)) // 6
fmt.Printf("slice len: %v", len(a) //  1
```


Sentence about that this is not full all library API is covered here, read more at https://pkg.go.dev/golang.org/x/exp/slices

[^1]: https://github.com/golang/go/issues/57433
[^2]: https://github.com/golang/go/issues/57436