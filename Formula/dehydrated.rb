class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.io"
  url "https://github.com/lukas2511/dehydrated/archive/v0.6.2.tar.gz"
  sha256 "163384479199f06f59382ceb6291a299567a2f4f0b963b9b61f2db65a407e80e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1bd58b96b46203f77ed8015341d0ec00bee666c86da39bc588ffe40f640b4e1e" => :mojave
    sha256 "1bd58b96b46203f77ed8015341d0ec00bee666c86da39bc588ffe40f640b4e1e" => :high_sierra
    sha256 "a7cf2c8918f9b665b7586b12b4ddf6df11668138b3c7d582cc02e8264cf58477" => :sierra
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/lukas2511/dehydrated").install buildpath.children
    cd "src/github.com/lukas2511/dehydrated" do
      bin.install "dehydrated"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
