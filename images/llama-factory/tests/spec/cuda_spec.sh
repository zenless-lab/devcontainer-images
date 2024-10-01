Describe "Is CUDA installed correctly"
  Describe "CUDA Availability"
    It "CUDA is installed"
      When call nvcc --version
      The output should include "release"
    End
  End
End
