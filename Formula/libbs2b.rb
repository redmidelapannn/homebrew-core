class Libbs2b < Formula
  desc "Bauer stereophonic-to-binaural DSP"
  homepage "https://bs2b.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bs2b/libbs2b/3.1.0/libbs2b-3.1.0.tar.gz"
  sha256 "6aaafd81aae3898ee40148dd1349aab348db9bfae9767d0e66e0b07ddd4b2528"

  bottle do
    cellar :any
    rebuild 2
    sha256 "a4b25a00fdef0b9d758c11beba2a3e50e7ccfd9fdde6a0ff02dba0fd0ada320f" => :catalina
    sha256 "0c619cee58a5163d89a5bf7d08ad1fbb12d92488d9359c7b01236efd962752d0" => :mojave
    sha256 "7d118599b12923bb693ffd2ec817c76e36201d629c606bc66ee3f92d6f24d138" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libsndfile"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-static",
                          "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <bs2b/bs2b.h>

      int main()
      {
        t_bs2bdp info = bs2b_open();
        if (info == 0)
        {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lbs2b", "test.c", "-o", "test"
    system "./test"
  end
end
