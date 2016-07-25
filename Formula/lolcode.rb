class Lolcode < Formula
  desc "An esoteric programming language"
  homepage "http://lolcode.org"
  sha256 "cb1065936d3a7463928dcddfc345a8d7d8602678394efc0e54981f9dd98c27d2"
  head "https://github.com/justinmeza/lolcode.git"
  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "74920cea828644c7ad0fe3b12ee5c9a4c06a46ec37c2826280327e37e30f5513" => :el_capitan
    sha256 "9040ac184ba8a632f73a4c9e2aac69a8cc639705217756333abaf76913e13110" => :yosemite
    sha256 "12d9c24cb14c786df1c96d5741283f4e97d1ebfec13d38adb7707ffd1148f038" => :mavericks
  end

  # note: 0.10.* releases are stable versions, 0.11.* are dev ones
  url "https://github.com/justinmeza/lci/archive/v0.11.2.tar.gz"

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
    path.write <<-EOS.undent
      HAI 1.2
      CAN HAS STDIO?
      VISIBLE "HAI WORLD"
      KTHXBYE
    EOS

    assert_equal "HAI WORLD\n", shell_output("#{bin}/lci #{path}")
  end
end
