class ExpectedParseErrors
  @program1 = 'line 1: and is invalid start for a statement\n
               line 1: Expected EOF, found and\n'

  @program2 = 'line 1: and is invalid start for a statement\n
               line 1: Expected EOF, found and\n
               line 1: Expected newline, found ID\n
               line 1: newline is invalid start for a statement\n
               line 1: Expected EOF, found newline\n '

  @program3 = 'line 2: Expected newline, found ->'

  @program4 = 'line 3: Expected in, found if'

  @program5 = 'line 3: Expected newline, found ID'

  @program6 = 'line 5: Expected newline, found **'


module.exports = ExpectedParseErrors