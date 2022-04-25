defmodule DatabasesWeb.SearchController do
  use DatabasesWeb, :controller

  def index_with_lang(conn, params) when not(is_map_key(params, "term")) do
    index_with_lang(conn, Map.put(params, "term", "*"))
  end

  def index_with_lang(conn, %{"term" => term, "lang" => lang}) do
    result = Jason.encode!(Databases.Resource.Search.query(term, lang))
    text conn, result
  end
end