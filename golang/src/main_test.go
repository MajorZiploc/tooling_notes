package main

import (
    "testing"
    "github.com/stretchr/testify/assert"
)

func TestAdd(t *testing.T) {
    result := 2 + 3
    assert.Equal(t, 5, result, "The result should be 5")
}
