class PhysfsAT2 < Formula
    desc "Library to provide abstract access to various archives"
  bottle do
    cellar :any
    sha256 "d02c8c5992dbbb3fff55e3d57d4ae9cdd6d2cdbc071720b2a0deff42e5c2a2f1" => :mojave
    sha256 "dc06605cb7db74b53db70b2f4067b46d9b9dd5eb437f4b5492431ef98f594718" => :high_sierra
    sha256 "ca97e32c0dbc798bfa5a7ed6e3e9c0e904384e3961947184f27489c82dcb974f" => :sierra
  end

    homepage "https://icculus.org/physfs/"
    url "https://icculus.org/physfs/downloads/physfs-2.0.3.tar.bz2"
    sha256 "ca862097c0fb451f2cacd286194d071289342c107b6fe69079c079883ff66b69"
  
    depends_on "cmake" => :build
  
    def install
      mkdir "macbuild" do
        args = std_cmake_args
        args << "-DPHYSFS_BUILD_TEST=TRUE"
        args << "-DPHYSFS_BUILD_WX_TEST=FALSE"
        system "cmake", "..", *args
        system "make", "install"
      end
    end
  
    test do
      (testpath/"test.txt").write "homebrew"
      system "zip", "test.zip", "test.txt"
      (testpath/"test").write <<~EOS
        addarchive test.zip 1
        cat test.txt
      EOS
      assert_match /Successful\.\nhomebrew/, shell_output("#{bin}/test_physfs < test 2>&1")
    end
  end