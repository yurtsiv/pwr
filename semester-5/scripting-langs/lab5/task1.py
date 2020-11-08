def test():
  print("Enter a string:")
  string = input()

  is_palindrome = string == string[::-1]
  print("Is palindrome: " + str(is_palindrome))

while True:
  test()