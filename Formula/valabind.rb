class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "http://radare.org/"
  url "http://www.radare.org/get/valabind-0.10.0.tar.gz"
  sha256 "35517455b4869138328513aa24518b46debca67cf969f227336af264b8811c19"
  revision 1

  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "6a9c255a538f2d8a8e3e0fcdc2eb35626461af9731ada09a6f0720c797e46ee7" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
