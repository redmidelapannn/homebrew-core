class Rapidjson < Formula
  desc "JSON parser/generator for C++ with SAX and DOM style APIs"
  homepage "https://miloyip.github.io/rapidjson/"
  url "https://github.com/miloyip/rapidjson/archive/v1.1.0.tar.gz"
  sha256 "bf7ced29704a1e696fbccf2a2b4ea068e7774fa37f6d7dd4039d0787f8bed98e"
  head "https://github.com/miloyip/rapidjson.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5afb166fc604c2d2f33aa79e22af597dbf6553aadefe1e8defeacb66e87d6031" => :mojave
    sha256 "426d525f21d72f197adbc41ac8a002d8af321c80efd86dff3d95930266c0039f" => :high_sierra
    sha256 "5fcf0885306579a8a3b0355fb87fa33ae898d8c3b5b960be6d605d388c299042" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  conflicts_with "mesos", :because => "mesos installs a copy of rapidjson headers"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system ENV.cxx, "#{share}/doc/RapidJSON/examples/capitalize/capitalize.cpp", "-o", "capitalize"
    assert_equal '{"A":"B"}', pipe_output("./capitalize", '{"a":"b"}')
  end
end
