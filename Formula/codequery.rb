class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool."
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.18.1.tar.gz"
  sha256 "482fa737691c260e16adcc32bc3fd43ba50a309495faec6b2f3098b517e6c0e9"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "fcfbc18bdd83c29a8e6799fb16926c3a05612d2c9e7c9cb9085c248126d10ecb" => :sierra
    sha256 "1aae584b3d9beaf39afd9a9c91688ca8435f4e79c0cc68972b23ec1c63606f34" => :el_capitan
    sha256 "a3e50f989caa25bf4547c85b80853b66b06c1cce48a4e77a1a91d93a0d14ce6e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "qt@5.7"
  depends_on "qscintilla2"

  def install
    args = std_cmake_args
    args << "-DBUILD_QT5=ON"
    args << "-DQT5QSCINTILLA_LIBRARY=#{Formula["qscintilla2"].opt_lib}/libqscintilla2.dylib"

    share.install "test"
    mkdir "build" do
      system "cmake", "..", "-G", "Unix Makefiles", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    # Copy test files as `cqmakedb` gets confused if we just symlink them.
    test_files = (share/"test").children
    cp test_files, testpath

    system "#{bin}/cqmakedb", "-s", "./codequery.db",
                              "-c", "./cscope.out",
                              "-t", "./tags",
                              "-p"
    output = shell_output("#{bin}/cqsearch -s ./codequery.db -t info_platform")
    assert_match "info_platform", output
  end
end
