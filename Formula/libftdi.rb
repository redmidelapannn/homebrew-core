class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.3.tar.bz2"
  sha256 "9a8c95c94bfbcf36584a0a58a6e2003d9b133213d9202b76aec76302ffaa81f4"

  bottle do
    cellar :any
    sha256 "e0d0b8364f93d9c65986e6c5d55e92eda187acf968f2a476a0502602146c8da2" => :el_capitan
    sha256 "ceac4b4dc74e76e0c09ec057045696e326b60c5343342e42ff4f7c7445fc9820" => :yosemite
    sha256 "e3079b71e451eef5277b31cacba7075f0579885f2c6ddd6ef8349d6eb20f1175" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "boost" => :optional
  depends_on "confuse" => :optional

  def install
    mkdir "libftdi-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
