class Man2html < Formula
  desc "Convert nroff man pages to HTML"
  homepage "https://savannah.nongnu.org/projects/man2html/"
  url "https://www.mhonarc.org/release/misc/man2html3.0.1.tar.gz"
  mirror "https://distfiles.macports.org/man2html/man2html3.0.1.tar.gz"
  sha256 "a3dd7fdd80785c14c2f5fa54a59bf93ca5f86f026612f68770a0507a3d4e5a29"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bfd9a93a20d42e7b33ebb4bd6176c6daf5a898f195daa7f5e9dcaca4d281501b" => :sierra
    sha256 "bfd9a93a20d42e7b33ebb4bd6176c6daf5a898f195daa7f5e9dcaca4d281501b" => :el_capitan
    sha256 "bfd9a93a20d42e7b33ebb4bd6176c6daf5a898f195daa7f5e9dcaca4d281501b" => :yosemite
  end

  def install
    bin.mkpath
    man1.mkpath
    system "/usr/bin/perl", "install.me", "-batch",
                            "-binpath", bin,
                            "-manpath", man
  end

  test do
    pipe_output("#{bin}/man2html", (man1/"man2html.1").read, 0)
  end
end
