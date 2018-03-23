class Xapiand < Formula
  desc "Xapiand: A RESTful Search Engine"
  homepage "http://kronuz.io/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/v1.0.0.tar.gz"
  sha256 "0cf3b349e99b48882e11ae0cc2985a7ea159dd24b82e7fd03b7d6072ce38b5e4"
  head "https://github.com/Kronuz/Xapiand.git"

  bottle do
    sha256 "3945530f00492ca45479ded1cd3ce5cc6761a9697c7fd9970506a0783b5942ec" => :high_sierra
    sha256 "4d08bfb6b2354b7fa4bc58d6c5617307bfb3267df414f19ebe426817f1e6c508" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xapian"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCCACHE_FOUND=CCACHE_FOUND-NOTFOUND", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"xapiand", "--version"
  end
end
