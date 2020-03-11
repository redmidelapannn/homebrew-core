class Lolcode < Formula
  desc "Esoteric programming language"
  homepage "https://lolcode.org/"
  # NOTE: 0.10.* releases are stable, 0.11.* is dev. We moved over to
  # 0.11.x accidentally, should move back to stable when possible.
  url "https://github.com/justinmeza/lci/archive/v0.11.2.tar.gz"
  sha256 "cb1065936d3a7463928dcddfc345a8d7d8602678394efc0e54981f9dd98c27d2"
  head "https://github.com/justinmeza/lolcode.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0dfb1a4324483b061f9edd43e99c920de1076e4434e3dc9a18e3477dc9e546f6" => :catalina
    sha256 "235b28385f68e43efa2810b20a092c7887ea678de30abe9de8e61bbcaa21a2a4" => :mojave
    sha256 "28480aea7c489b29c6db7c8f767363335ee8beb8e66a1d75aa4d535157985263" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "lci", :because => "both install `lci` binaries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    # Don't use `make install` for this one file
    bin.install "lci"
  end

  test do
    path = testpath/"test.lol"
    path.write <<~EOS
      HAI 1.2
      CAN HAS STDIO?
      VISIBLE "HAI WORLD"
      KTHXBYE
    EOS
    assert_equal "HAI WORLD\n", shell_output("#{bin}/lci #{path}")
  end
end
