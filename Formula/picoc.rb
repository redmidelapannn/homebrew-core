class Picoc < Formula
  desc "C interpreter for scripting"
  homepage "https://gitlab.com/zsaleeba/picoc"
  revision 1
  head "https://gitlab.com/zsaleeba/picoc.git"

  stable do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/picoc/picoc-2.1.tar.bz2"
    mirror "https://dl.bintray.com/homebrew/mirror/picoc-2.1.tar.bz2"
    sha256 "bfed355fab810b337ccfa9e3215679d0b9886c00d9cb5e691f7e7363fd388b7e"

    # Remove for > 2.1
    # Fix abort trap due to stack overflow
    # Upstream commit from 14 Oct 2013 "Fixed a problem with PlatformGetLine()"
    patch do
      url "https://gitlab.com/zsaleeba/picoc/commit/ed54c519169b88b7b40d1ebb11599d89a4228a71.diff"
      sha256 "45b49c860c0fac1ce2f7687a2662a86d2fcfb6947cf8ad6cf21e2a3d696d7d72"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1f5805e5cbc046fed0ee4117218d7e3118e1cbe14544ab83bd3c2481ef061c74" => :catalina
    sha256 "e7047263f1403e28829d32cc535644d821a58885c421138dddedd487753dc66a" => :mojave
    sha256 "a03e245dd402d70ade14b5ee4a78131e71cf16de1f69cc41e2a8958df0b7ded2" => :high_sierra
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags} -DUNIX_HOST"
    bin.install "picoc"
  end

  test do
    (testpath/"brew.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        printf("Homebrew\n");
        return 0;
      }
    EOS
    assert_match "Homebrew", shell_output("#{bin}/picoc brew.c")
  end
end
