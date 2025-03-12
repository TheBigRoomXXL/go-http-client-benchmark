package main

import (
	"fmt"
	http "net/http"
	"os"
	"strconv"
	"time"
)

func main() {
	delay, err := strconv.Atoi(os.Args[1])
	if err != nil {
		panic(err)
	}
	size, err := strconv.Atoi(os.Args[2])
	if err != nil {
		panic(err)
	}
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		time.Sleep(time.Duration(delay) * time.Millisecond)
		body := make([]byte, size*1024)
		for i := range body {
			body[i] = 'A'
		}
		w.Write(body)
	})

	fmt.Println(http.ListenAndServe(":8888", nil))
}
