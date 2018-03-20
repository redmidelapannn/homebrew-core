class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.3.1.tar.gz"
  sha256 "a3e8ab25dc53160da5e4bef58fe91107909ade6f93523227a935c5330d3ea8f7"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "36f93228ab49e5156e6c7a66b987da9b8ed447bb7f452e2e4ba41b5a799fe5a3" => :high_sierra
    sha256 "2e57215d292a85220bd50391d6f7c87aed546528b8e7fd1076dc4e7200733926" => :sierra
    sha256 "00b9b9027f816b96cd80536c7057ac5b380b3b95a6796a7f0a1754cbb39eaa0f" => :el_capitan
  end

  depends_on "ghc@8.2" => :build
  depends_on "haskell-stack" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "stack", "-j#{ENV.make_jobs}", "--system-ghc", "--no-install-ghc",
           "--local-bin-path=#{bin}", "install"

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark-c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
