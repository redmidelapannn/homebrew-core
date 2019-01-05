class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://deb.debian.org/debian/pool/main/t/tree/tree_1.8.0.orig.tar.gz"
  sha256 "715d5d4b434321ce74706d0dd067505bb60c5ea83b5f0b3655dae40aa6f9b7c2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "84493c787178633074f88ddc7f9cd7f34cf2009bec3b51036aa9f780d0ab6d3c" => :mojave
    sha256 "ccaa11704313891104105a5dcc16e68fb9653e1c7c47ba0e69a23d14000006a6" => :high_sierra
    sha256 "51135506b0d4c156ad90e82f085ddb0c6d8f44406d09ff2f73918bf796b81b5d" => :sierra
  end

  def install
    ENV.append "CFLAGS", "-fomit-frame-pointer"
    objs = "tree.o unix.o html.o xml.o json.o hash.o color.o file.o strverscmp.o"

    system "make", "prefix=#{prefix}",
                   "MANDIR=#{man1}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "OBJS=#{objs}",
                   "install"
  end

  test do
    system "#{bin}/tree", prefix
  end
end
