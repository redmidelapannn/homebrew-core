class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20180207/mlton-20180207.src.tgz"
  version "20180207"
  sha256 "872cd98da3db720cbe05f673eaa1776d020d828713753f18fa5dd6a268195fef"
  revision 1
  head "https://github.com/MLton/mlton.git"

  bottle do
    cellar :any
    sha256 "2c584a6e3b6e5edab670f9a35d5dad4fe3bd3b9491a03df0cec570226056308e" => :mojave
    sha256 "623b6f8313fa05a0a4fe5c9174463f1c5ec51060971dd306e443fcc5e4f6ef3f" => :high_sierra
    sha256 "c19581941cb560bffb62bcb1434ce0b7a72d17981c183f067762b505e0160056" => :sierra
  end

  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/mlton/mlton/20180207/mlton-20180207-1.amd64-darwin.gmp-static.tgz"
    sha256 "bb2d982ef97d6ef4efe078d23a09baf3e52f6fd6c8f1a60016e1624438f487b3"
  end

  def install
    # Install the corresponding upstream binary release to 'bootstrap'.
    bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage do
      args = %W[
        WITH_GMP=#{Formula["gmp"].opt_prefix}
        PREFIX=#{bootstrap}
        MAN_PREFIX_EXTRA=/share
      ]
      system "make", *(args + ["install"])
    end
    ENV.prepend_path "PATH", bootstrap/"bin"

    # Support parallel builds (https://github.com/MLton/mlton/issues/132)
    ENV.deparallelize
    args = %W[
      WITH_GMP=#{Formula["gmp"].opt_prefix}
      DESTDIR=
      PREFIX=#{prefix}
      MAN_PREFIX_EXTRA=/share
    ]
    system "make", *(args + ["all"])
    system "make", *(args + ["install"])
  end

  test do
    (testpath/"hello.sml").write <<~'EOS'
      val () = print "Hello, Homebrew!\n"
    EOS
    system "#{bin}/mlton", "hello.sml"
    assert_equal "Hello, Homebrew!\n", `./hello`
  end
end
