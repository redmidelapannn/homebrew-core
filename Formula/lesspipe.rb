class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://downloads.sourceforge.net/project/lesspipe/lesspipe/1.83/lesspipe-1.83.tar.gz"
  sha256 "d616f0d51852e60fb0d0801eec9c31b10e0acc6fdfdc62ec46ef7bfd60ce675e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "16b6f1daf3e3fb87c46d827a43615555ab15b95db5d8e4e07f5b7b602048a714" => :high_sierra
    sha256 "16b6f1daf3e3fb87c46d827a43615555ab15b95db5d8e4e07f5b7b602048a714" => :sierra
    sha256 "16b6f1daf3e3fb87c46d827a43615555ab15b95db5d8e4e07f5b7b602048a714" => :el_capitan
  end

  option "with-syntax-highlighting", "Build with syntax highlighting"

  deprecated_option "syntax-highlighting" => "with-syntax-highlighting"

  def install
    if build.with? "syntax-highlighting"
      inreplace "configure", '$ifsyntax = "\L$ifsyntax";', '$ifsyntax = "\Ly";'
    end

    system "./configure", "--prefix=#{prefix}", "--yes"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      Append the following to your #{shell_profile}:
      export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match /file2.txt/, shell_output("tar tvzf homebrew.tar.gz | #{bin}/tarcolor")
  end
end
