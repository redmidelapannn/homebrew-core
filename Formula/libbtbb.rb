class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2017-03-R2.tar.gz"
  version "2017-03-R2"
  sha256 "2b3ea5f07b7022e862f367e8a9a217e1d10920aecdc4eba7b7309724fb229cfd"
  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "d641398ba46eedca5a9e77e3de9af7bdd3cd14503cc3f3279e63ee58c248540d" => :high_sierra
    sha256 "e58beeda8086fa74a7d8aa0fcf857f9bad50d5eb4ccec474c876ede33d507b51" => :sierra
    sha256 "4c462ffc65edb97f9766ccbcbc39db28bcbfb0b85af1e1683e9d6c40c120c243" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python@2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
