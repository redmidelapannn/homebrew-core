class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "https://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.0.2/fpc-3.0.2.source.tar.gz"
  sha256 "67fccddf5da992356f4e90d836444750ce9363608c7db8e38c077f710fcb6258"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "82f9dec6fe3ac415f6b46f8ff10b65e1ee0e7d9d39d1a37ab2e02a298f9e0d0f" => :sierra
    sha256 "4328665556fc7fa443cd1a4eef1cdb38fe740edfc174497b3ae39ca9b3686bd3" => :el_capitan
    sha256 "9e49405c0876b943cf931361519d7ad818d270e96be64e77405fd7ac0b885c73" => :yosemite
  end

  resource "bootstrap" do
    url "ftp://ftp.freepascal.org/pub/fpc/dist/3.0.0/bootstrap/x86_64-macosx-10.7-ppcx64.tar.bz2"
    sha256 "a67ef5def356d122a4692e21b209c328f6d46deef4539f4d4506c3dc1eecb4b0"
  end

  def install
    fpc_bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage { fpc_bootstrap.install Dir["*"] }

    fpc_compiler = fpc_bootstrap/"ppcx64"
    system "make", "build", "PP=#{fpc_compiler}"
    system "make", "install", "PP=#{fpc_compiler}", "PREFIX=#{prefix}"

    bin.install_symlink lib/"#{name}/#{version}/ppcx64"

    # Prevent non-executable audit warning
    rm_f Dir[bin/"*.rsj"]

    # Generate a default fpc.cfg to set up unit search paths
    system "#{bin}/fpcmkcfg", "-p", "-d", "basepath=#{lib}/fpc/#{version}", "-o", "#{prefix}/etc/fpc.cfg"
  end

  test do
    hello = <<-EOS.undent
      program Hello;
      uses GL;
      begin
        writeln('Hello Homebrew')
      end.
    EOS
    (testpath/"hello.pas").write(hello)
    system "#{bin}/fpc", "hello.pas"
    assert_equal "Hello Homebrew", `./hello`.strip
  end
end
