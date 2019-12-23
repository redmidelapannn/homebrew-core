class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.3.10.tar.xz"
  sha256 "c6a792f4127b8059bc446fb32391e6633811f45748d7d7ba873d7028362f5e3e"
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    cellar :any
    sha256 "f0db318423ae20fbe075ccccccd7a0affa855a1cc57438ca9f44639bb872e001" => :catalina
    sha256 "ac543015948d0f4068ffc45c24ae09129ebaef9971d5301ffe43787f3146e4f2" => :mojave
    sha256 "bf005e877a8b7abdef3fc39c5964ad202ab6797ab1467c3209bc947ac4cdf70a" => :high_sierra
    sha256 "60249b3b2a0d6b4c18bd5ee8eb9a475b5a8622c5919b0e22962ce2232b691728" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
