class Periphery < Formula
  desc "Tool to identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/1.4.0.tar.gz"
  sha256 "a47920cde9584547d46c8b1b9207ba06577ecb2cb25b21dceaeb5cad8d55a82d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2decb5311abfd64fa92c739dd39455234d9ce992f9a38ec3d9f75929e39138c" => :mojave
    sha256 "dfcd4f79eb4e6053c02e4c4d23c69e3c054aa09e9597397c7dbc3f02e87b685a" => :high_sierra
  end

  depends_on :xcode => "10.1"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/periphery"
  end
end
