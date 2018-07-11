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
    sha256 "084d304eebe925ce2c13978e0028f9955bf046e1b5e55877324b5936af3c319b" => :high_sierra
    sha256 "e1483adb096995649789f80ce85461e162631eac16603833402df06a5c319bd2" => :sierra
    sha256 "b88d746bded4381407c3c1e3ade7abb8fb1c78a53c6a9a152a1eb61e91afe69d" => :el_capitan
  end

  depends_on "cmake" => :build

  conflicts_with "lci", :because => "both install `lci` binaries"

  def install
    system "cmake", "."
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
