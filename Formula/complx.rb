class Complx < Formula
  desc "The LC-3 Simulator used in Georgia Tech CS2110."
  homepage "https://github.com/TricksterGuy/complx"
  url "https://github.com/TricksterGuy/complx.git", :using => :git, :revision => "dc81110be4d2338f17ec276f2a80fc5aad765b78", :tag => "4.15.0"

  bottle do
    sha256 "b909b4032daa891269fe61c019e40f76cd7ad07344f2fe38ba3834224132df3d" => :sierra
    sha256 "66f0ab47190838c79fab2aeb887e35371c1f1065768b50f034dce207c8164e86" => :el_capitan
    sha256 "b1393d03f7f66650e83941c3628ed96604c86254517299c4864d0b0b73796534" => :yosemite
  end

  # This pulls from the master branch instead of the specified version tag
  head do
    url "https://github.com/TricksterGuy/complx.git", :using => :git, :branch => "master"
  end

  depends_on "cmake" => :build
  depends_on "wxmac" => :build

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
