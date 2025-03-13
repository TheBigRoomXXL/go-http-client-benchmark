package main

import (
	"fmt"
	http "net/http"
	"os"
	"strconv"
	"sync"
	"time"
)

func main() {
	lock := sync.RWMutex{}
	delay, err := strconv.Atoi(os.Args[1])
	if err != nil {
		panic(err)
	}
	size, err := strconv.Atoi(os.Args[2])
	if err != nil {
		panic(err)
	}
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		lock.RLock()
		d := delay
		s := size
		lock.RUnlock()
		time.Sleep(time.Duration(d) * time.Millisecond)
		body := make([]byte, s*1024)
		for i := range body {
			body[i] = 'A'
		}
		w.Write(body)
		fmt.Println("Request served")
	})

	http.HandleFunc("/config", func(w http.ResponseWriter, r *http.Request) {
		newDelay, err := strconv.Atoi(r.URL.Query().Get("delay"))
		if err != nil {
			w.WriteHeader(400)
			w.Write([]byte("Bad Request\n"))
			fmt.Println("Config not updated:", err)
			return
		}
		newSize, err := strconv.Atoi(r.URL.Query().Get("size"))
		if err != nil {
			w.WriteHeader(400)
			w.Write([]byte("Bad Request\n"))
			fmt.Println("Config not updated:", err)
			return
		}
		lock.Lock()
		delay = newDelay
		size = newSize
		lock.Unlock()
		w.WriteHeader(200)
		w.Write([]byte("OK\n"))
		fmt.Println("Config updated")
	})

	fmt.Println("Listening on :8888")
	fmt.Println(http.ListenAndServe(":8888", nil))
}
