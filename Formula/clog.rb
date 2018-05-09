class Clog < Formula
  desc "Colorized pattern-matching log tail utility"
  homepage "https://taskwarrior.org/docs/clog/"
  url "https://gothenburgbitfactory.org/download/clog-1.3.0.tar.gz"
  sha256 "fed44a8d398790ab0cf426c1b006e7246e20f3fcd56c0ec4132d24b05d5d2018"
  head "https://github.com/GothenburgBitFactory/clog.git", :branch => "1.4.0", :shallow => false

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "45e706af083fd1ecccddd55a8788f24bcc4c0b5214c1b858ceca2e3f1d87097f" => :high_sierra
    sha256 "e56e1b7abe60f89f102ef34c9ce4e05d4f1c7e938c474d68353fd03bd52c503f" => :sierra
    sha256 "7d83b01bd6b8eb191a55970eb86a0481666da31efe013a3045930b54797cc347" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats; <<~EOS
    Next step is to create a .clogrc file in your home directory. See 'man clog'
    for details and a sample file.
    EOS
  end

  test do
    # Create a rule to suppress any line containing the word 'ignore'
    (testpath/".clogrc").write "default rule /ignore/       --> suppress"

    # Test to ensure that a line that does not match the above rule is not suppressed
    assert_equal "do not suppress", pipe_output("#{bin}/clog --file #{testpath}/.clogrc", "do not suppress").chomp

    # Test to ensure that a line that matches the above rule is suppressed
    assert_equal "", pipe_output("#{bin}/clog --file #{testpath}/.clogrc", "ignore this line").chomp
  end
end
