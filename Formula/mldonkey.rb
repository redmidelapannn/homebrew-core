class Mldonkey < Formula
  desc "OCaml/GTK client for the eDonkey P2P network"
  homepage "https://mldonkey.sourceforge.io"
  url "https://github.com/ygrek/mldonkey/releases/download/release-3-1-6/mldonkey-3.1.6.tar.bz2"
  sha256 "1b36b57c05a83c2e363c085bf8e80630884c6c92ecdeffc1ad5e1c39a98e043d"
  revision 2
  head "https://github.com/ygrek/mldonkey.git", :branch => "next"

  bottle do
    rebuild 2
    sha256 "e0253a33da34280645a3e498645671b9995348ea63a145a0dd543d5bc43938ea" => :high_sierra
    sha256 "390bb0fbeb9654540ac6a63bb227fa23dd0164565fd9b2b59163ff5c315ebc62" => :sierra
    sha256 "fc1c137089b1ecda75f7ae5619560714b35aa3d0adea29b373fae81a9624e8dd" => :el_capitan
  end

  depends_on "camlp4" => :build
  depends_on "ocaml" => :build
  depends_on "ocaml-num" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libpng"

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat

    ENV.deparallelize

    # Fix compiler selection
    ENV["OCAMLC"] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"mlbt", "--help"
  end
end
