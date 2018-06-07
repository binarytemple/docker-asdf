#!/bin/bash

awk -F',' '!/version/{print $1 " " $2}' combinations.txt | \
    while read erl elx ; 
        do docker build \
            --build-arg erlang_version=$erl \
            --build-arg elixir_version=$elx \
            -t bryanhuntesl/asdf-erlang-elixir:${erl}-${elx} \
            . 
            docker push bryanhuntesl/asdf-erlang-elixir:${erl}-${elx}
        done
