defmodule WorkoutDemo.UserTest do
  use WorkoutDemo.ModelCase

  alias WorkoutDemo.User

  @valid_attrs %{name: "Coby Benveniste", email: "coby.benveniste@gmail.com", password_hash: "thisisapassword", description: "some content", latitude: 43.0387105, longitude: -87.9074701, location: %Geo.Point{coordinates: {-87.9074701, 43.0387105}, srid: 4326}}
  @invalid_attrs %{name: "Coby Benveniste", email: "a fake email", password_hash: "thisisapassword", description: "some content", latitude: 900, longitude: 1450}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
