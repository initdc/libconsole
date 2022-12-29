# frozen_string_literal: true

require_relative "raw"

class MyClass
  include Libconsole::Linux::Raw
end

linux = MyClass.new
linux.default

url = {
  host: "localhost",
  path: "/"
}

arr = %w[apples oranges bananas]

href = {
  url: url,
  query: "l=ruby"
}

comp = {
  query: "l=ruby",
  url: url,
  arr: arr
}

xml = `
    <table id="producttable">
        <thead>
        <tr>
            <td>UPC_Code</td>
            <td>Product_Name</td>
        </tr>
        </thead>
        <tbody>
        <!-- existing data could optionally be included here -->
        </tbody>
    </table>
`

linux.info("log")
linux.info("log")
linux.clear

linux.info("log")

linux.info
linux.info(true)
linux.info(false)
linux.info(1)
linux.info(1.1)
linux.info(nil)
linux.info("hello", "world")
linux.info("hello", ["world"], "!")

linux.info("info")
linux.warn("warn")
linux.err("err")
linux.notice("notice")
linux.crit("crit")
linux.alert("alert")
linux.emerg("emerg")

linux.assert(false, "assert")
linux.assert(true, "assert")

linux.count_reset("count")
linux.count

3.times do
  linux.count("count")
end
linux.count_reset("count")
linux.count("count", "bb", "cc")

linux.time_end("time")
linux.time("time")

linux.count_reset
linux.time
linux.time_log

arr = []

20.times do
  linux.time_log("time", arr)
  # fork { linux.count }
  sleep 0.01
  arr.push("a")
  # Process.wait
end

linux.time_end("time")
linux.time_log
linux.time_log("time")
linux.time_log