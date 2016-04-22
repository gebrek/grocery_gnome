defmodule GroceryGnome.PageController do
  use GroceryGnome.Web, :controller
	plug GroceryGnome.Plug.Authenticate

	alias GroceryGnome.User
	alias GroceryGnome.Password

  def login(conn, _params) do
		if is_nil(conn.assigns.current_user) do
			render(to: session_path(conn, :new))
		else
			 render conn, "homepage.html"
		end
  end

  def home(conn, _params) do
    render conn, "homepage.html"
  end

  def test(conn, _params) do
		mymap = %{}
		#k = 6
		#s = Integer.to_string(k)
		#k = String.to_integer(s)
		#s = Integer.to_string(k)
		#mapitems = Map.put(mymap, s , 6)
		mapitems = Map.put(mymap, 0 , 5)
		
    render conn, "test.html", mapitems: mapitems
  end

	def change(conn, _params) do
		user = conn.assigns.current_user
    changeset = User.changeset(user)
		render(conn, "change.html", changeset: changeset)
  end

  def changepassword(conn, %{"user" => user_params}) do
		
    changeset = User.changeset(conn.assigns.current_user, user_params)
    if changeset.valid? do
			changeset = Password.generate_password(changeset)

			 case Repo.update(changeset) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "User password updated successfully.")
        |> redirect(to: page_path(conn, :home))
      {:error, changeset} ->
        render(conn, "home.html")
    end
    else
      render conn, "change.html", changeset: changeset
    end
  end

end
