class Physfs < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://icculus.org/physfs/downloads/physfs-3.0.0.tar.bz2"
  sha256 "f2617d6855ea97ea42e4a8ebcad404354be99dfd8a274eacea92091b27fd7324"
  head "https://hg.icculus.org/icculus/physfs/", :using => :hg

  bottle do
    cellar :any
    sha256 "ad3b98e43cdf016cfeed1b37f6f5f236ceb2b1cf52933b682344dfe55439494a" => :high_sierra
    sha256 "e5ee51088a65fec520b0950b0b3831777ae5c8f6c2863817c14fe6cdba453089" => :sierra
    sha256 "4beaf748ab2792b2946b0ba5638fe6eadee5a9a9f7b18a5a093c161f42fb260f" => :el_capitan
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
