class Libyang < Formula
  desc "YANG data modelling language parser, toolkit, and API written in C"
  homepage "https://github.com/CESNET/libyang"
  url "https://github.com/CESNET/libyang/", :using => :git, :tag => "v1.0-r2", :revision => "347246611b85e05d16f54faaa5697c4b2ee4b468"
  version "1.0-r2"
  sha256 "02b0131587cc677cbda1b153f9a9190e03e6143ee90252a68e5500b05e61170b"
  head "https://github.com/CESNET/libyang/"
  bottle do
    sha256 "f587643016099071bdaff0bff71a2060ef624bf9491f58e0acce2b1ed1db0519" => :mojave
    sha256 "f4fe2350014fef39100578667c302230683c31d1880e075b581d0243ef2c9e42" => :high_sierra
    sha256 "96e6c8dffb790992dd965706b620d93ed0bf58ffafd6bb19fabf0337791f63af" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pcre"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "true"
  end
end
