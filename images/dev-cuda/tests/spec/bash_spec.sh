Describe "Bash Availability"
    It "Bash is installed"
        When call bash --version
        The output should include "bash"
    End

    It "Python is installed"
        When call bash -c "python --version"
        The output should include "Python"
    End

    It "Pyenv is installed"
        When call bash -c "ls $HOME/.pyenv > /dev/null"
        The status should be success
    End
End
