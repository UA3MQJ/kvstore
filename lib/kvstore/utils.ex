#Здесь можно собрать вспомогательные функци

defmodule KVstore.Utils do
  def to_json(data) do
    Poison.encode!(data)
  end

  def from_json(json) do
    listify =
      fn
        (list) when is_list(list) -> list;
        (other) -> [other]
      end

    replace =
      fn (map, key) ->
        { val, map } = Map.pop(map, key)
        Map.put(map, String.to_atom(key), val)
      end

    replace_all =
      fn (map) ->
        map
        |> replace.("key")
        |> replace.("value")
        |> replace.("ttl")
      end

    json
    |> Poison.Parser.parse!
    |> listify.()
    |> Enum.map(replace_all)
  end

  def valid_data(%{ key: key, value: value, ttl: ttl }) do
    is_binary(key) and is_binary(value) and is_integer(ttl) and ttl >= 0
  end

  def valid_data(_) do
    false
  end
end
