class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://downloads.sourceforge.net/project/lesspipe/lesspipe/1.83/lesspipe-1.83.tar.gz"
  sha256 "d616f0d51852e60fb0d0801eec9c31b10e0acc6fdfdc62ec46ef7bfd60ce675e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e0e9a36f47883bef6355272fe3d9a05218c24a5e5aa6d664cd92e2dd7802cbee" => :sierra
    sha256 "e0e9a36f47883bef6355272fe3d9a05218c24a5e5aa6d664cd92e2dd7802cbee" => :el_capitan
    sha256 "e0e9a36f47883bef6355272fe3d9a05218c24a5e5aa6d664cd92e2dd7802cbee" => :yosemite
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
    <<-EOS
      Append the following to your #{Utils::Shell.profile}:
      export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert File.exist?("homebrew.tar.gz")
    assert_match "file2.txt",
      pipe_output("#{bin}/tarcolor", shell_output("tar tvzf homebrew.tar.gz"), 0)
  end
end
