class Complx < Formula
  desc "The LC-3 Simulator used in Georgia Tech CS2110."
  homepage "https://github.com/TricksterGuy/complx"
  url "https://github.com/TricksterGuy/complx.git", :using => :git, :revision => "dc81110be4d2338f17ec276f2a80fc5aad765b78", :tag => "4.15.0"

  bottle do
    sha256 "3b7a3303d08ae2f4ecee8719c8ffc1cf451e58d5c8481469b21e6bc9770b3949" => :sierra
    sha256 "05994cff5eca158f2f22df4bdccd21de0e8a337785a899146048a0b8f93993c6" => :el_capitan
    sha256 "e78f3205d7c27619b8734ef4e3f50c995c7c4a9883da300418e3a6a44114d0a9" => :yosemite
  end

  # This pulls from the master branch instead of the specified version tag
  head do
    url "https://github.com/TricksterGuy/complx.git", :using => :git, :branch => "master"
  end

  depends_on "cmake" => :build
  depends_on "wxmac" => :required

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/complx", "--help"
  end
end
