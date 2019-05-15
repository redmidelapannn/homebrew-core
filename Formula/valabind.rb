class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.7.1.tar.gz"
  sha256 "b463b18419de656e218855a2f30a71051f03a9c4540254b4ceaea475fb79102e"
  revision 1
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ea9296732f0f4fd3b65d55893bd69f94d5201837b5eb97b1d3ea33e9f6e17f13" => :mojave
    sha256 "06abf35d3a672d9e72c95a2236e460ff044b530963e269e342d7fdeac95d496e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
