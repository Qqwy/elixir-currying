defmodule Currying do
  @moduledoc """
  The Currying module allows you to partially apply (or 'curry') functions.
  To use this functionality elsewhere, call `use Currying` from within your code.

  If you want to use the shorthand curry operator `~>` for convenience, call `use Currying, operator: true`.
  
  ## How to Curry

  You can create a curried version of a function by using `curry/1`. It is also possible to create already-partially-applied functions 
  by using `curry/2` or `curry_many/2`.

  Application of these functions can be done by calling the functions with a new argument, such as:

      iex> enum_map = curry(&Enum.map/2)
      iex> partially_applied_enum_map = enum_map.([1,2,3])
      iex> results = partially_applied_enum_map.(fn x -> x*x end)
      [1,4,9]    
  
  It is also possible to call `curry` or `curry_many` again on an already-curried function, without any problem.

  When new arguments are passed to these functions, the partially applied function will be filled in one-by-one.

  """

  defmacro __using__(opts) do
    if opts[:operator] do
      quote do
        import Currying
      end
    else
      quote do
        import Currying, except: [~>: 2]
      end
    end
  end


  @doc """
  Creates a curried version of the given function `fun`, and fills in all arguments in the `arguments` list.

  If the arity of `fun` matches the amount of arguments, it will be applied.
  If the arity of `fun` is more than the amount of arguments, a curried version of this function will be returned.

  When you pass more arguments into `curry_many` than the original curried function supported, an error will be thrown.


  ## Examples

      iex> pythagorean_triple? = fn x, y, z -> x*x+y*y == z*z end
      iex> curry_many(pythagorean_triple?, [3,4,5])
      true
      iex> curry_many(pythagorean_triple?, [3,4]).(5)          # This is equivalent to the statement above.
      iex> curry_many(pythagorean_triple?, [3]).(4).(5)        # This is equivalent to the statement above.
      iex> curry_many(pythagorean_triple?, []).(3).(4).(5)     # This is equivalent to the statement above.
      iex> curry(pythagorean_triple?).(3).(4).(5)              # This is equivalent to the statement above.
      iex> curry(pythagorean_triple?) |> curry_many([3,4,5])   # This is equivalent to the statement above.
      iex> curry(pythagorean_triple?).(3) |> curry_many([4,5]) # This is equivalent to the statement above.
      iex> curry(pythagorean_triple?, 3) |> curry_many([4,5])  # This is equivalent to the statement above.
      true
  """
  @spec curry_many(function, list) :: any 
  def curry_many(fun, arguments)
  def curry_many(fun, []), do: curry(fun)

  def curry_many(fun, arguments = [h | t]) when is_function(fun) do
    {:arity, arity} = :erlang.fun_info(fun, :arity) 
    argument_length = length(arguments)

    case arity - argument_length do
      0 ->
        Kernel.apply(fun, arguments)
      num when num < 0 ->
      # Try to apply one by one; function probably has been curried multiple times.
        if is_function(fun, 1) do
          curried_fun = fun.(h)
          if is_function(curried_fun, 1) do
            curry_many(curried_fun, t)
          else
            # not curryable.
            raise BadArityError.exception(function: curried_fun, args: t) #"Too many parameters supplied to `curry_many`!"
          end
        else
          # not curryable
          raise BadArityError.exception(function: fun, args: arguments) #"Too many parameters supplied to `curry_many`!"
        end
      _ ->
        fn
          later_argument ->
            curry_many(fun, arguments ++ [later_argument])
        end
    end
  end

  @doc """
  Creates a curried version of the given function `fun`.

  This curried version only responds to a single argument. When it is called using this argument, 
  the first argument of the original function is filled in, and a new curried version of the function is returned.

  When enough arguments have been passed in so that the amount of arguments matches the arity of the original function,
  this function is called with the specified arguments, and the result of that function is returned.

  ## Examples

      iex> plus = &Kernel.+/2
      iex> plus.(1)
      ** (BadArityError) &:erlang.+/2 with arity 2 called with 1 argument (1)
      iex> curried_plus = curry(&Kernel.+/2)
      iex> partially_applied_plus = curried_plus.(1)
      iex> partially_applied_plus.(2)
      3

  """
  @spec curry(function) :: (any -> any)
  def curry(fun) when is_function(fun) do
    fn 
      later_argument ->
        curry_many(fun, [later_argument])
    end
  end


  @doc """
  Creates a curried version of the given function `fun`, with its first `argument` already filled in.
  
  
  """
  @spec curry(function, any) :: any
  def curry(fun, argument)

  def curry(fun, argument) when is_function(fun) do
    curry_many(fun, [argument])
  end


  @doc """
  Infix variant of `curry(fun, argument)`
  
  To enable the usage of this operator, call `use Currying, operator: true`.
  """
  @spec function ~> any :: any
  def fun ~> argument when is_function(fun) do
    curry(fun, argument)
  end
end

