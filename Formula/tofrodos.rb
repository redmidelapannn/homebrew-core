class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://www.thefreecountry.com/tofrodos/"
  url "https://tofrodos.sourceforge.io/download/tofrodos-1.7.13.tar.gz"
  sha256 "3457f6f3e47dd8c6704049cef81cb0c5a35cc32df9fe800b5fbb470804f0885f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "50a2687cd3e4530b04dfd72907791d0da18912ffaafc738b01bd38fa6de3d0c9" => :sierra
    sha256 "9013a22cbf305c5ef27d4c1579fd195f4dd6aa9992b3b1e531844be3bae5c84a" => :el_capitan
    sha256 "103d6969f8180a7b9da4783cb0d109d15fe8ef62591b37a46aa9237452fb26d1" => :yosemite
  end

  def install
    cd "src" do
      system "make"
      bin.install %w[todos fromdos]
      man1.install "fromdos.1"
      man1.install_symlink "fromdos.1" => "todos.1"
    end
  end
end
