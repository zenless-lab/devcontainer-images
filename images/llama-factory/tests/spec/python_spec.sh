Describe "Python Availability"
  It "Python is installed"
    When call python --version
    The output should include "Python"
  End
End
