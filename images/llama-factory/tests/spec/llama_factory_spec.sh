Describe "LLaMA Factory Availability"
  It "Directory exists"
    When call ls /workspace/llama-factory
    The output should include "pyproject.toml"
    The output should include "README.md"
    The output should include "src"
  End
End
