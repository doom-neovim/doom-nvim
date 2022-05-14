
local function test_refact()
  -- comment inside
  print("hello")
end

-- comment outside
local function my_func()
  test_refact()
end
