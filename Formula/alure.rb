class Alure < Formula
  desc "Manage common tasks with OpenAL applications"
  homepage "https://kcat.strangesoft.net/alure.html"
  url "https://kcat.strangesoft.net/alure-releases/alure-1.2.tar.bz2"
  sha256 "465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71"
  revision 1

  bottle do
    cellar :any
    sha256 "e8572f815728f9d0c50fdfabd5aa072a4afe4ef5c4b0452b9ecbecc5717c40b6" => :catalina
    sha256 "0d8c46b3835606ad6e74448f626fbb3102e3227fbeffbee3e5eb8d808b41d39a" => :mojave
    sha256 "3c36a1097d7e9924aaad1455b7509f9390564f39b0c91e3eebf36aca92417323" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # Fix missing unistd include
  # Reported by email to author on 2017-08-25
  if MacOS.version >= :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/eed63e836e/alure/unistd.patch"
      sha256 "7852a7a365f518b12a1afd763a6a80ece88ac7aeea3c9023aa6c1fe46ac5a1ae"
    end
  end

  def install
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"alureplay", test_fixtures("test.wav")
  end
end
