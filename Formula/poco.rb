class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.10.0/poco-1.10.0-all.tar.gz"
  sha256 "fa8bbe29da53882b053e37f94e19f2de4be85631b3186fff3bed8027427b7777"
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "40a29af1e9194eadde22a51f24004e973e0d9b06de26928c1d02ece9c3286a55" => :catalina
    sha256 "723c47f4b5c0820795ba535ab6ba2ab66b2465005aa0483aaf6d65fb96a24ebc" => :mojave
    sha256 "d798a41a7586168253097fe399fea1252a68ce868574cf41022bbacefd7989fc" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DENABLE_DATA_MYSQL=OFF",
                            "-DENABLE_DATA_ODBC=OFF"
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
