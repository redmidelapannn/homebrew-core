class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.20.1.tar.gz"
  sha256 "dd54393661602bb989ee880f14c41f7a7b47a153777999509127459edae52e47"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "15197cf7829bcb109d49ce9dce29a3ea82e8333d169aafd0113cb263c81d5caf" => :mojave
    sha256 "6bc703b06ecd84f196ff03107ae6b5724c5fe3d6429fd890e435ffe16521893a" => :high_sierra
    sha256 "53b4661a6b88b5d4454f7f60e2b71facc7f7950c4eff2a62290ecc6ca83add19" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end
  
  def caveats
    "Follow the instructions at https://direnv.net/docs/hook.md to hook direnv to your shell"
  end
  
  test do
    system bin/"direnv", "status"
  end
end
