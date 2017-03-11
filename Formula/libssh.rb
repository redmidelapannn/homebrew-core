class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/210/libssh-0.7.4.tar.xz"
  sha256 "39e1bec3b3cb452af3b8fd7f59c12c5ef5b9ed64f057c7eb0d1a5cac67ba6c0d"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "4dbf093fe8918525916e5ed04df4a84bd25ea9b2f1e803b081125a9eb050d548" => :sierra
    sha256 "a416cee822cc699ca1725422f1beb7ba63991f0f7347c64f705f3e91ad2ac8a5" => :el_capitan
    sha256 "5bb6bbd569bd808353d6ccd1e537410fb53829d91cd0ee85c770d13b201641f1" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_STATIC_LIB=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libssh/libssh.h>
      #include <stdlib.h>
      int main()
      {
        ssh_session my_ssh_session = ssh_new();
        if (my_ssh_session == NULL)
          exit(-1);
        ssh_free(my_ssh_session);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lssh",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
