class Googletest < Formula
  desc "Google Test, Google's C++ test framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
  sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  bottle do
    cellar :any_skip_relocation
    sha256 "fff0a4571dc214f80e91010a0be98edd66ef9abc70e5850236ba71a61cd6e975" => :high_sierra
    sha256 "36bbda59d02b28c2704df31ae96f42f4028a5cac375f6e370473c8be898a3fbc" => :sierra
    sha256 "66f643ccbabc7ae217da5d800020e3a244994b40130bea0105e1d084861e4d77" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
