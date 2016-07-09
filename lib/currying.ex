defmodule Currying do

  def curry_many(fun, arguments) do
    {:arity, arity} = :erlang.fun_info(fun, :arity) 
    argument_length = length(arguments)
    cond do
      arity < argument_length ->
        raise "Too many parameters supplied to `partially_apply`!"
      arity == argument_length ->
        Kernel.apply(fun, arguments)
      arity > argument_length ->
        fn 
          {:__curry_many__, later_arguments} when is_list(later_arguments) -> 
            curry_many(fun, arguments ++ later_arguments)
          later_argument ->
            curry_many(fun, arguments ++ [later_argument])
        end
    end
  end

  def curry(fun) do
    fn 
      {:__curry_many__, later_arguments} when is_list(later_arguments) -> 
        curry_many(fun, later_arguments)
      later_argument ->
        curry_many(fun, [later_argument])
    end
  end

  def curry(fun, argument) do
    curry_many(fun, [argument])
  end
end

