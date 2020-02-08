class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20180207/mlton-20180207.src.tgz"
  version "20180207"
  sha256 "872cd98da3db720cbe05f673eaa1776d020d828713753f18fa5dd6a268195fef"
  head "https://github.com/MLton/mlton.git"
  revision 1

  bottle do
    cellar :any
    sha256 "435ab2b78b554c04020520e6bf52c36445d0309ab8af59807ffc199724a85e5c" => :catalina
    sha256 "687ba1a0ee699c736b9c94bc6a5637edd136a0a7f880b7b6d46de35e744347ca" => :mojave
    sha256 "dbb75ffe4d84256075e18b251fe6e9bef38912a28d816b5d5ef53aa4afa81228" => :high_sierra
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
