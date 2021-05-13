Describe 'stch'
    Describe 'Environment variable substitution'
        Before 'export STCH_TEST="STCH_TEST"'
        After 'unset STCH_TEST'
        It 'substitutes env vars inside {{}}'
            Data "{{STCH_TEST}}"
            When call ./stch
            The stdout should equal STCH_TEST
            The status should be success
        End
        It 'ignores shell variables'
            Data '$STCH_TEST'
            When call ./stch
            The stdout should equal '$STCH_TEST'
            The status should be success
        End
        It 'exits with non-zero on unset env'
            Data '{{FOO}}'
            When call ./stch
            The status should be failure
        End
    End
    Describe 'command substitution'
        It 'substitutes command output inside {{!}}'
            Data '{{!echo 1}}'
            When call ./stch
            The stdout should equal '1'
            The status should be success
        End
        It 'exits with non-zero on invalid command'
            Data '{{!foo}}'
            When call ./stch
            The stderr should include 'foo: not found'
            The status should be failure
        End
    End
End
