class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20171227.tar.gz"
  sha256 "eaea0172c1f4ee4550d1b6c9ce01aab8d1ab66b4207776aa67991eb5872fdcd8"
  revision 1
  head "https://github.com/P-H-C/phc-winner-argon2.git"

  bottle do
    cellar :any
    sha256 "e8613cc77f9548c5c44271df11b469cc61cac6b3daa46ea4ebbe48b9ab09fafe" => :mojave
    sha256 "0540f9c4e057c290a010cc3e9e876569a69cb38895869c2da0a9eca9599ea93a" => :high_sierra
    sha256 "b1d84cfb2eb93d01e89374d49935fbd2c63269fd7b3c3c9cb037be2604aebd17" => :sierra
  end

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
    (buildpath/"pkgconfig/libargon2.pc").write pc_file
    lib.install "pkgconfig"
    doc.install "argon2-specs.pdf"
  end

  def pc_file; <<~EOS
    Name: libargon2
    Description: Development libraries for libargon2
    Version: #{version}
    Libs: -L#{lib} -largon2 -ldl
    Cflags: -I#{include}
    URL: https://github.com/P-H-C/phc-winner-argon2
  EOS
  end

  test do
    output = pipe_output("#{bin}/argon2 somesalt -t 2 -m 16 -p 4", "password")
    assert_match "c29tZXNhbHQ$IMit9qkFULCMA/ViizL57cnTLOa5DiVM9eMwpAvPw", output
  end
end
