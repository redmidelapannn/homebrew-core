class UnittestCpp < Formula
  desc "Unit testing framework for C++"
  homepage "https://github.com/unittest-cpp/unittest-cpp"
  url "https://github.com/unittest-cpp/unittest-cpp/releases/download/v1.6.1/unittest-cpp-1.6.1.tar.gz"
  sha256 "5b00a217f90fe262d91d09405ef5a8b5d28063da2f701cc58af48d560c4792af"
  head "https://github.com/unittest-cpp/unittest-cpp.git"

  bottle do
    cellar :any
    sha256 "faec76485505993a35aba7c3aff487bee02c10ccb6f7cfc9cb7084629f20dbf9" => :el_capitan
    sha256 "3237d71661247b2b31cfaef7552539436093374f599f45990b219a03e02deeb6" => :yosemite
    sha256 "e73007f3bdd04567a3b3091e9e01db396acc552e96af44f81877efa631d7ebd4" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("cat /usr/local/lib/pkgconfig/UnitTest++.pc | grep Version: | cut -d' ' -f2")
  end
end
