class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.28.3.tar.gz"
  sha256 "acc98685d3c1b515ff787ac7c994188dadaf28a2d700c10c1221da4199bae1fc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "43a404b751510aa4c5e127b2eeea01bfe96ffbea84ad40315e1d3a7fb303d16c" => :mojave
    sha256 "f9c1680fc66b761178882bf7149cfd42543fae3680b1688ba90704d7f6e8fb6c" => :high_sierra
    sha256 "1fcd362960b781c41741ebac61bf5bc84232e0ddc750c54679ada3a4c2c22b28" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
