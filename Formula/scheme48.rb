class Scheme48 < Formula
  desc "Scheme byte-code interpreter"
  homepage "http://www.s48.org/"
  url "http://s48.org/1.9.2/scheme48-1.9.2.tgz"
  sha256 "9c4921a90e95daee067cd2e9cc0ffe09e118f4da01c0c0198e577c4f47759df4"

  bottle do
    rebuild 2
    sha256 "0b2edece2802af6e04f2d284f25de9d0708c9e720bec1b021e98971082e16d2c" => :sierra
    sha256 "bf67dde1f3deb28b906c19cc313919fe31a18b086794996e57bfe8e049791738" => :el_capitan
    sha256 "2571724be48c2e2e469cac952161fcfb006826fc14df463cd582daf3326896fc" => :yosemite
  end

  def install
    ENV.O0 if ENV.compiler == :clang
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-gc=bibop"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.scm").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS

    expected = <<-EOS.undent
      Hello, World!\#{Unspecific}

      \#{Unspecific}

    EOS

    assert_equal expected, shell_output("#{bin}/scheme48 -a batch < hello.scm")
  end
end
