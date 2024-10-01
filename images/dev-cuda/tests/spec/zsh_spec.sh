Describe "Zsh Availability"
    It "Zsh is installed"
        When call zsh --version
        The output should include "zsh"
    End

    It "Python is installed"
        When call zsh -c "python --version"
        The output should include "Python"
    End

    It "Pyenv is installed"
        When call zsh -c "ls $HOME/.pyenv > /dev/null"
        The status should be success
    End
End
