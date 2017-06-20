# Currying


[![hex.pm version](https://img.shields.io/hexpm/v/currying.svg)](https://hex.pm/packages/currying)
[![Build Status](https://travis-ci.org/Qqwy/elixir_currying.svg?branch=master)](https://travis-ci.org/Qqwy/elixir_currying)

The Currying library allows you to partially apply (or '[curry](https://en.wikipedia.org/wiki/Currying)') _any_ Elixir function, in a very transparent way.

This is useful if you only know what part of the arguments are going to be at this time. 
The main advantage of Currying over Elixir's normal anonymous function syntax, is that you can stepwise insert more and more arguments, instead of having to supply them right away. 

This becomes even more useful when working with algebraic data types; Currying allows things like applicative functors to exist.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  - Add `currying` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:currying, "~> 0.1.0"}]
    end
    ```


## Usage

To use this functionality elsewhere, call `use Currying` from within your code.

If you want to use the shorthand curry operator `~>` for convenience, call `use Currying, operator: true`.

## How to Curry

You can create a curried version of a function by using `curry/1`. It is also possible to create already-partially-applied functions 
by using `curry/2` or `curry_many/2`.

Application of these functions can be done by calling the functions with a new argument, such as:

  ```elixir
  iex> enum_map = curry(&Enum.map/2)
  iex> partially_applied_enum_map = enum_map.([1,2,3])
  iex> results = partially_applied_enum_map.(fn x -> x*x end)
  [1,4,9]    
  ```

It is also possible to call `curry` or `curry_many` again on an already-curried function, without any problem.

When new arguments are passed to these functions, the partially applied function will be filled in one-by-one.



## History

- 1.0.3 - Speed improvements.
- 1.0.2 - Stable Release
