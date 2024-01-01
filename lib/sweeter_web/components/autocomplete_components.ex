defmodule SweeterWeb.AutocompleteComponents do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias Sweeter.Content.Tag
  import SweeterWeb.Gettext

  @spec autocomplete_bar(any()) :: Phoenix.LiveView.Rendered.t()
  def autocomplete_bar(assigns) do
    assigns = assign(assigns, :tags, Tag.find_tags_to_search())
    ~H"""
    <form phx-change="suggest" phx-submit="search">
      <input id="tags_list" type="text" name="q" list="matches" onchange="populateTags()" placeholder="Add Tags..." />
      <datalist id="matches">
        <%= for match <- @tags do %>
          <option value={match.id}><%= match.label %></option>
        <% end %>
      </datalist>

    </form>
    <div id="associated-tags"></div>
    <script>
    function populateTags(){
      console.log("populate tags")
      let selected_id = document.getElementById("tags_list").value;
      let tags_list = document.getElementById("item_tag_ids").value.split(',')
      let selected_tag = updateSelectedTagsList(tags_list,selected_id);
      let new_list = selected_tag.list

      document.getElementById("item_tag_ids").value = new_list.toString()
      displayTags(new_list)
    }

    function displayTags(new_list){
      let associated = document.getElementById('associated-tags')
      datalist = document.getElementById("matches")
      let options = datalist.getElementsByTagName('option')

      document.getElementById('tags_list').value = ''
      associated.innerHTML = '';

      for (let i = 0; i < options.length; i++) {
        let optionValue = options[i].value
        let optionText = options[i].textContent
        if (new_list.includes(optionValue)) {
          associated.innerHTML += optionText + ', ';
        }
      }
    }
    </script>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: nil, result: nil, loading: false, matches: [])}
  end

  def handle_event("suggest", %{"q" => query}, socket) when byte_size(query) <= 100 do
    tags = Tag.find_tags_to_search()
    {:noreply, assign(socket, matches: tags)}
  end

  def handle_event("search", %{"q" => query}, socket) when byte_size(query) <= 100 do
    send(self(), {:search, query})
    {:noreply, assign(socket, query: query, result: "Searching...", loading: true, matches: [])}
  end

  def handle_info({:search, query}, socket) do
    # {result, _} = System.cmd("dict", ["#{query}"], stderr_to_stdout: true)
    {:noreply, assign(socket, loading: false, result: {}, matches: [])}
  end
end
