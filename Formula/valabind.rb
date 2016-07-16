class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "http://radare.org/"
  url "http://www.radare.org/get/valabind-0.10.0.tar.gz"
  sha256 "35517455b4869138328513aa24518b46debca67cf969f227336af264b8811c19"
  revision 2

  head "https://github.com/radare/valabind.git"

  # Fixes incompatibility with BSD sed in valabind 0.10.0.
  patch do
    url "https://github.com/radare/valabind/pull/38.patch"
    sha256 "ed3573e43799e6635b951d68062c39947383afbf4f2bac2613a21e871b537100"
  end

  bottle do
    cellar :any
    sha256 "910f9c1b08dafba7b2ef26afd31425694162bc6e4b21c192237752f98e803034" => :el_capitan
    sha256 "e109cb3ee53ee1a5328dd00928e2ee942887b8d975393099f1f0803f790d9843" => :yosemite
    sha256 "88e2a91dda17c5a6a19ebcc1b879341eef99f3aaf41b8b0d1161795291625621" => :mavericks
  end

  depends_on "gettext" => :linked
  depends_on "glib" => :linked
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
