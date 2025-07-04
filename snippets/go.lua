local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
return {
  s("ticker", {
    t { "tickerInterval := " },
    i(1, "1"),
    t { "*time.Second", "" },
    t { "ticker := time.NewTicker(tickerInterval)", "defer ticker.Stop()", "" },
    t { "for range ticker.C {", "\t" },
    i(0, "// TODO: task to run on each tick"),
    t { "", "}" },
  }),
  s(
    { trig = "jsonPrint", dscr = "print struct as JSON" },
    fmt(
      [[
    	b, err := json.MarshalIndent({}, "", "\t")
    	if err != nil {{
        	{}
    	}}
    	fmt.Println(string(b))
    	]],
      { i(1, "structName"), i(2, "return nil, err") }
    )
  ),
  s(
    { trig = "pf", dscr = 'fmt.Printf("$1\n", $2)' },
    fmt(
      [[
			fmt.Printf("{}\n", {})
			]],
      { i(1, "%v"), i(2, "x") }
    )
  ),
  s({ trig = "readinlines", dscr = "Read lines from filepath to slice of strings" }, {
    i(1, "f"),
    t ", err := os.Open(",
    i(2, "inFilePath"),
    t { ")", "if err != nil {", "\tlog.Fatal(err)", "}", "defer " },
    i(1, "f"),
    t { ".Close()", "sc := bufio.NewScanner(f)", "" },
    i(3, "lines"),
    t { " := []string{}", "for sc.Scan() {", "\t" },
    i(3, "lines"),
    t " = append(",
    i(3, "lines"),
    t { ", sc.Text())", "}" },
  }),
  s({ trig = "openwrite", dscr = "Open a file for writing/reading" }, {
    i(1, "outfile"),
    t ", err := os.OpenFile(",
    i(2, "path"),
    t ", ",
    i(3, "os.O_CREATE|os.O_RDWR"),
    t ", ",
    i(4, "0644"),
    t { ")", "if err != nil {", "\t" },
    i(5, "log.Fatal(err)"),
    t { "", "}", "defer " },
    i(1, "outfile"),
    t ".Close()",
  }),
  s({ trig = "connect", dscr = "Connect to a Tendermint node" }, {
    t { "// Establish a connection to Tendermint node", "nc, err := qredochain.NewNodeConnector(" },
    i(1, "config.HostIP"),
    t '+":"+',
    i(2, "config.Port"),
    t { ", nil)", "if err != nil {", "\tlog.Fatal(err)", "}", "defer nc.Stop()" },
  }),
  s({ trig = "rce", dscr = "Return custom error" }, {
    t 'return fmt.Errorf("',
    i(1, "message"),
    i(2, "%s"),
    t ': %w", ',
    i(3, "var"),
    t ", err)",
  }),
  s({ trig = "rne", dscr = "Return new error" }, {
    t 'return fmt.Errorf("',
    i(1, "error message"),
    t '")',
  }),
  s({ trig = "loglines", dscr = "Log line numbers" }, {
    t "log.SetFlags(log.LstdFlags | log.Lshortfile)",
  }),
  s({ trig = "logtofile", dscr = "Log a message to a file" }, {
    t "func logToFile(",
    i(1, "message"),
    t { " string) {", '\tf, err := os.OpenFile("/home/david/logs/' },
    c(2, { sn(nil, { t '`date +"%d-%m-%Y:%H:%M:%S"`', t ".log" }), t "" }),
    t {
      '", os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0644)',
      "\tif err != nil {",
      "\t\tlog.Fatal(err)",
      "\t}",
      "\tdefer f.Close()",
      "\tw := bufio.NewWriter(f)",
      '\tfmt.Fprintf(w, "%s\\n---\\n", message)',
      "\tw.Flush()",
      "}",
    },
  }),
  s({ trig = "qrlicence", dscr = "Qredo licence block" }, {
    t {
      "/*",
      "Licensed to the Apache Software Foundation (ASF) under one",
      "or more contributor license agreements.  See the NOTICE file",
      "distributed with this work for additional information",
      "regarding copyright ownership.  The ASF licenses this file",
      "to you under the Apache License, Version 2.0 (the",
      '"License"); you may not use this file except in compliance',
      "with the License.  You may obtain a copy of the License at",
      "",
      "  http://www.apache.org/licenses/LICENSE-2.0",
      "",
      "Unless required by applicable law or agreed to in writing,",
      "software distributed under the License is distributed on an",
      '"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY',
      "KIND, either express or implied.  See the License for the",
      "specific language governing permissions and limitations",
      "under the License.",
      "*/",
    },
  }),
  s({ trig = "ignore", dscr = "Mark for compiler ignore" }, {
    t "//go:build test",
  }),
  s(
    { trig = "ma", name = "Main Package", dscr = "Basic main package structure" },
    fmt(
      [[
    package main

    import "fmt"

    func main() {{
      fmt.Printf("%+v\n", {})
    }}
  ]],
      { i(1, '"..."') }
    )
  ),
  s(
    {
      trig = "httpServer",
      name = "HTTP Server (graceful, slog, ServeMux)",
      dscr = "Go HTTP server with graceful shutdown and slog using ServeMux",
    },
    fmt(
      [[
    package main

    import (
      "context"
      "fmt"
      "log/slog"
      "net/http"
      "os"
      "os/signal"
      "syscall"
      "time"
    )

    func main() {{
      logger := slog.New(slog.NewTextHandler(os.Stdout, nil))
      slog.SetDefault(logger)

      mux := http.NewServeMux()
      mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {{
        slog.Info("Received request", "method", r.Method, "path", r.URL.Path)
        fmt.Fprintf(w, "Hello, {}!")
      }})

      srv := &http.Server{{
        Addr:         ":{}",
        Handler:      mux,
        ReadTimeout:  5 * time.Second,
        WriteTimeout: 10 * time.Second,
        IdleTimeout:  120 * time.Second,
      }}

      // Channel to listen for interrupt or terminate signals
      stop := make(chan os.Signal, 1)
      signal.Notify(stop, syscall.SIGINT, syscall.SIGTERM)

      go func() {{
        slog.Info("Starting server", "addr", srv.Addr)
        if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {{
          slog.Error("Server error", "err", err)
        }}
      }}()

      <-stop
      slog.Info("Shutting down server...")

      ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
      defer cancel()

      if err := srv.Shutdown(ctx); err != nil {{
        slog.Error("Server forced to shutdown", "err", err)
      }} else {{
        slog.Info("Server exited gracefully")
      }}
    }}
  ]],
      {
        i(1, "world"),
        i(2, "8080"),
      }
    )
  ),
  s(
    { trig = "jsonRespHandler", name = "JSON Response Handler", dscr = "Decode request and respond with JSON" },
    fmt(
      [[
    func {}(w http.ResponseWriter, r *http.Request) {{
      var p {}
      decoder := json.NewDecoder(r.Body)
      if err := decoder.Decode(&p); err != nil {{
        http.Error(w, "invalid JSON", http.StatusBadRequest)
        return
      }}
      defer r.Body.Close()

      resp := {}{{Name: p.Name, Index: p.Index * 2}}
      w.Header().Set("Content-Type", "application/json")
      if err := json.NewEncoder(w).Encode(resp); err != nil {{
        http.Error(w, "failed to encode response", http.StatusInternalServerError)
      }}
    }}
  ]],
      {
        i(1, "processInputReturnAsJSON"), -- function name
        i(2, "Payload"), -- request payload type
        i(3, "ResponsePayload"), -- response payload type
      }
    )
  ),
}
