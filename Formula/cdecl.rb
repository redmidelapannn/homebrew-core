class Cdecl < Formula
  desc "Turn English phrases to C or C++ declarations"
  homepage "https://cdecl.org/"
  url "https://cdecl.org/files/cdecl-blocks-2.5.tar.gz"
  sha256 "9ee6402be7e4f5bb5e6ee60c6b9ea3862935bf070e6cecd0ab0842305406f3ac"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "49ba6e45dc18459f9df55b236df5b0da4ce4429476fa9b10e7a42c0871f7e77f" => :sierra
    sha256 "793dedd8ac069707174cc76b3ae975bacc569950db03907959dec735ff14e8ee" => :el_capitan
    sha256 "2717faef123635e8ea4e80d538c0c035073630d730699c96ad935b7a166fca80" => :yosemite
  end

  def install
    # Fix namespace clash with Lion's getline
    inreplace "cdecl.c", "getline", "cdecl_getline"

    bin.mkpath
    man1.mkpath

    ENV.append "CFLAGS", "-DBSD -DUSE_READLINE -std=gnu89"

    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LIBS=-lreadline",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    assert_equal "declare a as pointer to int",
                 shell_output("#{bin}/cdecl explain int *a").strip
  end
end
