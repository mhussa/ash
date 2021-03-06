defmodule Ash.Test.Resource.ValidationsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  defmacrop defposts(do: body) do
    quote do
      defmodule Post do
        @moduledoc false
        use Ash.Resource

        attributes do
          uuid_primary_key :id

          attribute :name, :string
          attribute :contents, :string
        end

        unquote(body)
      end
    end
  end

  describe "representation" do
    test "validations are persisted on the resource properly" do
      defposts do
        validations do
          validate present([:name, :contents], at_least: 1)
        end
      end

      assert [
               %Ash.Resource.Validation{
                 validation:
                   {Ash.Resource.Validation.Present,
                    [attributes: [:name, :contents], at_least: 1]}
               }
             ] = Ash.Resource.validations(Post)
    end

    test "Validation descriptions are allowed" do
      defposts do
        validations do
          validate present([:name, :contents], at_least: 1),
            description: "require one of name/contents"
        end
      end

      assert [
               %Ash.Resource.Validation{description: "require one of name/contents"}
             ] = Ash.Resource.validations(Post)
    end
  end
end
