class Rapidjson < Formula
  desc "JSON parser/generator for C++ with SAX and DOM style APIs"
  homepage "https://miloyip.github.io/rapidjson/"
  url "https://github.com/miloyip/rapidjson/archive/v1.1.0.tar.gz"
  sha256 "bf7ced29704a1e696fbccf2a2b4ea068e7774fa37f6d7dd4039d0787f8bed98e"
  head "https://github.com/miloyip/rapidjson.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "37e3b354298236fdcc547d5e38feb68d9c01ac7b7e65d46b11c48f4dfd227369" => :mojave
    sha256 "c1896d8a540339a6642388834ba49cc40ca08d8dff11b164820f222dea9d4871" => :high_sierra
    sha256 "9799152293862baa6274079936279e01966f92e97b5b3c8dcbaa3cf9616de88c" => :sierra
    sha256 "f791e3ab8be99a5d4f6c94edf3e2469e21c11bd5673aca0bec71b15f6fbfa3e4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system ENV.cxx, "#{share}/doc/RapidJSON/examples/capitalize/capitalize.cpp", "-o", "capitalize"
    assert_equal '{"A":"B"}', pipe_output("./capitalize", '{"a":"b"}')
  end
end
