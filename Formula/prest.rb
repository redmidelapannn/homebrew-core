class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v0.3.4.tar.gz"
  sha256 "cc45eb5de17a1957124545e11ae6dcc6e3957e9d5e9b06acf37a341113963829"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "45be2821fcaa9e3d978d041b91ae6157306ee73f6924b0cb0c7ad7e4eb2b3254" => :catalina
    sha256 "add8f9d367f6b9e07f9d5bbc34c04f40c6cdc466686ca8ec20a6b12dd72469a5" => :mojave
    sha256 "da93fbcf463b66d993f32b7b03919f453157883cbd8a281118f7b56687ffe475" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
           "-s -w -X github.com/prest/helpers.PrestVersionNumber=#{version}",
           "-trimpath",
           "-o", bin/"prest"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prest version")
  end
end
