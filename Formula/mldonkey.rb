class Mldonkey < Formula
  desc "OCaml/GTK client for the eDonkey P2P network"
  homepage "https://mldonkey.sourceforge.io"
  url "https://github.com/ygrek/mldonkey/releases/download/release-3-1-6/mldonkey-3.1.6.tar.bz2"
  sha256 "1b36b57c05a83c2e363c085bf8e80630884c6c92ecdeffc1ad5e1c39a98e043d"
  revision 2
  head "https://github.com/ygrek/mldonkey.git", :branch => "next"

  bottle do
    rebuild 2
    sha256 "9ce250d83bfadfb8fb4d1ad514c861773fee838637cb3bfa04c423aebd1eb242" => :high_sierra
    sha256 "e99b30eaf2446d790832ce99fee83feb99c9b23c5defb962a06044938f78b303" => :sierra
    sha256 "259d8dce132d154f358e1f527a8ce325e6c84959d045f23d85919829cc7ea5cd" => :el_capitan
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

    system "./configure", "--prefix=#{prefix}", "--disable-magic"
    system "make", "install"
  end

  test do
    system bin/"mlbt", "--help"
  end
end
