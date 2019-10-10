class Arturo < Formula
  desc "Simple, modern and powerful interpreted programming language"
  homepage "https://arturo-lang.io"
  url "https://github.com/arturo-lang/arturo/archive/v0.3.6.tar.gz"
  sha256 "c6c584f9e0fed0d82ecb81f2bf7481fe1b6b2918fe6bc588f8c9f851c68ea18c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c177890fa4baf58def9bbb4e6fe9295868a757594702ea160ef9e913cd9fe65b" => :mojave
    sha256 "7068963b635129ef5335af1ed5c7022ed3133ac76429094a1eddbc1c708c7a1a" => :high_sierra
  end

  depends_on "dmd" => :build
  depends_on "bison" => :build
  depends_on "dub" => :build
  depends_on "cairo" => :build
  depends_on "atk" => :build
  depends_on "gtk+3" => :build
  depends_on "jpeg" => :build
  
  depends_on macos: [:high_sierra, :mojave]

  def install
    system "dub", "build", "--build=release", "--compiler=dmd"
    bin.install "arturo"
  end

  test do
    system bin/"arturo", "--version"
  end
end
