class Physfs < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://icculus.org/physfs/downloads/physfs-2.0.3.tar.bz2"
  sha256 "ca862097c0fb451f2cacd286194d071289342c107b6fe69079c079883ff66b69"
  head "https://hg.icculus.org/icculus/physfs/", :using => :hg

  bottle do
    cellar :any
    rebuild 2
    sha256 "ec873625d289530b26c8bf18d5284a8e3c04cf4f364acd80ced4b898275851ca" => :sierra
    sha256 "3c625c074a2c0b691e567c1953bd513ab085a4b2d4eded7d8ddaba23299464de" => :el_capitan
    sha256 "e73fe57dfc5a8513aa7e11eee07b8a47bab5216afe5ec81d58579f88dbec8a6b" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    mkdir "macbuild" do
      args = std_cmake_args
      args << "-DPHYSFS_BUILD_TEST=TRUE"
      args << "-DPHYSFS_BUILD_WX_TEST=FALSE" unless build.head?
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.txt").write "homebrew"
    system "zip", "test.zip", "test.txt"
    (testpath/"test").write <<-EOS.undent
      addarchive test.zip 1
      cat test.txt
      EOS
    assert_match /Successful\.\nhomebrew/, shell_output("#{bin}/test_physfs < test 2>&1")
  end
end
