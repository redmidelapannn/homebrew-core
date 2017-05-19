class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://api.nuget.org/packages/autorest.0.17.3.nupkg"
  sha256 "b3f5b67ae1a8aa4f0fd6cf1e51df27ea1867f0c845dbb13c1c608b148bd86296"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e3ad8ac2dff970f0f17ea5c5afdaf024d56cdda5528b35e9a0e5f61224f6eef4" => :sierra
    sha256 "35e43e377dea0624c28583986c85cf5fd30c1fe6131edce4c1b9bd0b88f52f0c" => :el_capitan
    sha256 "35e43e377dea0624c28583986c85cf5fd30c1fe6131edce4c1b9bd0b88f52f0c" => :yosemite
  end

  depends_on "mono" => :recommended

  resource "swagger" do
    url "https://raw.githubusercontent.com/Azure/autorest/764d308b3b75ba83cb716708f5cef98e63dde1f7/Samples/petstore/petstore.json"
    sha256 "8de4043eff83c71d49f80726154ca3935548bd974d915a6a9b6aa86da8b1c87c"
  end

  def install
    libexec.install Dir["tools/*"]
    (bin/"autorest").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/AutoRest.exe "$@"
    EOS
  end

  test do
    resource("swagger").stage do
      assert_match "Finished generating CSharp code for petstore.json.",
        shell_output("#{bin}/autorest -n test -i petstore.json")
    end
  end
end
