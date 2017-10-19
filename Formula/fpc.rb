class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "https://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.0.2/fpc-3.0.2.source.tar.gz"
  sha256 "67fccddf5da992356f4e90d836444750ce9363608c7db8e38c077f710fcb6258"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "43f28b561cd3787019ead88c691ebb889256a51da47ebb68f7e32fb0fe019618" => :high_sierra
    sha256 "9807338f7897f7253a5a963443a67c0535ae99bb0cedea998bb88359fde13431" => :sierra
    sha256 "742218621fc5528e78a7460605bfbb031cde26374b2d24bf85307646e2699189" => :el_capitan
  end

  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/freepascal/Bootstrap/3.0.0/x86_64-macosx-10.7-ppcx64.tar.bz2"
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
