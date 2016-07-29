class Btparse < Formula
  desc "BibTeX utility libraries"
  homepage "https://www.gerg.ca/software/btOOL/"
  url "https://www.gerg.ca/software/btOOL/btparse-0.34.tar.gz"
  sha256 "e8e2b6ae5de85d1c6f0dc52e8210aec51faebeee6a6ddc9bd975b110cec62698"

  bottle do
    cellar :any
    revision 1
    sha256 "3962cbc3b6ae6b64b7b50af29ac719ced66e3d8a75da848cc5175eba43e2882e" => :el_capitan
    sha256 "8d8845ce7bb5eaf871a1c5c1e26268f332ca10c43375d9a4b80d3da80fc4eb34" => :yosemite
    sha256 "29b174898550016953677b066d670caad1b690ab2257ad05e64741aa409830d3" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<-EOS.undent
      @article{mxcl09,
        title={{H}omebrew},
        author={{H}owell, {M}ax},
        journal={GitHub},
        volume={1},
        page={42},
        year={2009}
      }
    EOS

    system "#{bin}/bibparse", "-check", "test.bib"
  end
end
