defmodule Lightning.SetupUtilsCredentialBodyTest do
  use Lightning.DataCase, async: true

  import Lightning.AdaptorTestHelpers

  alias Lightning.Credentials.Credential
  alias Lightning.Repo
  alias Lightning.SetupUtils

  setup :isolated_adaptors

  setup do
    Enum.each(
      ~w(@openfn/language-common @openfn/language-dhis2 @openfn/language-http),
      &ensure_adaptor/1
    )
  end

  test "demo DHIS2 credential has a body for the root project environment" do
    SetupUtils.setup_demo(create_super: true)

    credential =
      Repo.get_by!(Credential, name: "DHIS2 play")
      |> Repo.preload(:credential_bodies)

    assert [%{name: "main", body: body}] = credential.credential_bodies
    assert body["hostUrl"] == "https://play.dhis2.org/dev"
    assert map_size(body) == 3
  end
end
