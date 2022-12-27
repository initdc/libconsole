# frozen_string_literal: true

require_relative "js"

class MyClass
  include Libconsole::Lang::JS
end

console = MyClass.new
console.default

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

console.log("log")
console.log("log")
console.clear

console.log("log")

console.log
console.log(true)
console.log(false)
console.log(1)
console.log(1.1)
console.log(nil)
console.log("hello", "world")
console.log("hello", ["world"], "!")

console.info("info")
console.warn("warn")
console.error("error")
console.debug("debug")

console.assert(false, "assert")
console.assert(true, "assert")

console.count_reset("count")

3.times do
  console.count("count")
end
console.count_reset("count")
console.count("count")

console.dir(href)
console.log(url)

console.dirxml(comp)

console.group
console.group("label")
console.log("a")
console.group_collapsed("label")
console.log("a")
console.log("a")
console.group_end
console.group_end
# console.group_end

puts console.red

puts "is red?"

console.table(arr)
console.info(arr)

console.table(url)
console.table(href)
console.table(comp)

console.time_end("time")
console.time("time")

3.times do
  console.time_log("time")
end
console.time_end("time")
console.time_log("time")
console.time_log("time")

def foo(c)
  c.trace("foo")
  def bar(c)
    c.trace
  end
  bar(c)
end

foo(console)
